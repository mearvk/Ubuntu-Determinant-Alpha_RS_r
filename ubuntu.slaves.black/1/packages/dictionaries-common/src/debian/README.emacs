# -*- readme-debian -*-

Why shipping ispell.el and flyspell.el, already included in {X,}Emacs?
---------------------------------------------------------------------

Note that they are not the same as those shipped by {X,}Emacs.

They follow those in GNU Emacs trunk, so they are usually way more
recent than those shipped with normal GNU Emacs releases, but older
than real files in trunk. They are also patched to work with XEmacs
and to provide a common *spell interface to all emacsen flavors in
Debian, with integration of dictionaries system.

Why dictionaries-common {i,f}lyspell.el are not enabled and byte-compiled for emacs-snapshot?
---------------------------------------------------------------------------------------------

Note that, while many people finds emacs-snapshot very useful for
daily use, it is mostly development code, and emacs-snapshot is a way
to help with testing, bug hunting and fixing for that development
code, which will go into next GNU Emacs release. Masking it with
foreign code might hide real bugs, and that is not we want.

The only minor difference expected in the long term is that with
dictionaries-common files you get some info about dictionaries in the
pop-up menu. However, ispell-change-dictionary will show all in both
cases, so this is somewhat cosmetic.

Some other improvements may be temporarily present in
dictionaries-common files until they are adapted and committed to
upstream trunk. This last seems the best way to make them available
to emacs-snapshot users/testers, better than byte-compiling older
code for emacs-snapshot.

Other changes are mostly changes for compatibility with XEmacs and
older GNU Emacs versions, so no benefit at all for emacs-snapshot
users.

Selecting a default dictionary locally
--------------------------------------

Put something like

(setq ispell-dictionary "british")

for your favorite language in your {x}emacs configuration file.

Another (better?) way of doing this is through

M-x customize-variable ispell-dictionary

similarly to ispell-program-name or ispell-local-dictionary-alist.
Note that emacs and xemacs save this customizations in different
files, so you will need to do this for both.

To select a dictionary for a given file, use ispell-local-dictionary
in file's 'Local Variables:' section.

Using ispell and hunspell with ispell.el
----------------------------------------

Ispell.el assumes you use aspell if available. If you use ispell write

(setq ispell-program-name "ispell")

in your {x}emacs configuration file. Use "hunspell" if you want to
use hunspell.

Another (better?) way of doing this is through

M-x customize-variable ispell-program-name

similarly to ispell-local-dictionary or ispell-local-dictionary-alist.
Note that emacs and xemacs save this customizations in different
files, so you will need to do this for both.

Force disabling of dictionaries-common emacsen-stuff
----------------------------------------------------

If you want to always use original {ispell,flyspell}.el instead of
those provided by Debian dictionaries-common you should edit the
file

/etc/emacs/site-start.d/50dictionaries-common.el

