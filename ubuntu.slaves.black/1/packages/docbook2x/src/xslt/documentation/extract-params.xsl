<?xml version='1.0'?>
<!-- vim: sta et sw=2

This stylesheet extracts parameter documentation
into a variablelist that can be included in the mainline documentation.

-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc xsl"
                xml:lang="en">

<!-- ==================================================================== -->
<xsl:output method="xml" encoding="utf-8" omit-xml-declaration="yes" />

<xsl:param name="process-includes" select="false()" />
<xsl:param name="process-imports"  select="false() " />

<!-- ==================================================================== -->
<xsl:template match="/">
  <variablelist>
    <xsl:apply-templates />
  </variablelist>
</xsl:template>

<xsl:template match="xsl:stylesheet">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="*">
</xsl:template>

<xsl:template match="text()">
</xsl:template>

<xsl:template match="refpurpose">
  <formalpara>
    <title>Brief</title>
    <para>
      <xsl:apply-templates mode="copy-doc" />
    </para>
  </formalpara>

  <formalpara>
    <title>Default setting</title>
    <para>
      <xsl:variable name="param-name" select="../@name" />
      <xsl:variable name="param-value" select="/xsl:stylesheet/xsl:param[@name = $param-name]/@select" />

      <xsl:choose>
        <xsl:when test="$param-value = 'true()'">
          <literal>1</literal><xsl:text> (boolean true)</xsl:text>
        </xsl:when>

        <xsl:when test="$param-value = 'false()'">
          <literal>0</literal><xsl:text> (boolean false)</xsl:text>
        </xsl:when>

        <xsl:when test="$param-value = &quot;''&quot;">
          <xsl:text>(blank)</xsl:text>
        </xsl:when>

        <xsl:otherwise>
          <literal>
            <xsl:value-of select="translate($param-value, &quot;'&quot;, &quot;&quot;)" />
          </literal>
        </xsl:otherwise>
      </xsl:choose>

    </para>
  </formalpara>
</xsl:template>

<xsl:template match="refdescription">
  <xsl:apply-templates mode="copy-doc" />
</xsl:template>

<xsl:template match="doc:param">
  <varlistentry>
    <term><parameter><xsl:apply-templates select="@name" /></parameter></term>

    <listitem>
      <xsl:apply-templates />
    </listitem>
  </varlistentry>
</xsl:template>

<xsl:template match="@*|node()" mode="copy-doc">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="copy-doc" />
  </xsl:copy>
</xsl:template>



<!-- ==================================================================== -->
                    
<xsl:strip-space elements="xsl:stylesheet"/>

<!-- ==================================================================== -->

<xsl:template name="display-filename">
  <xsl:param name="filename" />
  <!-- Texinfo cannot handle dots in node names, so avoid them -->
  <xsl:call-template name="string-subst">
    <xsl:with-param name="content">
  <xsl:call-template name="string-subst">
    <xsl:with-param name="content" select="$filename" />
    <xsl:with-param name="replace" select="'.xsl'" />
    <xsl:with-param name="with"    select="''" />
  </xsl:call-template>
    </xsl:with-param>
    
    <xsl:with-param name="replace" select="'../'" />
    <xsl:with-param name="with"    select="''" />
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xsl:include" mode="process-includes">
  <!-- Don't go up directories -->
  <xsl:apply-templates select="document(@href)/*">
    <xsl:with-param name="filename" select="@href" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="xsl:import" mode="process-includes">
  <xsl:if test="$process-imports">
    <xsl:apply-templates select="document(@href)/*">
      <xsl:with-param name="filename" select="@href" />
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
