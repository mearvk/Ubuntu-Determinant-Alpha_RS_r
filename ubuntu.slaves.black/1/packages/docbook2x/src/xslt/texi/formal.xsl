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
     $Id: formal.xsl,v 1.13 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>DocBook formal objects</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="formal-object">
  <xsl:call-template name="anchor" />
  <xsl:call-template name="formal-object-title" />
  <xsl:apply-templates />
</xsl:template>

<xsl:template name="formal-object-title">
  <xsl:if test="./title">
    <xsl:call-template name="make-caption">
      <xsl:with-param name="content">
        <xsl:apply-templates select="title" mode="title" />
      </xsl:with-param>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="informal-object">
  <xsl:call-template name="anchor" />
  <xsl:apply-templates/>
</xsl:template>

<xsl:template name="semiformal-object">
  <xsl:choose>
    <xsl:when test="title">
      <xsl:call-template name="formal-object"/>
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="informal-object"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="figure|table|example">
  <xsl:call-template name="formal-object"/>
</xsl:template>

<xsl:template match="equation">
  <xsl:call-template name="semiformal-object"/>
</xsl:template>

<xsl:template match="informalfigure">
  <xsl:call-template name="informal-object"/>
</xsl:template>

<xsl:template match="informalexample">
  <xsl:call-template name="informal-object"/>
</xsl:template>

<xsl:template match="informaltable">
  <xsl:call-template name="informal-object"/>
</xsl:template>

<xsl:template match="informalequation">
  <xsl:call-template name="informal-object"/>
</xsl:template>

</xsl:stylesheet>
