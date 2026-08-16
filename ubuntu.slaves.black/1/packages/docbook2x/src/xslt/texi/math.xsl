<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: math.xsl,v 1.7 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Equations</title>
<partintro>
<para>
Currently we do not support the use of TeX for mathematics.
</para>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="inlineequation">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="alt">
  <xsl:apply-templates />
</xsl:template>

</xsl:stylesheet>
