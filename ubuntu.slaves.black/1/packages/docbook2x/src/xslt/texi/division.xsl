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
     $Id: division.xsl,v 1.22 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>DocBook divisions</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="set" mode="top-chunk">
  <!-- Process each book as a separate file -->
  <xsl:apply-templates select="book" mode="top-chunk" />
</xsl:template>

<xsl:template match="book">
  <xsl:call-template name="section" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="part">
  <xsl:choose>
    <xsl:when test="/part">
      <xsl:call-template name="section" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="section">
        <xsl:with-param name="level">majorheading</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="partintro">
  <xsl:call-template name="section" />
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

