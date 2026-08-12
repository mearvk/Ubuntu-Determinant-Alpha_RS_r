# this makefile is used to automate building of dictionaries
# based on affix files etc...

# if you need to adapt this Makefile for another language,
# all you should have to do is change these variables.
# if you need to change anything else then change it in Makefile.languages
LANG=zu
LANGNAME=Zulu
LANGNAMELOW=zulu
REGION=ZA
REGIONNAME=South Africa
# The input wordlists
WORDLIST.IN=$(shell ls wordlists/wordlist.*.in)
# Change these if your language is not defined in OpenOffice otherwise defaults
# to the values you set in $LANG and $REGION
#LANG_FAKE=it
#REGION_FAKE=IT
CHARSET=iso-8859-1

# The wordlists already in munched form
MUNCHEDLIST.IN=$(shell ls myspell/munchedlist.*.in)
MUNCHEDLIST.CHARSET=$(patsubst %.in, %.$(CHARSET), $(MUNCHEDLIST.IN))

myspell/munchedlist.$(CHARSET): $(MUNCHEDLIST.CHARSET)
	cat $^ | egrep -v "^#|^$$" | sort --unique > $@

myspell/zu_ZA.aff: myspell/zu_aff.py
	$^ > $@

include ../utils/Makefile.language

ZU_TARGETS_MYSPELL= myspell/munchedlist.$(CHARSET) myspell/zu_ZA.dic.tmp myspell/zu_ZA.aff
ZU_TARGET_WORDLISTS= $(MUNCHEDLIST.CHARSET)

clean-wordlists:
	rm -rf $(TARGET_WORDLISTS) $(ZU_TARGET_WORDLISTS)

clean-myspell:
	rm -rf $(TARGETS_MYSPELL) $(ZU_TARGETS_MYSPELL)
# we override the generation of the myspell .dic file.
# it does not munch the wordlist, but instead only makes use of the unmunched
# wordlist and then appends the already munched lists.
myspell/$(LANG)_$(REGION).dic: myspell/wordlist.$(CHARSET) myspell/munchedlist.$(CHARSET)
	cat myspell/wordlist.$(CHARSET) myspell/munchedlist.$(CHARSET) | wc -l > $@
	cat myspell/wordlist.$(CHARSET) myspell/munchedlist.$(CHARSET) >> $@

%: force
	@$(MAKE) -f ../utils/Makefile.language $@

force: ;


