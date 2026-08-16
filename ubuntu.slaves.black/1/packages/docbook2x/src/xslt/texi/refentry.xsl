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
     $Id: refentry.xsl,v 1.26 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title><sgmltag class="element">refentry</sgmltag> markup</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="reference">
  <xsl:call-template name="section" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="refentry">
  <xsl:call-template name="section" />
</xsl:template>

<xsl:template match="refmeta">
</xsl:template>

<xsl:template match="manvolnum">
  <xsl:if test="$manvolnum-in-xref">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>
<xsl:template match="manvolnum" mode="no-inline-markup">
  <xsl:if test="$manvolnum-in-xref">
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="refmiscinfo">
</xsl:template>

<xsl:template match="refentrytitle">
  <xsl:call-template name="inline-plain"/>
</xsl:template>

<xsl:template match="refnamediv">
  <xsl:choose>
    <xsl:when test="$refentry-display-name">

      <xsl:call-template name="section">
        <xsl:with-param name="level">
          <xsl:call-template name="get-texinfo-section-level">
            <xsl:with-param name="heading-class" select="'chapheading'" />
          </xsl:call-template>
        </xsl:with-param>
        <xsl:with-param name="title">
          <xsl:call-template name="gentext-title" />
        </xsl:with-param>
        <xsl:with-param name="content">
          <para>
            <xsl:apply-templates />
          </para>
        </xsl:with-param>
      </xsl:call-template>

    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="block-object"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="refname">
  <xsl:if test="preceding-sibling::refname">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'inline-list-separator'" />
    </xsl:call-template>
  </xsl:if>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refpurpose">
  <xsl:text> &#x2014; </xsl:text>
  <!-- mdash -->
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="refdescriptor">
</xsl:template>

<xsl:template match="refclass">
  <para>
    <xsl:if test="@role">
      <xsl:value-of select="@role"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refsect1|refsect2|refsect3">
  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'chapheading'" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
