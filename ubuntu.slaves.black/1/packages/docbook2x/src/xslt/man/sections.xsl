<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: sections.xsl,v 1.3 2004/08/22 22:46:04 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>DocBook sectioning elements</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="sect1|sect2|sect3|sect4|sect5|simplesect|section">
</xsl:template>
      
<!-- ==================================================================== -->

<xsl:template match="title">
  <!-- ignore -->
</xsl:template>
<xsl:template match="titleabbrev">
  <!-- ignore -->
</xsl:template>
<xsl:template match="subtitle">
  <!-- ignore -->
</xsl:template>

</xsl:stylesheet>

