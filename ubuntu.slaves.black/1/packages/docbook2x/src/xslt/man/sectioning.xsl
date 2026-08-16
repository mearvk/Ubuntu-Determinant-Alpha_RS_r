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
     $Id: sectioning.xsl,v 1.5 2004/08/22 22:46:04 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Mapping of DocBook sections into man-page sections</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="SS-section">
  <xsl:param name="title">
    <xsl:apply-templates select="." mode="for-title" />
  </xsl:param>

  <xsl:param name="content">
    <xsl:apply-templates />
  </xsl:param>

  <SS>
    <xsl:copy-of select="$title" />
  </SS>

  <xsl:copy-of select="$content" />
</xsl:template>

<xsl:template name="SH-section">
  <xsl:param name="title">
    <xsl:apply-templates select="." mode="for-title" />
  </xsl:param>

  <xsl:param name="content">
    <xsl:apply-templates />
  </xsl:param>

  <SH>
    <xsl:copy-of select="$title" />
  </SH>

  <xsl:copy-of select="$content" />
</xsl:template>

</xsl:stylesheet>

