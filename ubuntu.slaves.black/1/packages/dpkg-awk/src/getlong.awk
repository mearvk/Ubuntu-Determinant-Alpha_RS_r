BEGIN{ oflags = ":;#" }

function option_split_helper(ndx, s_o, l_o, val)
{
	if (length(ndx) < 3)
		s_o[ndx] = val
	else
		l_o[ndx] = val
}
function option_split(opt, s_o, s_o_f, l_o, l_o_f,
	a, opts, itm, flags)
{
	split(opt, opts, " ")
	for (a in opts) {
#print "opts[" a "]='" opts[a] "'\n"
		itm = opts[a]
#print itm " "
		flags = ""
		while (match(itm, "^[" oflags "]")) {
			flags = flags substr(itm, 1, 1)
			itm = substr(itm, 2)
#print itm " "
		}
#print "\n"
		option_split_helper(itm, s_o, l_o, "")
		if (length(flags)) option_split_helper(itm, s_o_f, l_o_f, flags)
		delete opts[a]
	}
}
function option_match(header, text, opts, opts_flags, argv, argc, help_text,
	ret_val, fchar, flags, value)
{
	itm = argv[c]
	gsub(/=.*$/, "", itm)
#print "argv[" c "]='" argv[c] "' itm='" itm "'\n"
	ret_val = 0
#for (a in opts) print "o_m opts[" a "]='" opts[a] "'\n"
	if (match(itm, "^" header )){
#print "match!\n"
		sub("^" header, "", itm)
		if (itm in opts){
			if (itm in opts_flags){
				flags = opts_flags[itm]
#print "o_m flags=" flags "\n"
				for (a = 1; a <= length(oflags); a++) {
					fchar = substr(oflags, a, 1)
					if (match(flags, "[" fchar "]")) {
						if ((fchar == ":") || (fchar == ";")) {
							if (match(argv[c], /=.*$/)){
								sub(/^.*=/, "", argv[c])
								value = argv[c]
								delete argv[c]
							} else {
								delete argv[c]
								if ((c++) <= argc) {
									if (((fchar == ";") && !(match(argv[c], /^-/))) || (fchar == ":")) {
										value = argv[c]
										delete argv[c]
									}
								} else
									value = ""
							}
						}
						if (fchar == "#") {
#print "o_m number\n"
							value = options[itm]
							if (match(argv[c], /=.*$/)){
								sub(/^.*=/, "", argv[c])
								value = argv[c]
								delete argv[c]
							} else {
								delete argv[c]
								value++
							}
						}
					}
				}
			} else
				value = ""
			options[itm] = value
		} else
			if (itm) {
				print "illegal " text " option! '" itm "'\n"
				if(help_text)
					print script_exedir "/" script_exebase " [args]\n\n" help_text "\n"
				exit
			}
		ret_val=1
	}
	return ret_val
}
function option_parse(opt_list, relation, help_text, argc, argv,
	short_opts, short_opts_value,
	long_opts, long_opts_value,
	m, rels, short, long)
{
	option_split(opt_list " :exebase :exedir help h", short_opts, short_opts_value, long_opts, long_opts_value)
	for (c = 1; c <= argc; c++) {
		if (option_match("--", "long", long_opts, long_opts_value, argv, argc, help_text)) continue
		if (option_match("-", "short", short_opts, short_opts_value, argv, argc, help_text)) continue
	}
	split(relation " h=help", rels, " ")
	for ( c in rels) {
		equal = index(rels[c], "=")
		first = substr(rels[c], 1, equal-1)
		if (first in options) {
			second = substr(rels[c], equal+1)
			if (!(second in options))
				# Only move the 'first' option into the
				# 'second' slot if the 'second' one
				# hasn't been defined yet.
				options[second] = options[first]
			delete options[first]
		}
	}
	if ("exebase" in options) {
		script_exebase = options["exebase"]
		delete options["exebase"]
	}
	if ("exedir" in options) {
		script_exedir = options["exedir"]
		delete options["exedir"]
	}
	if ("help" in options) {
		print script_exedir "/" script_exebase " [args]\n\n" help_text "\n"
		exit
	}
}

