BEGIN {
	FS="\n"
	RS=""
	ORS=""
	help="\
-f <file>			Read <file>, instead of the default\n\
--filename =? <file>		/var/lib/dpkg/status.\n\
\n\
-d				Each time this is specified, increase\n\
--debug				the debugging output.\n\
\n\
-s <field list>			Store the output, and sort it based on\n\
--sort =? <field list>		these fields.  Each field is separated\n\
				by <space> or <comma>.\n\
\n\
-rs <output sep>		Output this string at the end of each\n\
--rec_sep <output sep>		paragraph.\n\
\n\
-n <field list>			List the fields that should be treated\n\
--numeric <field list>		numerically for sorting purposes.\n\
"
	opt_list = ":n :f #d :s :rs :numeric :filename #debug :sort :rec_sep :outform :of"
	opt_link = "n=numeric f=filename d=debug s=sort rs=rec_sep of=outform"
	options["rs"] = "\n"
	options["of"] = "normal"
	option_parse(opt_list, opt_link, help, ARGC, ARGV)

	for (c = 1; c <= ARGC; c++) {
		if (length(ARGV[c])) {
			itm = ARGV[c]
			if ( q == 2) {
			}
			if (q == 1) {
				if (itm == "--") { q = 2 } else {
					if (match(itm, /^\^/)) {
						#
						# Output *ALL* fields, but these.
						#
						sub(/^\^/, "", itm)
						if (!(1 SUBSEP tolower(itm) in outf)) {
							if(outf[1,0] >= 0) {
								outf[1,0]++
								outf[1,outf[1,0]] = itm
								outf[1,tolower(itm)] = ""
								outf[0] = -1
							}
						}
					} else {
						#
						# Output only these fields.
						#
						if (!(itm in outf)) {
							if(outf[0] >= 0) {
								outf[0]++
								outf[outf[0]] = itm
								outf[itm] = ""
								outf[1,0] = -1
							}
						}
					}
				}
			}
			if (q == 0) {
				#
				# Perform regex matchs on these fields.
				#
				if (itm == "--") { q = 1 } else {
					if ( p = index(itm,":")){
						ndx = tolower(substr(itm,1, p - 1))
						val = substr(itm, p + 1)
						regx[ndx] = val
					}
				}
			}
#			print "\n"
		}
	}
	split(options["numeric"], numeric_fields, " ")

	for (c = 1; c <= outf[0]; c++)
		delete outf[outf[c]]

	if (options["debug"] >= 1)
		for (a in outf)
			print "outf[" a "]=" outf[a] "\n"

	if (options["debug"] >= 1)
		print "ARGV[0]='" ARGV[0] "'\n"
	delete ARGV
	if (options["debug"] >= 1)
		for (a in options)
			print "options[" a "]='" options[a] "'\n"
	ARGV[1] = "/var/lib/dpkg/status"
	if ("filename" in options) ARGV[1] = options["filename"]
	num_fields=0
	sort_fields["a"]=0
}
function my_split(input, output,
	a, b, fields, save0)

{
	delete output
	delete fields
	save0 = $0
	$0 = input
	num_fields = split(input, fields, "\n")
	b = 0
	if (options["debug"] >= 2) {
		print "my_split\n"
		for (a = 1; a <= num_fields; a++)
			print "fields[" a "]='" fields[a] "'\n"
		print "done\n"
	}

	for (a = 1; a <= num_fields; a++) {
		if (match(fields[a], /^[^ ].*:.*$/)) {
			split(fields[a], fld, ":")
			b = b + 1
			output[1,++output[1,0]] = fld[1]
			output[1,tolower(fld[1])] = ""
			sub(/^[^:]*: */,"",fields[a])
			if(a in numeric_fields)
				fields[a] = 0 + fields[a]
			output[tolower(fld[1])] = fields[a]
		} else {
			q = output[tolower(fld[1])]
			output[tolower(fld[1])] = q FS fields[a]
			delete fields[a]
		}
	}

	$0 = save0
	return num_fields
}

