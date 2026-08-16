<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:date="http://exslt.org/dates-and-times"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc date"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: refentry.xsl,v 1.19 2006/04/21 02:39:55 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title><sgmltag class="element">refentry</sgmltag> markup</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="reference">
</xsl:template>

  <!-- If the title is entirely uppercase, as in some 
       man pages (particularly coming from doclifter), 
       then we will lowercase the filename (title) of the man page -->
<xsl:template name="refentry-filename">
  <xsl:param name="title" />

  <xsl:variable name="title2" select="translate($title, &quot; /&quot;, &quot;__&quot;)" />

  <!-- not using gentext here since man page names tend not to have
       accented chars / non-Latin chars ...
       if they do I think you've got more serious problems :) -->
  <xsl:variable name="lowercase-alphabet" 
                select="'abcdefghijklmnopqrstuvwxyz'" />

  <xsl:choose>
    <xsl:when test="not($lowercase-file)">
      <xsl:value-of select="$title2" />
    </xsl:when>

    <!-- If there does not exist lowercase letters in title ... -->
    <xsl:when test="translate($title2, $lowercase-alphabet, '') = $title2">
      <!-- i.e. all letters are uppercase, then force to lowercase -->
      <xsl:value-of 
        select="translate($title2, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 
                                   $lowercase-alphabet)" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="$title2" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="refentry">

  <xsl:variable name="title">
    <xsl:choose>
      <xsl:when test="./refmeta">
        <xsl:apply-templates select="./refmeta/refentrytitle" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates select="./refnamediv/refname[1]" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="manpage">
    <xsl:with-param name="title">
      <xsl:call-template name="refentry-filename">
        <xsl:with-param name="title" select="$title" />
      </xsl:call-template>
    </xsl:with-param>

    <xsl:with-param name="h1" select="$title" />

    <xsl:with-param name="section">
      <xsl:choose>
        <xsl:when test="./refmeta/manvolnum">
          <xsl:apply-templates select="./refmeta/manvolnum"
                               mode="header-text" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$default-manpage-section" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  
    <xsl:with-param name="h3">
      <xsl:choose>
        <xsl:when test="$header-3 != ''">
          <xsl:value-of select="$header-3" />
        </xsl:when>

        <!-- Used by doclifter -->
        <xsl:when test="refmeta/refmiscinfo[@class='date']">
          <xsl:apply-templates
            select="(refmeta/refmiscinfo[@class='date'])[1]"
            mode="header-text" />
        </xsl:when>

        <xsl:when test="(refentryinfo/date | docinfo/date)">
          <xsl:apply-templates 
            select="(refentryinfo/date | docinfo/date)[1]"
            mode="header-text" />
        </xsl:when>

        <xsl:otherwise>
          <xsl:if test="function-available('date:date')">
            <xsl:value-of select="date:day-in-month()" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="date:month-name()" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="date:year()" />
          </xsl:if>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
        
    <xsl:with-param name="h4">
      <xsl:choose>
        <xsl:when test="$header-4 != ''">
          <xsl:value-of select="$header-4" />
        </xsl:when>

        <xsl:when test="refmeta/refmiscinfo[not(@class='manual' or @class='date')]">
          <xsl:apply-templates
            select="(refmeta/refmiscinfo[not(@class='manual' or @class='date')])[1]"
            mode="header-text" />
        </xsl:when>

        <xsl:otherwise>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
        
    <xsl:with-param name="h5">
      <xsl:choose>
        <xsl:when test="$header-5 != ''">
          <xsl:value-of select="$header-5" />
        </xsl:when>

        <!-- Used by doclifter -->
        <xsl:when test="refmeta/refmiscinfo[@class='manual']">
          <xsl:apply-templates
            select="(refmeta/refmiscinfo[@class='manual'])[1]"
            mode="header-text" />
        </xsl:when>

        <xsl:otherwise>
          <!-- man(7) suggests this should be something like
               "Linux Programmer's Manual", so using
               the title here should be correct -->
          <xsl:apply-templates select="(/*/title)[1]" 
                               mode="header-text" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>

  </xsl:call-template>
</xsl:template>


<xsl:template match="*" mode="header-text">
  <xsl:apply-templates mode="header-text" />
</xsl:template>

<xsl:template match="text()" mode="header-text">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="refmeta">
</xsl:template>

<xsl:template match="refentrytitle">
  <b>
    <xsl:apply-templates />
  </b>
</xsl:template>

<xsl:template match="manvolnum">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates/>
  <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="refmiscinfo">
</xsl:template>

<xsl:template match="refnamediv">
  <xsl:call-template name="SH-section">
    <xsl:with-param name="title">
      <xsl:call-template name="uppercase-title">
        <xsl:with-param name="content">
          <xsl:call-template name="gentext-title" />
        </xsl:with-param>
      </xsl:call-template>
    </xsl:with-param>

    <xsl:with-param name="content">
      <refnameline>
        <xsl:apply-templates select="refname|refpurpose" />
      </refnameline>

      <xsl:apply-templates select="refclass" />
    </xsl:with-param>
  </xsl:call-template>

</xsl:template>

<xsl:template match="refname">
  <refname>
    <xsl:apply-templates />
  </refname>
</xsl:template>

<xsl:template match="refpurpose">
  <refpurpose>
    <xsl:apply-templates />
  </refpurpose>
</xsl:template>

<xsl:template match="refdescriptor">
</xsl:template>

<xsl:template match="refclass">
  <para>
    <xsl:if test="@role">
      <xsl:value-of select="@role"/>
      <xsl:text>: </xsl:text>
    </xsl:if>
    <xsl:apply-templates/>
  </para>
</xsl:template>

<xsl:template match="refsynopsisdiv">
  <xsl:call-template name="SH-section">
    <xsl:with-param name="title">
      <xsl:choose>
        <xsl:when test="title">
          <xsl:apply-templates select="title" mode="title" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:call-template name="uppercase-title">
            <xsl:with-param name="content">
              <xsl:call-template name="gentext-title" />
            </xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="refsection">
  <xsl:call-template name="SH-section" />
</xsl:template>

<xsl:template match="refsect1">
  <xsl:call-template name="SH-section" />
</xsl:template>

<xsl:template match="refsect2">
  <xsl:call-template name="SS-section" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="refsect1/title//text()|refsect2/title//text()"
              name="uppercase-title"
              mode="title">

  <xsl:param name="content" select="." />

  <xsl:choose>
    <xsl:when test="$uppercase-headings">
      <xsl:call-template name="ucase">
        <xsl:with-param name="content" select="$content" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
