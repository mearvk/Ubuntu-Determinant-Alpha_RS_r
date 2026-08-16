all: oxt

# https://wiki.openoffice.org/wiki/Documentation/DevGuide/Extensions/File_Format

FILES=dictionaries.xcu description.xml package-description.txt

oxt: $(FILES) ../README.md ../CHANGELOG.md ../dz.dic ../dz.aff META-INF/manifest.xml
	@echo "Making oxt file for LibreOffice..."
	@mkdir -p dictionaries && cp ../dz.dic ../dz.aff dictionaries
	@cp ../README.md .
	@zip -rq dzongkha-spellchecker.oxt dictionaries $(FILES) META-INF README.md CHANGELOG.md

clean:
	@rm -rf dictionaries README.md CHANGELOG.md dzongkha-spellchecker.oxt
