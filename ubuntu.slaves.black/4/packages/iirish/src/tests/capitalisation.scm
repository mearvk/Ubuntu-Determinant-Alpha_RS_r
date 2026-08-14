;;; capitalisation.scm -- test file for ispell-ga
;;;
;;; $Id: $
;;;
;;; Copyright (C) 2001 Alastair McKinstry <mckinstry@computer.org>
;;; Released under the GNU Public License


;; This file tests the capitalization rules for gaeilge.


(ispell-ga-fail 
	"héireann")

(ispell-ga-pass 
	"hÉireann")

