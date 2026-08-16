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
     $Id: lists.xsl,v 1.13 2007/02/25 21:12:51 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>All sorts of lists</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="list.block">
  <xsl:param name="content">
    <xsl:apply-templates />
  </xsl:param>

  <xsl:choose>
    <xsl:when test="ancestor::itemizedlist | ancestor::orderedlist | ancestor::variablelist">
      <indent>
        <xsl:copy-of select="$content" />
      </indent>
    </xsl:when>

    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="itemizedlist">
  <xsl:call-template name="list.block" />
</xsl:template>

<xsl:template match="itemizedlist/listitem">
  <TP indent="0.2i">
    <TPtag>&#x2022;</TPtag> <!-- i18n FIXME -->
    <TPitem>
      <xsl:apply-templates />
    </TPitem>
  </TP>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="orderedlist">
  <xsl:call-template name="list.block" />
</xsl:template>

<xsl:template match="orderedlist/listitem">
  <TP indent="0.4i">
    <TPtag><xsl:number /><xsl:text>.</xsl:text></TPtag>
    <TPitem><xsl:apply-templates /></TPitem>
  </TP>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="variablelist">
  <xsl:call-template name="list.block" />
</xsl:template>

<xsl:template match="varlistentry">
  <TP>
    <TPtag>
      <xsl:apply-templates select="term" />
    </TPtag>

    <xsl:apply-templates select="listitem" />
  </TP>
</xsl:template>

<xsl:template match="term[1]">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="term">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'inline-list-separator'" />
  </xsl:call-template>
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <TPitem><xsl:apply-templates /></TPitem>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="simplelist">
  <para>
    <xsl:apply-templates />
  </para>
</xsl:template>

<xsl:template match="member">
  <br /><xsl:apply-templates/>
</xsl:template>
<xsl:template match="member[1]" priority="1">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="para/simplelist[@type='inline']" priority="2.0">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="simpara/simplelist[@type='inline']" priority="2.0">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="simplelist[@type='inline']">
  <para>
    <xsl:apply-templates />
  </para>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'inline-list-separator'" />
  </xsl:call-template>
  <xsl:apply-templates />
</xsl:template>
<xsl:template match="simplelist[@type='inline']/member[1]" priority="1">
  <xsl:apply-templates />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="segmentedlist">
  <xsl:apply-templates />  
</xsl:template>

<xsl:template match="segtitle">
</xsl:template>

<xsl:template match="seg">
  <xsl:variable name="pos" select="position()" />

  <xsl:if test="$pos > 1">
    <br />
  </xsl:if>

  <b>
    <xsl:apply-templates select="../../segtitle[$pos]/node()" />
  </b>

  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'seg-separator'" />
  </xsl:call-template>

  <xsl:apply-templates />
</xsl:template>

<xsl:template match="seglistitem">
  <para>
    <xsl:apply-templates />
  </para>
</xsl:template>
  
</xsl:stylesheet>

