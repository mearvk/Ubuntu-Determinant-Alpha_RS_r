<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:gt="http://docbook2x.sourceforge.net/xsl/gentext"
                exclude-result-prefixes="doc gt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: cmdsynopsis.xsl,v 1.4 2004/08/09 02:32:58 stevecheng Exp $
     ********************************************************************

     &copy; 2000 Steve Cheng <stevecheng@users.sourceforge.net>

     Part of docbook2X.  Handle cmdsynopsis attributes.

     ******************************************************************** -->

<!-- ==================================================================== -->
<!-- Decoration strings for cmdsynopsis -->

<!-- We don't have any policy yet on whether we should default
attributes on our own, or make the user use a DTD. 
However it is needed to work around a misfeature in libxml.
-->
<xsl:template name="cmdsynopsis-gentext-sepchar">
  <xsl:variable name="scopes"   
                select="ancestor-or-self::*[@sepchar]" />
  <xsl:variable name="sepchar" select="$scopes[1]/@sepchar" />
  
  <xsl:choose>
    <xsl:when test="$sepchar != ''"><xsl:value-of select="$sepchar"/></xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'cmdsynopsis-default-sepchar'" />
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="arg-gentext-choice-start">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key">
      <xsl:choose>
        <xsl:when test="@choice != ''">
          <xsl:value-of select="concat('arg-choice-',@choice,'-start')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'arg-choice-default-start'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="arg-gentext-choice-end">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key">
      <xsl:choose>
        <xsl:when test="@choice != ''">
          <xsl:value-of select="concat('arg-choice-',@choice,'-end')" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'arg-choice-opt-end'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="arg-gentext-rep">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key">
      <xsl:choose>
        <xsl:when test="@rep != ''">
          <xsl:value-of select="concat('arg-rep-',@rep)" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="'arg-rep-default'" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="arg-gentext-or-separator">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'arg-or-separator'" />
  </xsl:call-template>
</xsl:template>

<xsl:template name="arg-gentext-or-separator-nospace">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'arg-or-separator-nospace'" />
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
