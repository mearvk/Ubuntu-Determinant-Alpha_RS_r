<?xml version='1.0'?>
<!-- vim: sta et sw=2
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                xml:lang="en">

<xsl:template match="text()" mode="quote-xml">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="*" mode="quote-xml">
  <xsl:param name="content" select="node()" />

  <xsl:text>&lt;</xsl:text>
  <xsl:value-of select="name(.)" />
  <xsl:apply-templates select="attribute::*" mode="quote-xml" />

  <xsl:choose>
    <xsl:when test="$content">
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates select="$content" mode="quote-xml" />
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:text>&gt;</xsl:text>
    </xsl:when>

    <xsl:otherwise>
      <xsl:text> /&gt;</xsl:text>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="@*" mode="quote-xml">
  <xsl:text> </xsl:text>
  <xsl:value-of select="name(.)" />
  <xsl:text>="</xsl:text>
  <xsl:value-of select="." />
  <xsl:text>"</xsl:text>
</xsl:template>

<xsl:template match="comment()" mode="quote-xml">
  <xsl:text>&lt;--&#10;</xsl:text>
  <xsl:value-of select="." />
  <xsl:text>&#10;--&gt;</xsl:text>
</xsl:template>

<xsl:template match="processing-instruction()" mode="quote-xml">
  <xsl:text>&lt;?</xsl:text>
  <xsl:value-of select="local-name(.)" />
  <xsl:text> </xsl:text>
  <xsl:value-of select="." />
  <xsl:text>?&gt;</xsl:text>
</xsl:template>

</xsl:stylesheet>
