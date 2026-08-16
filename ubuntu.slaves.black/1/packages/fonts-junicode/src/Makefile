vpath %.ufo src

include version.mk

# for release mode add these options to makeotf:
# -gf src/GOA-$(1) -r -nS

define generate_font
	which sfntedit > /dev/null ; \
	if [ $$? -eq 0 ] ; then \
	  sfntedit -d GSUB,GPOS,GDEF,cmap $(1).ttf ; \
	else \
	  echo "Required program sfntedit (Adobe FDK) not installed!" ; \
	  exit 1 ; \
	fi ; \
	which makeotf > /dev/null ; \
	if [ $$? -eq 0 ] ; then \
	  makeotf -fi src/$(1)_fontinfo -gf src/GOA-$(1) -r -nS -f $(1).ttf -o $(1)-tmp.ttf -ff src/$(2).ufo/features.fea -mf src/JunicodeNameDB ; \
	else \
	  echo "Required program makeotf (Adobe FDK) not installed!" ; \
	  exit 1 ; \
	fi ; \
	which ttx > /dev/null ; \
	if [ $$? -eq 0 ] ; then \
	  echo "Adding dummy DSIG table" ; \
	  ttx -d . -o $(1)-dsig.ttf -m $(1)-tmp.ttf util/dsig.ttx ; \
	else \
	  echo "Required program ttx (FontTools) not installed!" ; \
	  exit 1; \
	fi ; \
	which ttfautohint > /dev/null ; \
	if [ $$? -eq 0 ] ; then \
	  echo "Running ttfautohint to make hinted font $(2).ttf" ; \
	  ttfautohint -f latn --hinting-range-min=20 --hinting-range-max=150 -v $(1)-dsig.ttf $(2).ttf ; \
	else \
	  echo "$(2).ttf will be uhinted - ttfautohint not installed!" ; \
	  mv $(1)-tmp.ttf $(2).ttf ; \
	fi ; \
	rm -f $(1).ttf $(1)-dsig.ttf $(1)-tmp.ttf
endef

all : regular bold italic bolditalic greek

regular : Junicode.ttf

bold : Junicode-Bold.ttf

italic : Junicode-Italic.ttf

bolditalic : Junicode-BoldItalic.ttf

greek : FoulisGreek.ttf

# Assume the ttf files: otherwise we'll have to make them all again.
woff :
	which sfnt2woff > /dev/null; \
	if [ $$? -eq 0 ] ; then \
	  sfnt2woff Junicode.ttf ; \
	  sfnt2woff Junicode-Italic.ttf ; \
	  sfnt2woff Junicode-Bold.ttf ; \
	  sfnt2woff Junicode-BoldItalic.ttf ; \
	  sfnt2woff FoulisGreek.ttf ; \
	else \
	  echo "sfnt2woff is not installed." ; \
	fi

Junicode.ttf : jr.ttf
	$(call generate_font,jr,Junicode)

jr.ttf : src/Junicode.ufo
	python util/simplegen.py src/Junicode.ufo jr.ttf ;

Junicode-Bold.ttf : jb.ttf
	$(call generate_font,jb,Junicode-Bold)

jb.ttf : src/Junicode-Bold.ufo
	python util/simplegen.py src/Junicode-Bold.ufo jb.ttf ;

Junicode-Italic.ttf : ji.ttf
	$(call generate_font,ji,Junicode-Italic)

ji.ttf: src/Junicode-Italic.ufo
	python util/simplegen.py src/Junicode-Italic.ufo ji.ttf ;

Junicode-BoldItalic.ttf : jbi.ttf
	$(call generate_font,jbi,Junicode-BoldItalic)

jbi.ttf : src/Junicode-BoldItalic.ufo
	python util/simplegen.py src/Junicode-BoldItalic.ufo jbi.ttf ;

FoulisGreek.ttf : fg.ttf
	$(call generate_font,fg,FoulisGreek)

fg.ttf : src/FoulisGreek.ufo
	python util/simplegen.py src/FoulisGreek.ufo fg.ttf ;

clean :
	rm -f *.ttf ; rm -f *.woff

dist :
	zip -r junicode-$(VERSION).zip *.ttf ChangeLog doc/*.pdf util/mt-Junicode.cfg

woffdist : 
	zip -r junicode-woff-$(VERSION).zip *.woff ChangeLog doc/*.pdf
