<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: ss-man.xsl,v 1.3 2006/04/15 18:46:07 stevecheng Exp $
     ********************************************************************

     Customization of the man pages of docbook2X
     
     ******************************************************************** -->
<xsl:import href="http://docbook2x.sf.net/latest/xslt/man/docbook.xsl" />

<xsl:template match="processing-instruction('man-SS-include')">
  <xsl:variable name="target" select="key('id', .)" />
  <SS>
    <xsl:apply-templates select="$target/title" mode="title" />
  </SS>

  <xsl:apply-templates 
    select="$target/node()[not(self::refentry or 
                              starts-with(local-name(.),'sect'))]" />
</xsl:template>

<xsl:template match="xref[@linkend='manpages']" priority="3.0">
  <xsl:text>Converting to man pages</xsl:text>
</xsl:template>

<xsl:template match="xref[@linkend='texinfo']" priority="3.0">
  <xsl:text>Converting to Texinfo</xsl:text>
</xsl:template>

<xsl:template match="*[@role='html']" priority="10.0">
  <!-- Omit anything that is designated as HTML only -->
</xsl:template>

<xsl:template match="olink">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="screen/userinput" priority="2.0">
  <xsl:apply-templates />
</xsl:template>

<!-- parameter to get correct paths in refentry pages -->
<xsl:template match="processing-instruction('install-datadir')">
  <xsl:value-of select="$install-datadir" />
</xsl:template>


</xsl:stylesheet>

