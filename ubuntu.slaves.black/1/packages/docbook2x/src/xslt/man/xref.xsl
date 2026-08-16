<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook2x.sourceforge.net/xsl/localization"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc l"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: xref.xsl,v 1.17 2006/04/14 19:17:28 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Handle cross references and links</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="anchor">
  <!-- Don't do anything, man pages have no hyperlinks -->
</xsl:template>

<!-- ==================================================================== -->

<xsl:key name="id"
         match="*[@id]"
         use="@id" />

<xsl:template match="xref">
  <xsl:variable name="target" select="key('id', @linkend)"/>

  <xsl:call-template name="check-idref">
    <xsl:with-param name="target" select="$target" />
    <xsl:with-param name="bad-content">
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'dangling-xref'" />
        <xsl:with-param name="content" select="string(@linkend)" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="content">
      <xsl:apply-templates select="$target" mode="xref-to" />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

        
<!-- ==================================================================== -->

<xsl:template match="link">
  <xsl:apply-templates />

  <xsl:variable name="target" select="key('id', @linkend)"/>
  <xsl:variable name="text" select="key('id', @endterm)"/>

  <xsl:call-template name="check-idref">
    <xsl:with-param name="target" select="$target" />
    <xsl:with-param name="bad-content">
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'dangling-xref'" />
        <xsl:with-param name="content" select="string(@linkend)" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="content">
      <xsl:variable name="same-man-page">
        <xsl:call-template name="test-same-man-page">
          <xsl:with-param name="target" select="$target" />
        </xsl:call-template>
      </xsl:variable>

      <!-- Suppress redundant man page reference
           if current page and target page are the same. -->
      <xsl:if test="$same-man-page = 'false'">

      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'man-link'" />
        <xsl:with-param name="content">

          <xsl:choose>
            <xsl:when test="$text">
              <xsl:value-of select="$text" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="$target" mode="xref-to" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
      </xsl:if>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->
<doc:template name="test-same-man-page">
  <refpurpose>
     Test if two nodes refer to the same man-page
  </refpurpose>

  <refdescription>
    <para>
      More precisely, test if the target is inside a 
      <sgmltag class="element">refentry</sgmltag>, and
      that <sgmltag class="element">refentry</sgmltag> is 
      the same as the current <sgmltag class="element">refentry</sgmltag>.
    </para>
  </refdescription>
</doc:template>

<xsl:template name="test-same-man-page">
  <xsl:param name="target" />
  <xsl:param name="node" select="." />

  <xsl:variable name="target-refentry" 
                select="$target/ancestor-or-self::refentry[1]" />
  <xsl:variable name="node-refentry" 
                select="$node/ancestor-or-self::refentry[1]" />

  <xsl:value-of select="$target-refentry
                        and count($target-refentry | $node-refentry) !=
                            count($node-refentry)" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="ulink">

  <xsl:choose>
    <xsl:when test="normalize-space(.) = normalize-space(@url)">
      <!-- When the target URI is the content of the ulink.
           Often seen from man pages converted by doclifter. -->
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'man-url'" />
        <xsl:with-param name="content" select="string(@url)" />
      </xsl:call-template>
    </xsl:when>

    <xsl:otherwise>
      <ulink url="{@url}"><xsl:apply-templates /></ulink>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode mode="xref-to" xmlns="">
<refpurpose>Give cross-reference markup</refpurpose>
<refdescription>
<para>
Processing an element with this mode returns the markup/text that should
be used for referring to it in cross-references.</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="xref-to">
  
  <xsl:variable name="refentry" select="ancestor-or-self::refentry[1]" />

  <xsl:choose>
    <xsl:when test="$refentry">
      <!-- Get name of man page -->
      <b>
        <xsl:apply-templates select="$refentry" mode="for-title" />
      </b>
      <xsl:text>(</xsl:text>
      <xsl:value-of select="$refentry/refmeta/manvolnum" />
      <xsl:text>)</xsl:text>
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'xref-non-refentry'" />
        <xsl:with-param name="content">
          <xsl:choose>
            <xsl:when test="@xreflabel">
              <xsl:value-of select="@xreflabel" />
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates select="." mode="for-title" />
            </xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>

</xsl:template>


</xsl:stylesheet>
