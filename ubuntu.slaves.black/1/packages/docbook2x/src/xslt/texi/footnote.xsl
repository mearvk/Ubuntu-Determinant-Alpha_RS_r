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
     $Id: footnote.xsl,v 1.9 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Footnotes</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="footnote">
  <footnote>
    <xsl:apply-templates mode="coerce-into-inline" />
  </footnote>
</xsl:template>

<xsl:template match="footnoteref">
  <xsl:call-template name="user-message">
    <xsl:with-param name="key">Footnote references not supported</xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
