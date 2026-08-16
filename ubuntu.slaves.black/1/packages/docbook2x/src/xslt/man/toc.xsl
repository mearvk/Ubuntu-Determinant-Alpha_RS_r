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
     $Id: toc.xsl,v 1.3 2004/08/22 22:46:04 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>User-defined table of contents (<sgmltag class="element">toc</sgmltag>
markup)</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="*" mode="toc">
</xsl:template>

<xsl:template match="toc">
</xsl:template>

<xsl:template match="tocpart|tocchap|tocfront|tocback|tocentry">
</xsl:template>

<xsl:template match="toclevel1|toclevel2|toclevel3|toclevel4|toclevel5">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="lot|lotentry">
</xsl:template>

</xsl:stylesheet>
