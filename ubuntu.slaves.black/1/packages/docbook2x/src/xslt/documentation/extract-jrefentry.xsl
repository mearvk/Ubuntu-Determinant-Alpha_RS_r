<?xml version='1.0'?>
<!-- vim: sta et sw=2
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc xsl"
                xml:lang="en">

<xsl:include href="quote-xml.xsl" />

<xsl:output method="xml" />

<!-- ==================================================================== -->

<xsl:param name="process-includes" select="true()" />
<xsl:param name="process-imports"  select="false() " />
<xsl:param name="input-filename" select="'stdin'" />
<xsl:param name="title">untitled</xsl:param>

<!-- ==================================================================== -->

<xsl:strip-space elements="xsl:stylesheet"/>

<xsl:template match="/">
  <part>
    <title>
      <xsl:copy-of select="$title" />
    </title>

    <xsl:apply-templates />
  </part>
</xsl:template>

<xsl:template match="xsl:stylesheet">
  <xsl:param name="filename" select="$input-filename" />
  <xsl:apply-templates mode="process-includes" />

  <xsl:if test="doc:*">
    <reference>
      <xsl:if test="doc:reference/title">
        <referenceinfo>
          <abstract role="texinfo-node">
            <para>
              <xsl:apply-templates select="doc:reference/title/node()" 
                                   mode="copy-doc" />
            </para>
          </abstract>
        </referenceinfo>
      </xsl:if>
      
      <title>
        <xsl:call-template name="display-filename">
          <xsl:with-param name="filename" select="$filename" />
        </xsl:call-template>
      </title>

      <xsl:apply-templates select="doc:reference/partintro"
                           mode="copy-doc" />

      <xsl:apply-templates>
        <xsl:with-param name="filename" select="$filename" />
      </xsl:apply-templates>
    </reference>
  </xsl:if>
</xsl:template>

<xsl:template match="*|text()"></xsl:template>

<!-- ==================================================================== -->

<xsl:template name="display-filename">
  <xsl:param name="filename" />
  <xsl:value-of select="$filename" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xsl:template[@name]">
  <xsl:variable name="doc" select="../doc:template[@name = current()/@name]" />

  <refentry>
    <refnamediv>
      <refname>
        <xsl:text>[T] </xsl:text>
        <xsl:value-of select="@name" />
      </refname>
      <xsl:choose>
        <xsl:when test="$doc">
          <xsl:copy-of select="$doc/refpurpose" />
        </xsl:when>
        <xsl:otherwise>
          <refpurpose>Undocumented</refpurpose>
        </xsl:otherwise>
      </xsl:choose>
    </refnamediv>

    <refsynopsisdiv>
      <synopsis>
        <xsl:apply-templates select="." mode="quote-xml">
          <xsl:with-param name="content" select="xsl:param|text()[following-sibling::xsl:param]" />
        </xsl:apply-templates>
      </synopsis>
    </refsynopsisdiv>

    <xsl:apply-templates select="$doc/node()" mode="copy-doc" />
  </refentry>
</xsl:template>

<xsl:template match="xsl:template">
  <refentry>
    <refnamediv>
      <refname>
        <xsl:text>[t</xsl:text>
        <xsl:if test="@mode">
          <xsl:text> </xsl:text>
          <xsl:value-of select="@mode" />
        </xsl:if>
        <xsl:text>] </xsl:text>
        <xsl:value-of select="@match" />
      </refname>
    </refnamediv>

    <refsynopsisdiv>
      <synopsis>
        <xsl:apply-templates select="." mode="quote-xml">
          <xsl:with-param name="content" select="xsl:param|text()[following-sibling::xsl:param]" />
        </xsl:apply-templates>
      </synopsis>
    </refsynopsisdiv>
  </refentry>
</xsl:template>


<xsl:template match="xsl:param">
  <xsl:variable name="doc" select="../doc:param[@name = current()/@name]" />
  
  <refentry>
    <refnamediv>
      <refname>
        <xsl:text>[P] </xsl:text>
        <xsl:value-of select="@name" />
      </refname>
      <xsl:choose>
        <xsl:when test="$doc">
          <xsl:copy-of select="$doc/refpurpose" />
        </xsl:when>
        <xsl:otherwise>
          <refpurpose>Undocumented</refpurpose>
        </xsl:otherwise>
      </xsl:choose>
    </refnamediv>

    <refsynopsisdiv>
      <synopsis>
        <xsl:apply-templates select="." mode="quote-xml" />
      </synopsis>
    </refsynopsisdiv>

    <xsl:apply-templates select="$doc/node()" mode="copy-doc" />
  </refentry>
</xsl:template>

<xsl:template match="xsl:variable">
  <xsl:variable name="doc" select="../doc:variable[@name = current()/@name]" />
  
  <refentry>
    <refnamediv>
      <refname>
        <xsl:text>[V] </xsl:text>
        <xsl:value-of select="@name" />
      </refname>
      <xsl:choose>
        <xsl:when test="$doc">
          <xsl:copy-of select="$doc/refpurpose" />
        </xsl:when>
        <xsl:otherwise>
          <refpurpose>Undocumented</refpurpose>
        </xsl:otherwise>
      </xsl:choose>
    </refnamediv>

    <refsynopsisdiv>
      <synopsis>
        <xsl:apply-templates select="." mode="quote-xml" />
      </synopsis>
    </refsynopsisdiv>
    
    <xsl:apply-templates select="$doc/node()" mode="copy-doc" />
  </refentry>
</xsl:template>

<xsl:template match="xsl:attribute-set">
  <xsl:variable name="doc" select="../doc:attribute-set[@name = current()/@name]" />

  <refentry>
    <refnamediv>
      <refname>
        <xsl:text>[AttrSet] </xsl:text>
        <xsl:value-of select="@name" />
      </refname>
      <xsl:choose>
        <xsl:when test="$doc">
          <xsl:copy-of select="$doc/refpurpose" />
        </xsl:when>
        <xsl:otherwise>
          <refpurpose>Undocumented</refpurpose>
        </xsl:otherwise>
      </xsl:choose>
    </refnamediv>

    <refsynopsisdiv>
      <synopsis>
        <xsl:apply-templates select="." mode="quote-xml" />
      </synopsis>
    </refsynopsisdiv>
 
    <xsl:apply-templates select="$doc/node()" mode="copy-doc" />
  </refentry>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xsl:include" mode="process-includes">
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

<xsl:template match="*|text()" mode="process-includes">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="doc:reference">
  <!-- This is copied at the beginning -->
</xsl:template>


<xsl:template match="doc:mode">
  <refentry>
    <refnamediv>
      <refname>
        <xsl:text>[M] </xsl:text>
        <xsl:value-of select="@mode" />
      </refname>
      <xsl:copy-of select="refpurpose" />
    </refnamediv>

    <xsl:apply-templates mode="copy-doc" />
  </refentry>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="refpurpose" mode="copy-doc">
</xsl:template>

<xsl:template match="@*|node()" mode="copy-doc">
  <xsl:copy>
    <xsl:apply-templates select="@*|node()" mode="copy-doc" />
  </xsl:copy>
</xsl:template>

</xsl:stylesheet>
