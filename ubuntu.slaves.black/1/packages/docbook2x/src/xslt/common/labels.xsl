<?xml version='1.0'?>
<!-- vim: sta et sw=2
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ============================================================ -->
<!-- label markup -->

<doc:mode mode="for-label" xmlns="">
<refpurpose>Provides access to element labels</refpurpose>
<refdescription>
<para>Processing an element in the
<literal role="mode">for-label</literal> mode produces the
element label.</para>
</refdescription>
</doc:mode>

<xsl:template match="*[@label!='']" priority="2.0" mode="for-label">
  <xsl:value-of select="@label" />
</xsl:template>

<xsl:template match="*" mode="for-label">
  <xsl:call-template name="user-message">
    <xsl:with-param name="key">Erroneous request for the label of this element</xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="qandaentry" mode="for-label">
  <xsl:number level="multiple"
              count="qandadiv|qandaentry"
              format="1.1." />
</xsl:template>

<xsl:template match="question" mode="for-label">
  <xsl:choose>
    <xsl:when test="label">
      <xsl:apply-templates select="label" mode="label" />
    </xsl:when>

    <xsl:when test="ancestor::qandaset/@defaultlabel='none'">
    </xsl:when>

    <xsl:when test="ancestor::qandaset/@defaultlabel='number'">
      <xsl:apply-templates select=".." mode="for-label" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="gentext-label" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="answer" mode="for-label">
  <xsl:choose>
    <xsl:when test="label">
      <xsl:apply-templates select="label" mode="label" />
    </xsl:when>

    <xsl:when test="ancestor::qandaset/@defaultlabel='none'">
    </xsl:when>

    <xsl:when test="ancestor::qandaset/@defaultlabel='number'">
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="gentext-label" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ============================================================ -->

<xsl:template match="*" mode="label">
  <xsl:param name="allow-anchors" select="false()" />
  <xsl:choose>
    <xsl:when test="$allow-anchors">
      <xsl:apply-templates />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="no-anchors" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="text()" mode="label">
  <xsl:value-of select="." />
</xsl:template>

<!-- ============================================================ -->

</xsl:stylesheet>
