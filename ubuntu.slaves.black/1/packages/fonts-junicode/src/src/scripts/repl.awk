#!/bin/bash

# Call awk to delete anchors in the form
# <contour>
#   <point name="N"/>
# </contour>
# Write the new file to directory new and check before proceeding!

for f in `grep -l "point.*name=\"" *.glif`; do
awk '/point.*name=\"/{c=1;next}
c--<0 && p{print p}
{p=$0}
END{print p}
' $f > new/$f;
done

