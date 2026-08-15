;;; dh-elpa.el --- package.el style packages for Debian  -*- lexical-binding:t -*-

;; Copyright (C) 2015 David Bremner & contributors
;; Portions Copyright 2007-2015 The Free Software Foundation

;; Author: David Bremner <bremner@debian.org>
;; Created: 11 July 2015
;; Keywords: tools
;; Package-Requires: ((tabulated-list "1.0"))

;; This file is NOT part of GNU Emacs.

;; dh-elpa  is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; dh-elpa is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with dh-elpa.  If not, see <http://www.gnu.org/licenses/>.

(require 'package)
(require 'cl-lib)

;; Originally package-unpack from package.el in Emacs 24.5
(defun dhelpa-unpack (pkg-desc destdir &optional epoch-time)
  "Install the contents of the current buffer into DESTDIR as a package.
Optional argument EPOCH-TIME specifies time (as a string or
number) to use in autoload files; if unspecifed or nil the
current time is used."
  (let* ((name (package-desc-name pkg-desc))
         (dirname (package-desc-full-name pkg-desc))
	 (pkg-dir (expand-file-name dirname destdir))
	 (pkg-time (if epoch-time (seconds-to-time
				   (if (stringp epoch-time)
				       (string-to-number epoch-time)
				     epoch-time))
		     (current-time)))
	 (backup-inhibited t))
    (make-directory pkg-dir t)
    (pcase (package-desc-kind pkg-desc)
      (`tar
       (let ((default-directory (file-name-as-directory destdir)))
	 (package-untar-buffer dirname)))
      (`single
       (let ((el-file (expand-file-name (format "%s.el" name) pkg-dir)))
         (package--write-file-no-coding el-file)))
      (kind (error "Unknown package kind: %S" kind)))
    (defun dhelpa-autoload-insert-section-header (real-fun outbuf autoloads load-name file time)
      (funcall real-fun outbuf autoloads load-name file  pkg-time))
    (advice-add #'autoload-insert-section-header
		:around #'dhelpa-autoload-insert-section-header)
    (package--make-autoloads-and-stuff (dhelpa-filter-pkg-desc pkg-desc) pkg-dir)
    (advice-remove #'autoload-insert-section-header
		   #'dhelpa-autoload-insert-section-header)
    pkg-dir))

;; Originally package-buffer-info from package.el in Emacs 24.5.1
(defun dhelpa-buffer-info ()
  "Return a `package-desc' describing the package in the current buffer.

If the buffer does not contain a conforming package, signal an
error.  If there is a package, narrow the buffer to the file's
boundaries.

If there is no version information, try DEB_UPSTREAM_VERSION and
then DEB_VERSION_UPSTREAM, signalling an error if they are both
set and disagree."
  (goto-char (point-min))
  (unless (re-search-forward "^;;; \\([^ ]*\\)\\.el ---[ \t]*\\(.*?\\)[ \t]*\\(-\\*-.*-\\*-[ \t]*\\)?$" nil t)
    (error "Package lacks a file header"))
  (let ((file-name (match-string-no-properties 1))
	(desc      (match-string-no-properties 2))
	(start     (line-beginning-position)))
    (unless (search-forward (concat ";;; " file-name ".el ends here"))
      (error "Package lacks a terminating comment"))
    ;; Try to include a trailing newline.
    (forward-line)
    (narrow-to-region start (point))
    (require 'lisp-mnt)
    ;; Use some headers we've invented to drive the process.
    (let* ((requires-str (lm-header "package-requires"))
	   ;; Prefer Package-Version; if defined, the package author
	   ;; probably wants us to use it.  Otherwise try Version.
	   (pkg-version
	    (or (package-strip-rcs-id (lm-header "package-version"))
                (package-strip-rcs-id (lm-header "version"))
                (dhelpa-getenv-version)))
           (homepage (lm-homepage)))
      (unless pkg-version
	(error
         "Package lacks a \"Version\" or \"Package-Version\"
header, and neither of the DEB_UPSTREAM_VERSION and
DEB_VERSION_UPSTREAM environment variables are set."))
      (package-desc-from-define
       file-name pkg-version desc
       (if requires-str
           (package--prepare-dependencies
            (package-read-from-string requires-str)))
       :kind 'single
       :url homepage))))

(defun dhelpa-getenv-version ()
  "Return the package version as found in standard DEB_* environment variables.

Try DEB_UPSTREAM_VERSION first, then DEB_VERSION_UPSTREAM.
Signal an error if these are both set and they disagree.

Versions taken from environment variables are run through
`dhelpa-sanitise-version'."
  ;; If one of these environment variables is the empty string, it's
  ;; as good as unset, so we replace that with the nil value.
  (let* ((upstream-version (null-empty-string
                            (getenv "DEB_UPSTREAM_VERSION")))
         (version-upstream (null-empty-string
                            (getenv "DEB_VERSION_UPSTREAM")))
         (version (if upstream-version upstream-version version-upstream))
         (sanitised-version (dhelpa-sanitise-version version)))
    ;; sanity check #1
    (if (and upstream-version
             version-upstream
             (not (string= upstream-version version-upstream)))
        (error "The DEB_UPSTREAM_VERSION and DEB_VERSION_UPSTREAM
environment variables are both set, but they disagree.")
      ;; sanity check #2
      (unless (ignore-errors (version-to-list sanitised-version))
        (error (concat "E: The Debian version " version " cannot be used as an ELPA version.
See dh_elpa(1) HINTS for how to deal with this.")))
      ;; if we got this far, return it
      sanitised-version)))

;;;###autoload
(defun dhelpa-sanitise-version (version)
  "Sanitise a Debian version VERSION such that it will work with Emacs.

Our goal is to ensure that ELPA package versions are sorted
correctly relative to other versions of the package the user
might have installed in their home directory.

To do this:

- we remove all indication of backporting, since that is a matter
  of Debian packaging and shouldn't affect the ELPA package
  content

- we replace '~' with '-' -- Emacs interprets '-rc', '-git' and
  '-pre' similar to how dpkg interprets '~rc', '~git' and
  '~pre' (see `version-to-list')

This will not give the right answer in all cases (for example
'~foo' where 'foo' is not one of the strings Emacs recognises as
a pre-release).  The Debian package maintainer should patch the
upstream source to include a proper Package-Version: header in
such a case."
  (when version
    (replace-regexp-in-string
     "ubuntu.*$" ""
    (replace-regexp-in-string
     "build.*$" ""
    (replace-regexp-in-string
     "~" "-"
     (replace-regexp-in-string "~bpo.*$" "" version))))))

(defun null-empty-string (str)
  "If STR is a string of length zero, return nil.  Otherwise, return STR."
  (if (and (stringp str)
           (zerop (length str)))
      nil
    str))

(defun dhelpa-filter-deps-for-debian (deps)
  "Filter a list of package.el deps DEPS for Debian.

Remove packages that are maintained outside of the elpa-*
namespace in Debian, plus Emacs itself.

Also remove built-in packages, except those built-in packages
that are also packaged separately in Debian.

These are packaged separately for two reasons:

- it allows us to provide newer versions than those in Emacs core

- it permits use of addons with older versions of Emacs, for
  which the dependency is not yet a built-in package."
  (let ((non-elpa (list 'emacs))
        (packaged-separately (list 'let-alist 'seq 'xref 'project)))
    (cl-remove-if (lambda (dep) (let ((pkg (car dep)))
                      (or (memq pkg non-elpa)
                          (and
                           (package-built-in-p pkg)
                           (not (memq pkg packaged-separately))))))
                  deps)))

(defun dhelpa-filter-pkg-desc (desc)
  "Filter the dependencies of package description DESC for Debian."
  (let ((our-desc (copy-package-desc desc)))
    (cl-callf dhelpa-filter-deps-for-debian (package-desc-reqs our-desc))
    our-desc))

(defun dhelpa-debianise-deps (deps)
  "Convert a list of package.el deps DEPS to debian/control format."
  (mapconcat
   (lambda (dep)
     (let ((pkg-name (format "elpa-%s" (car dep)))
           (pkg-ver (mapconcat 'number-to-string (car (cdr dep)) ".")))
       (concat pkg-name " (>= " pkg-ver ")")))
   deps ", "))

;; Write out (partial) package description in a form easily parsed by
;; non-lisp tools.
(defun dhelpa-write-desc (desc dest)
  (let* ((name (package-desc-name desc))
	 (version (package-version-join (package-desc-version desc)))
	 (deps (dhelpa-debianise-deps (package-desc-reqs (dhelpa-filter-pkg-desc desc))))
	 (desc-file (expand-file-name (format "%s.desc" name) dest)))
    (with-temp-file desc-file
      (insert (format "ELPA-Name: %s\n" name))
      (insert (format "ELPA-Version: %s\n" version))
      (insert (format "ELPA-Requires: %s\n" deps)))))

;;;###autoload
(defun dhelpa-install-from-buffer (destdir &optional epoch-time)
  "Install a package from the current buffer into DESTDIR.
The current buffer is assumed to be a single .el or .tar file
that follows the packaging guidelines; see info
node `(elisp)Packaging'. If EPOCH-TIME is non-nil, it specifies
the time (in seconds since the epoch) to be used in the generated
autoload files."
  (interactive "D")
  (let ((pkg-desc (if (derived-mode-p 'tar-mode)
                      (package-tar-file-info)
                    (dhelpa-buffer-info))))
    (dhelpa-unpack pkg-desc destdir epoch-time)
    pkg-desc))

;;;###autoload
(defun dhelpa-batch-install-file ()
  "Install third command line argument (an emacs lisp file or tar
file) into second command line argument (a directory). The
optional fourth argument specifies a destination for a package
description file."
  (apply #'dhelpa-install-file command-line-args-left))

;;;###autoload
(defun dhelpa-batch-install-directory ()
  "Install third command line argument (a directory containing a
multifile elpa package) into second command line argument (a
directory). An optional third command line argument specifies
where to make temporary files and write a descriptor file."
  (apply #'dhelpa-install-directory command-line-args-left))

;;;###autoload
(defun dhelpa-install-file (dest el-file &optional desc-dir epoch-time)
  "Install EL-FILE (an emacs lisp file or tar file) into DEST (a directory).
Optional DESC-DIR specifies where to write a simplified package description file.
Optional EPOCH-TIME specifies time to use in the generated autoload files."
  (with-temp-buffer
    (insert-file-contents-literally el-file)
    (when (string-match "\\.tar\\'" el-file) (tar-mode))
    (let ((desc (dhelpa-install-from-buffer (expand-file-name dest) epoch-time)))
      (when desc-dir
	(dhelpa-write-desc desc desc-dir)))))

;;;###autoload
(defun dhelpa-install-directory (dest elpa-dir &optional work-dir epoch-time)
  "Install ELPA-DIR (an unpacked elpa tarball) into DEST (a directory).
The directory must either be named `package' or
`package-version'. If a working directory WORK-DIR is specified,
cleaning up is the caller's responsibility. Optional EPOCH-TIME
specifies time to use in generated autoloads files."
  (unless (file-exists-p
           (expand-file-name (package--description-file elpa-dir) elpa-dir))
    (dhelpa-generate-pkg-file elpa-dir))
  (let ((desc (package-load-descriptor elpa-dir)))
    (if (not desc)
	(message "Could not compute version from directory %s" elpa-dir)
      (let* ((canonical-dir (package-desc-full-name desc))
	     (base-dir (file-name-nondirectory elpa-dir))
	     (parent-dir (file-name-directory elpa-dir))
	     (temp-dir (or work-dir (make-temp-file nil t)))
	     (tar-file (concat (expand-file-name canonical-dir temp-dir) ".tar"))
	     ;; this relies on GNU tar features.
	     (transform-command (concat "--transform=s/"
					(regexp-quote base-dir) "/" canonical-dir "/")))
	(call-process "tar" nil nil nil "--create" "-C" parent-dir transform-command
		      "--file" tar-file base-dir)
	(dhelpa-install-file dest tar-file work-dir epoch-time)
	(unless work-dir
	  (delete-file tar-file)
	  (delete-directory temp-dir))))))

(defun dhelpa-generate-pkg-file (pkg-dir)
  "Generate PKG-DIR/foo-pkg.el by consulting PKG-DIR/foo.el."
  (let* ((pkg-file (expand-file-name (package--description-file pkg-dir) pkg-dir))
         (root-file (replace-regexp-in-string "-pkg" "" pkg-file))
         (pkg-desc
          (condition-case nil
              (with-temp-buffer
                (find-file root-file)
                (dhelpa-buffer-info))
            (error (progn
                     (message "dh_elpa: couldn't generate -pkg file; please write one")
                     (kill-emacs -1)))))
         (filtered-pkg-desc (dhelpa-filter-pkg-desc pkg-desc)))
    ;; although the docstring for `package-generate-description-file'
    ;; says that it generates a description for single-file packages,
    ;; there is in fact no difference between the descriptions for
    ;; single-file and multifile packages
    (package-generate-description-file filtered-pkg-desc pkg-file)))

;;; dh-elpa.el ends here
