<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook2x.sourceforge.net/xsl/localization"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc l"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: callout.xsl,v 1.14 2004/08/22 22:46:06 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Call-outs</title>
<partintro>
<note>
<para>
Out-of-line call-outs (i.e. those specified with <sgmltag class="element">
arearef</sgmltag>) are not supported properly (currently only the coordinates
are printed, with no bug placed in the specified location).
</para>
</note>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="programlistingco|screenco">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="areaspec|areaset|area">
</xsl:template>

<xsl:template match="co" mode="no-inline-markup">
  <xsl:apply-templates select="." />
</xsl:template>

<xsl:template match="co">
  <xsl:param name="label" select="@label" />
  <xsl:call-template name="anchor" />
  <xsl:apply-templates select="." mode="co" />
</xsl:template>

<xsl:template match="co" mode="co">
  <xsl:call-template name="callout-bug">
    <xsl:with-param name="conum">
      <xsl:choose>
        <xsl:when test="@label != ''">
          <xsl:value-of select="@label" />
        </xsl:when>

        <xsl:otherwise>
          <xsl:number count="co" level="any"
                      from="programlisting|screen|literallayout|synopsis"
                      format="1" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="callout-bug">
  <xsl:param name="conum" select="1" />
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$conum"/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="coref">
  <xsl:variable name="co" select="key('id', @linkend)"/>
  <xsl:call-template name="check-co">
    <xsl:with-param name="target" select="$co" />
    <xsl:with-param name="content">
      <xsl:apply-templates select="$co/self::co">
        <xsl:with-param name="label" select="@label" />
      </xsl:apply-templates>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template name="check-co">
  <xsl:param name="target" />
  <xsl:param name="content" />
  <xsl:param name="bad-content" />
  
  <xsl:choose>
    <xsl:when test="not($target)">
      <xsl:call-template name="user-message">
        <xsl:with-param name="arg-1" select="@linkend" />
        <xsl:with-param name="key">reference to non-existent ID</xsl:with-param>
        <xsl:with-param name="content">reference to non-existent ID "<l:a1 />"</xsl:with-param>
      </xsl:call-template>

      <xsl:copy-of select="$bad-content" />
    </xsl:when>
    
    <xsl:when test="not($target/self::co | $target/self::area | $target/self::area-set)">
      <xsl:call-template name="user-message">
        <xsl:with-param name="key">linkend points to an incorrect element</xsl:with-param>
      </xsl:call-template>
      
      <xsl:copy-of select="$bad-content" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
    
<!-- ==================================================================== -->

<xsl:template match="calloutlist">
  <xsl:call-template name="anchor" />
  <xsl:call-template name="formal-object-title" />
  <varlist>
    <xsl:apply-templates />
  </varlist>
</xsl:template>

<xsl:template match="callout">
  <varlistentry>
    <xsl:call-template name="callout-process-arearefs" />

    <listitem>
      <xsl:apply-templates/>
    </listitem>
  </varlistentry>
</xsl:template>

<xsl:template name="callout-process-arearefs">
  <xsl:param name="arearefs" select="@arearefs" />
  <xsl:if test="$arearefs != ''">
    <xsl:choose>
      <xsl:when test="substring-before($arearefs,' ') = ''">
        <xsl:call-template name="callout-arearef">
          <xsl:with-param name="arearef" select="$arearefs"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="callout-arearef">
          <xsl:with-param name="arearef"
                          select="substring-before($arearefs,' ')"/>
        </xsl:call-template>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:call-template name="callout-process-arearefs">
      <xsl:with-param name="arearefs"
                      select="substring-after($arearefs,' ')"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="callout-arearef">
  <xsl:param name="arearef"></xsl:param>
  <xsl:variable name="targets" select="key('id', $arearef)"/>
  <xsl:variable name="target" select="$targets[1]"/>

  <term>
  <xsl:call-template name="check-co">
    <xsl:with-param name="target" select="$target" />
    <xsl:with-param name="bad-content">
      <xsl:value-of select="$arearef" />
    </xsl:with-param>

    <xsl:with-param name="content">

    <xsl:choose>
    <xsl:when test="$target/self::co">
      <pxref>
        <xsl:attribute name="idref">
          <xsl:call-template name="print-id">
            <xsl:with-param name="node" select="$target" />
          </xsl:call-template>
        </xsl:attribute>

        <xsl:apply-templates select="$target" mode="co" />
      </pxref>
    </xsl:when>

    <xsl:when test="$target/self::areaset | $target/self::area">
      <!-- Just print the coordinates -->
      <xsl:value-of select="$target/@coords" />
    </xsl:when>
    
    <xsl:otherwise>
      <xsl:call-template name="user-message">
        <xsl:with-param name="key">linkend points to an incorrect element</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key">[missing text]</xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
    </xsl:choose>

    </xsl:with-param>
  </xsl:call-template>
  </term>

</xsl:template>

</xsl:stylesheet>
