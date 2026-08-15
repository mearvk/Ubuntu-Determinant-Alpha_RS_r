all: cli

cli:
	coffee --version | grep -qP '^CoffeeScript version [\d.]+$$'
	coffee --help | grep -q '^Usage:'
#	cake.coffeescript | grep -q '^Cakefile defines the following tasks:$$'