and add your flavor to the `skip-emacs-flavors-list' list.

ispell.el loading at start-up
----------------------------

Emacs comes dumped with an ispell-menu-map containing a set of
dictionaries that won't be what's actually present. To make it match the
actually installed dictionaries some magic is needed.

That previously required force loading of ispell.el even if you do not
intend to use it at all. This is *no longer* the case, and good menus
will be shown without actually loading ispell.el.

If for whichever reason you need to load it from your emacs
initialization file, make sure that is done *after* any local definition
of ispell-local-dictionary, ispell-program-name or
ispell-local-dictionary-alist.

Spell-checking utf-8 buffers
----------------------------

Spell-checking utf-8 buffers should be internally handled by most {x}emacs
if buffer-file-coding-system is set to the encoding instead to 'undecided'
or equivalent without the need of having a specific utf-8 dictionary entry.
Notably xemacs21-nomule does not support that. ispell.el will recode that
UTF-8 to the encoding declared by the dictionary when sending strings and
the other way back when receiving them. That should be transparent to the
user, unless the original UTF-8 has characters that cannot be recoded to
the single byte encoding, leading to misalignment errors (like in #205516).

However this is not available out-of-the-box for all encodings. If this is
not working for you, please try installing package 'mule-ucs'. The drawback
is that your emacs start-up will become (much) slower. Remember, this will
not work for xemacs21-nomule.

Adding customized entries for emacs
-----------------------------------

*NOTE*: Setting directly `ispell-dictionary-alist' no longer works, use
        `ispell-local-dictionary-alist' as described below. This is by far
    	more standard, while previous implementation was not.

You can currently do this in two ways in your {x}emacs configuration file,

The classical one, e.g., for aspell (see below for possible ispell differences)

(setq ispell-local-dictionary-alist
      (append ispell-local-dictionary-alist
	      '(("british+accs"                           ; British version
		 "[A-Z\321\324a-z\361\364]"
		 "[^A-Z\321\324a-z\361\364]"
		 "[']"
		 nil
		 ("-B" "-d" "british-w_accents")
		 nil
		 iso-8859-1))))

For ispell please check first that any accented char being added
to the Casechars/Not-Casechars sections is enabled in the corresponding
ispell aff file. Otherwise you should explicitly enable them. In the
above example that would lead to something like

 ("-B" "-d" "british-w_accents" -w "\321\324\361\364")

instead of the original line.

You can also use the equivalent variant with

(add-to-list 'ispell-local-dictionary-alist
 ...
)

Another (better?) variant for doing this is through

M-x customize-variable ispell-local-dictionary-alist

similarly to `ispell-program-name' or `ispell-local-dictionary'.
Note that emacs and xemacs save this customizations in different
files, so you will need to do this for both.

In all cases some dummy accented characters have been added. This should
work in all systems, including emacs-snapshot (where ispell-dictionary-alist
is no longer a defcustom) and is the currently recommended way.

In any case, better use octal codes as above for the accented
characters rather than the character itself. This will save you some
problems with editors and with emacs itself.

You can use the above to define entries with different personal
dictionaries, e.g.,

("-B" "-d" "british-w_accents" "-p" "/home/joe/my_personal_dictionary")

Keep in mind that personal dictionary format is different for ispell
than for aspell, so they cannot be shared.

The non-standard debian-ispell.el provided function
(debian-ispell-add-dictionary-entry) is now obsoleted and will trigger
an error message. Please modify your ~/.emacs to use any of the above
ways to personalize `ispell-local-dictionary-alist'

Some other tips for flyspell.el
-------------------------------

To enable flyspell-mode for special buffers you can do as in the example below,

;; Enable flyspell-mode for some file types
(add-hook 'TeX-mode-hook  (lambda () (flyspell-mode 1))) ; encompasses LaTeX-mode as well
(add-hook 'text-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'sgml-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'html-mode-hook (lambda () (flyspell-mode 1)))
(add-hook 'mail-hook      (lambda () (flyspell-mode 1)))
(add-hook 'message-hook   (lambda () (flyspell-mode 1)))

To make sure flyspell-buffer is run for buffers where flyspell-mode is enabled,
once the buffer is loaded, either unconditionally or depending on size,

;; Run flyspell-buffer after loading file if flyspell-mode is enabled.
(add-hook 'find-file-hooks
          (lambda ()
            (when (and (boundp 'flyspell-mode)
                       flyspell-mode)
              (flyspell-buffer))))

;; Run flyspell-buffer after loading file if flyspell-mode is enabled and file is
;; smaller than a given size (64k in this example, after one by Tim Connors).
(add-hook 'find-file-hooks
          (lambda ()
            (let ((maxsize (* 64 1024))
                  (bufsize (buffer-size)))
              (when (and (boundp 'flyspell-mode)
                         flyspell-mode
                         (< bufsize maxsize))
                (flyspell-buffer)))))


 -- Agustin Martin Domingo <agmartin@debian.org>, Tue,  1 Mar 2011 11:38:19 +0100

 Local Variables:
  ispell-local-dictionary: "american"
 End:

 LocalWords:  debian debconf usr alioth org wordlists wordlist debhelper http
 LocalWords:  iamerican wspanish miscfiles xemacs wbritish var html dpkg emacs
 LocalWords:  ispell aspell encodings flyspell hunspell
