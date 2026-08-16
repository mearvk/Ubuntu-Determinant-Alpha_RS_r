...\"
...\" Prolog for docbook-to-man.ts - macros to push/pop fonts.
...\" $Id: docbook-to-man.prolog,v 1.1 1999/02/23 21:00:18 db3l Exp $
...\"
.de pF
.ie     \\*(f1 .ds f1 \\n(.f
.el .ie \\*(f2 .ds f2 \\n(.f
.el .ie \\*(f3 .ds f3 \\n(.f
.el .ie \\*(f4 .ds f4 \\n(.f
.el .tm ? font overflow
.ft \\$1
..
.de fP
.ie     !\\*(f4 \{\
.	ft \\*(f4
.	ds f4\"
'	br \}
.el .ie !\\*(f3 \{\
.	ft \\*(f3
.	ds f3\"
'	br \}
.el .ie !\\*(f2 \{\
.	ft \\*(f2
.	ds f2\"
'	br \}
.el .ie !\\*(f1 \{\
.	ft \\*(f1
.	ds f1\"
'	br \}
.el .tm ? font underflow
..
.ds f1\"
.ds f2\"
.ds f3\"
.ds f4\"
...\"
...\" End of prolog
...\"
