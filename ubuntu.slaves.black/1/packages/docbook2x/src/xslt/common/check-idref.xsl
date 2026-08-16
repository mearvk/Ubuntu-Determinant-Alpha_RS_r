<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook2x.sourceforge.net/xsl/localization"
                exclude-result-prefixes="doc l"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: check-idref.xsl,v 1.2 2004/08/06 14:50:01 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<xsl:template name="check-idref">
  <xsl:param name="target" />
  <xsl:param name="content" />
  <xsl:param name="bad-content" />

  <xsl:choose>
    <xsl:when test="not($target)">
      <!-- No such ID -->
      <xsl:call-template name="user-message">
        <xsl:with-param name="arg-1" select="@linkend" />
        <xsl:with-param name="key">reference to non-existent ID</xsl:with-param>
        <xsl:with-param name="content">reference to non-existent ID "<l:a1 />"</xsl:with-param>
      </xsl:call-template>

      <xsl:copy-of select="$bad-content" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<!-- Not the most obvious place to put this template, 
     but I didn't want to bother making a separate file for it. -->

<xsl:template name="print-id">
  <xsl:param name="node" select="." />

  <xsl:choose>
    <xsl:when test="$node/@id != ''">
      <xsl:value-of select="$node/@id" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="generate-id($node)" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

      
</xsl:stylesheet>
