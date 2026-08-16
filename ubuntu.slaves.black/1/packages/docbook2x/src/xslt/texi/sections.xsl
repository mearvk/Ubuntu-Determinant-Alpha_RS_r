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
     $Id: sections.xsl,v 1.16 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>DocBook sectioning elements</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="sect1|sect2|sect3|sect4|sect5|simplesect|section">
  <xsl:call-template name="section" />
</xsl:template>
      
<!-- ==================================================================== -->

<xsl:template match="bridgehead">
  <xsl:call-template name="make-texinfo-section">
    <xsl:with-param name="level">
      <xsl:choose>
        <xsl:when test="@renderas = 'sect1'">unnumberedsec</xsl:when>
        <xsl:when test="@renderas = 'sect2'">unnumberedsubsec</xsl:when>
        <xsl:when test="@renderas = 'sect3'">unnumberedsubsubsec</xsl:when>
        <xsl:otherwise>unnumberedsubsubsec</xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>

    <xsl:with-param name="title">
      <xsl:apply-templates />
    </xsl:with-param>
    
  </xsl:call-template>
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

