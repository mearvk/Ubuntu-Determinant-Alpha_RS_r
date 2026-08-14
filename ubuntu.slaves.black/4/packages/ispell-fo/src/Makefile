LANG=fo_FO.ISO8859-1

sprog=føroyskt
sprog_en=Faroese
sprog_en_lower_case=faroese
sprogkode=fo
landekode=FO

lang = fo
version = 0.4.2

installdir=`ispell -vv | grep LIBDIR | cut -d'"' -f2`

all: maskbits $(sprog).hash

maskbits:
	@test "`ispell -vv | grep MASKBITS`" != ""              || ( echo Ispell should be compiled with MASKBITS set to at least 64. ; exit -2 )
	@test `ispell -vv | grep MASKBITS | cut -d= -f2` -ge 64 || ( echo Ispell should be compiled with MASKBITS set to at least 64. ; exit -3 )

install: maskbits $(sprog).hash $(sprog).aff
	install -o root -g root -m 0644 $(sprog).hash $(installdir)
	install -o root -g root -m 0644 $(sprog).aff $(installdir)
	ln -fs $(installdir)/$(sprog).hash $(installdir)/$(sprogkode)_$(landekode).hash
	ln -fs $(installdir)/$(sprog).aff  $(installdir)/$(sprogkode)_$(landekode).aff
	ln -fs $(installdir)/$(sprog).hash $(installdir)/$(sprog_en_lower_case).hash
	ln -fs $(installdir)/$(sprog).aff  $(installdir)/$(sprog_en_lower_case).aff

$(sprog).hash: maskbits $(sprog).aff words-$(sprogkode).ispell
	buildhash words-$(sprogkode).ispell $(sprog).aff $(sprog).hash

clean:
	rm -f words-$(sprogkode).ispell.stat $(sprog).hash words-$(sprogkode).ispell.cnt *~
