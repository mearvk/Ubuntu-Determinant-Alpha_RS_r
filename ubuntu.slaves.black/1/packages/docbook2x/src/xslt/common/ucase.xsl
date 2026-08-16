<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: ucase.xsl,v 1.1 2004/07/17 00:26:53 stevecheng Exp $
     ********************************************************************

     (C) 2004 Steve Cheng <stevecheng@users.sourceforge.net>

     ******************************************************************** -->

<xsl:template name="lcase">
  <xsl:param name="content" />
  
  <xsl:variable name="uppercase-alphabet">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'uppercase-alphabet'" />
    </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lowercase-alphabet">
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'lowercase-alphabet'" />
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:value-of select="translate($content,
                                  $uppercase-alphabet,
                                  $lowercase-alphabet)" />
</xsl:template>

<xsl:template name="ucase">
  <xsl:param name="content" />
  
  <xsl:variable name="uppercase-alphabet">
    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'uppercase-alphabet'" />
    </xsl:call-template>
    </xsl:variable>
    <xsl:variable name="lowercase-alphabet">
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'lowercase-alphabet'" />
    </xsl:call-template>
  </xsl:variable>
  
  <xsl:value-of select="translate($content,
                                  $lowercase-alphabet,
                                  $uppercase-alphabet)" />
</xsl:template>

</xsl:stylesheet>

