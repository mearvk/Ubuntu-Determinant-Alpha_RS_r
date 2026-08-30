# To avoid name clashed while at the same time enabling
# Blends users finding their tools under the names they
# expect them to be the tools in question of each Blend
# will be installed to /usr/lib/$blend/bin and this
# script prepends this dir to the usual system PATH if
# a user is a has mentioned the Blend #BLENDNAME# in a
# file ~/.blends

BLEND=#BLENDNAME#
if [ -e "$HOME"/.blends ] ; then
  for blend in `sed 's/#.*//' "$HOME"/.blends` ; do
    if [ "$blend" = "$BLEND" ] ; then
      blendpath="/usr/lib/$BLEND/bin"
      blendmanpath="/usr/lib/$BLEND/share/man"
      if [ -d "$blendpath" ] ; then
        export PATH="$blendpath:${PATH}"
      fi
      if [ -d "$blendmanpath" ] ; then
        if [ "$MANPATH" = "" ] ; then
          export MANPATH="$blendmanpath:/usr/share/man"
        else
          export MANPATH="$blendmanpath:${MANPATH}"
        fi
      fi
      break
    fi
  done
fi
