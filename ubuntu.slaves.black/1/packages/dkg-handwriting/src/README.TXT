README for ttf-fifthhorseman-dkg-handwriting (version 0.15)
-----------------------------------------------------------

This is a simple, fun font i've been working on to learn more about
fonts in general.  It would not have been possible without the very
cool fontforge package.

I built the font by simply scanning in a handwriting sample (using
xsane), generating simple SVG paths from the sample (using inkscape's
brightness method of tracing bitmaps), and then importing and tweaking
them in fontforge.

i'm going to try to maintain this (and maybe other fonts) at
http://cmrg.fifthhorseman.net/wiki/fonts as i improve my understanding
of the packaging strategies.

I used the debian packaging for ttf-bitstream-vera as a guide to try
to make my deb packages, but have diverged from them significantly
since then.

	-- Daniel Kahn Gillmor <dkg@fifthhorseman.net>
