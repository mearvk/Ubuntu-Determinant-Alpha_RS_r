#!/bin/sed -f

# Wrap succession of documents in one manpageset element
# Note 1: We assume UTF-8 encoding everywhere, which is what
#         the stylesheets generate (and there is no reason to change it).
# Note 2: The location of the DTD should be in the env
#         environment variable db2x_dtd
1 {
i\
<?xml version="1.0" encoding="utf-8" standalone="no" ?> \
<!DOCTYPE manpageset SYSTEM
e echo "'${db2x_dtd:-http://docbook2x.sourceforge.net/latest/dtd/Man-XML}'>"
i\
<manpageset xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML">
}

$a\
</manpageset>

# Remove any XML declarations in the sub-documents
/<?xml version=[^?]\+?>/d
