<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
  xmlns:l="http://docbook2x.sourceforge.net/xsl/localization"
  xmlns:dl="http://docbook2x.sourceforge.net/xsl/document-localization"
  exclude-result-prefixes="doc l dl"
  version='1.0'
  xml:lang="en">

<!-- ********************************************************************
     $Id: gentext.xsl,v 1.6 2006/04/12 02:14:00 stevecheng Exp $
     ********************************************************************

     &copy; 2000 Steve Cheng <stevecheng@users.sourceforge.net>

     Templates to help l10n.
     ******************************************************************** -->
<!-- ==================================================================== -->

<!-- 
     In the following templates, some complex XPaths are used,
     which at first glance seems to be inefficient.
     Indeed if we do profiling with xsltproc it will show
     that a large portion of time is spent in these templates.

     The most straightforward fix would be to use key look-ups
     as the substitute for the complex XPaths.  Unfortunately,
     on xsltproc this method actually *decreases* performances,
     because the xsl:key implementation in xsltproc is fairly
     suboptimal.  (Each xsl:key adds a non-trivial processing 
     cost to each document; about 2.5 seconds per 180 small input
     documents.)  For this reason, we comment out the following
     theoretically more optimized code.
-->
 
<!--    
<xsl:key name="l10n.title" match="dl:title"
         use="concat(../@lang, '.', @element)" />
<xsl:key name="l10n.label" match="dl:label"
         use="concat(../@lang, '.', @element)" />
<xsl:key name="l10n.label" match="dl:rendering"
         use="concat(../@lang, '.', @key)" />
<xsl:key name="l10n.text" match="dl:text"
         use="concat(../@lang, '.', @key)" />
<xsl:template name="lookup-gentext">
  <xsl:param name="content" />
  <xsl:param name="type" />
  <xsl:param name="key" />

  <xsl:for-each select="$custom-l10n-data">
  <xsl:variable name="data"
                select="key($type, $key)[last()]" />
  <xsl:choose>
  <xsl:when test="$data">
  <xsl:apply-templates select="$data/node()" mode="l10n-substitution">
    <xsl:with-param name="content" select="$content" />
  </xsl:apply-templates>
  </xsl:when>
  <xsl:otherwise>
  <xsl:for-each select="$l10n-data">
  <xsl:variable name="data2"
                select="key($type, $key)[last()]" />
  <xsl:apply-templates select="$data2/node()" mode="l10n-substitution">
    <xsl:with-param name="content" select="$content" />
  </xsl:apply-templates>
  </xsl:for-each>
  </xsl:otherwise>
  </xsl:choose>
  </xsl:for-each>
</xsl:template>
</xsl:template>
-->

<xsl:template name="gentext-title">
  <xsl:param name="element-name" select="name(.)" />
  <xsl:param name="content" />
  <xsl:param name="lang">
    <xsl:call-template name="l10n-xml-actual-language">
      <xsl:with-param name="target" select="." />
    </xsl:call-template>
  </xsl:param>

  <xsl:param name="key" />

  <xsl:variable name="custom"
    select="($custom-l10n-data/l:locale[@lang=$lang]/dl:title[@element=$element-name])[last()]" />
  <xsl:variable name="standard"
    select="($l10n-data/l:locale[@lang=$lang]/dl:title[@element=$element-name])[last()]" />

  <xsl:choose>
    <xsl:when test="$custom">
      <xsl:apply-templates select="$custom/node()" mode="l10n-substitution">
        <xsl:with-param name="content" select="$content" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$standard">
      <xsl:apply-templates select="$standard/node()" mode="l10n-substitution">
        <xsl:with-param name="content" select="$content" />
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template name="gentext-label">
  <xsl:param name="element-name" select="name(.)" />
  <xsl:param name="content" />
  <xsl:param name="lang">
    <xsl:call-template name="l10n-xml-actual-language">
      <xsl:with-param name="target" select="." />
    </xsl:call-template>
  </xsl:param>

  <xsl:param name="key" />

  <xsl:variable name="custom"
    select="($custom-l10n-data/l:locale[@lang=$lang]/dl:label[@element=$element-name])[last()]" />
  <xsl:variable name="standard"
    select="($l10n-data/l:locale[@lang=$lang]/dl:label[@element=$element-name])[last()]" />

  <xsl:choose>
    <xsl:when test="$custom">
      <xsl:apply-templates select="$custom/node()" mode="l10n-substitution">
        <xsl:with-param name="content" select="$content" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$standard">
      <xsl:apply-templates select="$standard/node()" mode="l10n-substitution">
        <xsl:with-param name="content" select="$content" />
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>

</xsl:template>

<xsl:template name="gentext-rendering">
  <xsl:param name="key" select="name(.)" />
  <xsl:param name="content" />
  <xsl:param name="lang">
    <xsl:call-template name="l10n-xml-actual-language">
      <xsl:with-param name="target" select="." />
    </xsl:call-template>
  </xsl:param>

  <xsl:variable name="custom"
    select="($custom-l10n-data/l:locale[@lang=$lang]/dl:rendering[@key=$key])[last()]" />
  <xsl:variable name="standard"
    select="($l10n-data/l:locale[@lang=$lang]/dl:rendering[@key=$key])[last()]" />

  <xsl:choose>
    <xsl:when test="$custom">
      <xsl:apply-templates select="$custom/node()" mode="l10n-substitution">
        <xsl:with-param name="content" select="$content" />
      </xsl:apply-templates>
    </xsl:when>
    <xsl:when test="$standard">
      <xsl:apply-templates select="$standard/node()" mode="l10n-substitution">
        <xsl:with-param name="content" select="$content" />
      </xsl:apply-templates>
    </xsl:when>
  </xsl:choose>

</xsl:template>


<xsl:template name="gentext-text">
  <xsl:param name="target" select="." />
  <xsl:param name="key" />
  <xsl:param name="lang">
    <xsl:call-template name="l10n-xml-actual-language">
      <xsl:with-param name="target" select="$target" />
    </xsl:call-template>
  </xsl:param>

  <xsl:variable name="custom"
    select="($custom-l10n-data/l:locale[@lang=$lang]/dl:text[@key=$key])[last()]" />
  <xsl:variable name="standard"
    select="($l10n-data/l:locale[@lang=$lang]/dl:text[@key=$key])[last()]" />

  <xsl:choose>
    <xsl:when test="$custom/node()">
      <xsl:value-of select="$custom" />
    </xsl:when>
    <xsl:when test="$standard/node()">
      <xsl:value-of select="$standard" />
    </xsl:when>
  </xsl:choose>

</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="dl:content" mode="l10n-substitution">
  <xsl:param name="content" />
  <xsl:copy-of select="$content" />
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

