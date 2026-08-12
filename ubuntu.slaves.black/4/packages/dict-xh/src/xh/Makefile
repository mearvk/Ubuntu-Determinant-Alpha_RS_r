# this makefile is used to automate building of dictionaries
# based on affix files etc...

# if you need to adapt this Makefile for another language,
# all you should have to do is change these variables.
# if you need to change anything else then change it in Makefile.languages
LANG=xh
LANGNAME=Xhosa
LANGNAMELOW=xhosa
REGION=ZA
REGIONNAME=South Africa
# The input wordlists
WORDLIST.IN=$(shell ls wordlists/wordlist.*.in)
# Change these if your language is not defined in OpenOffice otherwise defaults
# to the values you set in $LANG and $REGION
#LANG_FAKE=it
#REGION_FAKE=IT
CHARSET=iso-8859-1

include ../utils/Makefile.language
