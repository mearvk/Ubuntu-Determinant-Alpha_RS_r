... sorry, vermutlich überholte Infos hier:

Bezüglich der Einbindung des Wörterbuchs in xemacs-21* (für ältere Versionen
mag Ähnliches gelten) schrieb Stephen Heilbronner dies:



Man muss die Variable `ispell-dictionary-alist' um zwei Einträge ergänzen,
d.h.:

M-x customize-variable `ispell-dictionary-alist'

aufrufen, und dann ergänzen:

[INS] [DEL] List:
            Dictionary: [Value Menu] Dictionary name: german
            Case characters: [a-zA-Z"]
            Non case characters: [^a-zA-Z"]
            Other characters: [']
            Many other characters: [Toggle]  on (non-nil)
            Ispell command line args:
            [INS] [DEL] Arg: -C
            [INS]
            Extended character mode: [Value Menu] ~tex
            Character set: [Value Menu] iso-8859-1

[INS] [DEL] List:
            Dictionary: [Value Menu] Dictionary name: german8
            Case characters: [a-zA-ZÄÖÜäößü]
            Non case characters: [^a-zA-ZÄÖÜäößü]
            Other characters: [^a-zA-ZÄÖÜäößü]
            Other characters:
            Many other characters: [Toggle]  on (non-nil)
            Ispell command line args:
            [INS] [DEL] Arg: -d
            [INS] [DEL] Arg: german
            [INS]
            Extended character mode: [Value Menu] ~latin1
            Character set: [Value Menu] iso-8859-1

Änderungen von Gunter Königsmann:

Neuere Versionen von ispell können den Wert von
ispell-dictionary-alist überschreiben, sobald sie geladen werden.

Abhilfe:


(setq
 ispell-local-dictionary-alist
 '(("german"
    "[a-zA-Z\"]" "[^a-zA-Z\"]" "[']" t ("-C") "~tex" iso-8859-1)
   ("german8"
    "[a-zA-ZÄÖÜäöüß]"
    "[^a-zA-ZÄÖÜäöüß]"
    "" t ("-d" "german") "~latin1" iso-8859-1)))

In die .emacs einfügen.

(Die Einträge sind im wesentlichen von "deutsch/deutsch8" übernommen.)