function my_outrec(fields, outf,
	c)
{
	if(outf[0] > 0) {
		if (options["debug"] >= 1)
			print "normal\n"
		for (c = 1; c <= outf[0]; c++)
			if ( tolower(outf[c]) in fields )
				print outf[c] ": " fields[tolower(outf[c])] "\n"
	} else {
		if(outf[1,0] > 0) {
			if (options["debug"] >= 1)
				print "inverted " fields[1,0] "\n"
			for (c = 1; c <= fields[1,0]; c++) {
				if (options["debug"] >= 1)
					print "fields[1," c "]='" 1 SUBSEP tolower(fields[1,c]) "'\n"
				if (!(1 SUBSEP tolower(fields[1,c]) in outf )) {
					if(options["outform"] == "normal")
						print fields[1,c] ": " fields[tolower(fields[1,c])] "\n"
				}
			}
		} else {
			if (options["debug"] >= 1)
				print "all\n"
			for (c = 1; c <= fields[1,0]; c++)
				print fields[1,c] ": " fields[tolower(fields[1,c])] "\n"
		}
	}
	print options["rec_sep"]
 }

function my_compare(mthd, i, j,
	c, fld)
{
	if (mthd == 0) {
		if(num_fields) {
			my_split(i, fld_i)
			my_split(j, fld_j)
			for(c = 1; c <= num_fields; c++) {
				fld = tolower(sort_fields[c])
if(options["debug"] >=2) 
print "sort fld=" fld "\n"
				if (options["debug"] >= 2) {
					print "\tPackage[" fld "]='" fld_i[fld] "' "
					print "\tPackage[" fld "]='" fld_j[fld] "' "
				}
				if(match(fld, /.*:n$/)) {
					gsub(/:n$/, fld)
					if (fld_i[fld]+0 < fld_j[fld]+0)
						return -1
					if (fld_i[fld]+0 > fld_j[fld]+0)
						return 1
				} else {
					if (fld_i[fld] < fld_j[fld])
						return -1
					if (fld_i[fld] > fld_j[fld])
						return 1
				}
			}
		}
	}
	if (options["debug"] >= 2) print "-1\n"
	return 0
}

function my_sort(line, outf,
	num_fields, c)
{
	qsort(0, line, 1, mtchs)
	num_fields = split(options["sort"], sort_fields, "[ ,]")
	qsort(0, line, 1, mtchs)
	delete sort_fields    
	for (c = 1; c <= mtchs; c++){
		my_split(line[c], fields)
		my_outrec(fields, outf)
	}
}


function readline(	Old_RS, line)
{
	Old_RS=RS
	RS="\n"
	"read; echo $REPLY" | getline line
 	close("read; echo $REPLY")
	RS=Old_RS
	return line
}
#
# Begin of script
#
{
	my_split($0, fields)
	for (c in regx)
		if ( match(fields[c], regx[c])==0)
			next

	my_split($0, fields)
#	test = readline()
#	print "test='" test "'\n"
	if (options["debug"] >= 1) for (a in fields) print "fields[" a "]=" fields[a] "\n"
	if ("sort" in options) {
		line[++mtchs] = $0
		if (options["debug"] >= 1) print mtchs " "
	} else
		my_outrec(fields, outf)
}

END {
	print "\n"
	if ("sort" in options)
		my_sort(line, outf)
}



#
#
# qsort functions
#
#


function middle(mthd, x,y,z)  #return middle of 3
{
 	ret_xy = my_compare(mthd, x, y)
 	ret_zy = my_compare(mthd, z, y)
	if (ret_xy <= 0 ) {
		if ( ret_zy >= 0 ) return y
		if ( my_compare(mthd, z, x) < 0 ) return x
		return z
	}

	if ( my_compare(mthd, z, x) >= 0 ) return x
	if ( ret_zy < 0 ) return y
	return z
}


# recursive quicksort
function  qsort(mthd, A, left, right    ,i , j, pivot, hold)
{
	pivot = middle(mthd, A[left], A[int((left + right)/2)], A[right])
	i = left
	j = right

	while ( i <= j ) {
		while (my_compare(mthd, A[i], pivot) < 0) i++ 
		while (my_compare(mthd, A[j], pivot) > 0) j--
		if ( i <= j ) {
			hold = A[i]
			A[i++] = A[j]
			A[j--] = hold
		}
	}
	if ( j - left > 0 )  qsort(mthd, A, left, j)
	if ( right - i > 0 )  qsort(mthd, A, i, right)
}
