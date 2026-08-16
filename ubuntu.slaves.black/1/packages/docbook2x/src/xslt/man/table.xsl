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
     $Id: table.xsl,v 1.8 2006/04/13 21:16:52 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Table support</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="table">
  <xsl:call-template name="formal-object-title" />
  <table>
    <xsl:apply-templates select="@*" mode="copy" />
    <xsl:apply-templates />
  </table>
</xsl:template>

<xsl:template match="informaltable">
  <table>
    <xsl:apply-templates select="@*" mode="copy" />
    <xsl:apply-templates />
  </table>
</xsl:template>

<xsl:template match="tgroup">
  <tgroup>
    <xsl:apply-templates select="@*" mode="copy" />
    <xsl:apply-templates select="colspec|spanspec" />
    <xsl:apply-templates select="thead" />
    <xsl:apply-templates select="tbody" />
    <xsl:apply-templates select="tfoot" />
  </tgroup>
</xsl:template>

<xsl:template match="colspec|spanspec">
  <xsl:call-template name="copy-through" />
</xsl:template>

<xsl:template match="thead|tbody|tfoot">
  <xsl:call-template name="copy-through" />
</xsl:template>

<xsl:template match="row|entry">
  <xsl:call-template name="copy-through" />
</xsl:template>

<xsl:template match="entrytbl[@cols='2']">
  <xsl:element name="{local-name(.)}"
               namespace="http://docbook2x.sourceforge.net/xmlns/Man-XML">
    <xsl:apply-templates select="@*" mode="copy" />
    <xsl:apply-templates select="thead" mode="entrytbl" />
    <xsl:apply-templates select="tbody" mode="entrytbl" />
    <xsl:apply-templates select="tfoot" mode="entrytbl" />
  </xsl:element>
</xsl:template>

<xsl:template match="thead" mode="entrytbl">
  <xsl:apply-templates select="row" mode="entrytbl-head" />
</xsl:template>

<xsl:template match="tbody" mode="entrytbl">
  <xsl:apply-templates select="row" mode="entrytbl-body" />
</xsl:template>

<xsl:template match="tfoot" mode="entrytbl">
  <xsl:apply-templates select="row" mode="entrytbl-body" />
</xsl:template>

<xsl:template match="row" mode="entrytbl-head">
  <TP>
    <TPtag>
      <b><xsl:value-of select="entry[1]" /></b>
    </TPtag>
    <TPitem>
      <b><xsl:value-of select="entry[2]" /></b>
    </TPitem>
  </TP>
</xsl:template>

<xsl:template match="row" mode="entrytbl-body">
  <TP>
    <TPtag>
      <xsl:value-of select="entry[1]" />
    </TPtag>
    <TPitem>
      <xsl:value-of select="entry[2]" />
    </TPitem>
  </TP>
</xsl:template>

<xsl:template name="copy-through">
  <!-- We don't use xsl:copy, because we need to change the namespace -->
  <xsl:element name="{local-name(.)}"
               namespace="http://docbook2x.sourceforge.net/xmlns/Man-XML">
    <xsl:apply-templates select="@*" mode="copy" />
    <xsl:apply-templates />
  </xsl:element>
</xsl:template>

<xsl:template match="@*" mode="copy">
  <xsl:copy>
    <xsl:value-of select="." />
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
