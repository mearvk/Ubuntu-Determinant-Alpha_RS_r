all: html/policy.html

POLICY_VERSION=$(shell cd ..;dpkg-parsechangelog | grep '^Version: ' | cut -d : -f 2)

used-vars:
	lua get_used_vars.lua 

html/%.html:%.txt
	echo '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' > $@
	echo "<html>" >> $@
	echo "<head>" >> $@
	# assume first line of markdown is main header to use for page title
	echo "<title>$(shell head -n 1 $< | sed 's/@@V@@/$(POLICY_VERSION)/')</title>" >> $@
	echo '<link type="text/css" rel="stylesheet" href="style.css"/>' >> $@
	echo "</head>" >> $@
	echo "<body>" >> $@
	cat $< | sed 's/@@V@@/$(POLICY_VERSION)/' | markdown >> $@
	echo "</body>" >> $@
	echo "</html>" >> $@

clean:
	rm -f html/policy.html
