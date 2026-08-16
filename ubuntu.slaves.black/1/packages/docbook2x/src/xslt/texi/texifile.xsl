<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: texifile.xsl,v 1.17 2006/04/20 03:23:03 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<doc:reference xmlns="">
<title>Handle multiple files in Texinfo</title>
<partintro>
<para>
These templates are used when making cross references between the
multiple Texinfo files that are generated from a single DocBook <sgmltag
class="element">set</sgmltag>.  You probably do not need to modify
anything here.
</para>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<!-- ==================================================================== -->

<xsl:template match="*" mode="texinfo-file-name">
  <xsl:apply-templates mode="texinfo-file-name" />
</xsl:template>

<xsl:template match="text()" mode="texinfo-file-name">
  <xsl:call-template name="lcase">
    <xsl:with-param name="content" 
                    select="normalize-space(translate(string(.), &quot; /&quot;, &quot;__&quot;))" />
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="set/book" mode="for-texinfo-file-name" priority="2.0">
  <xsl:choose>
    <xsl:when test="bookinfo/titleabbrev[@role='texinfo-file']">
      <xsl:value-of select="bookinfo/titleabbrev[@role='texinfo-file']" />
    </xsl:when>
  
    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="bookinfo/titleabbrev">
      <xsl:apply-templates select="bookinfo/titleabbrev[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="bookinfo/title">
      <xsl:apply-templates select="bookinfo/title[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
  
    <xsl:otherwise>
      <xsl:call-template name="user-message">
        <xsl:with-param name="key">Cannot generate Texinfo filename</xsl:with-param>
      </xsl:call-template>
  
      <!-- At the very least we can generate valid files -->
      <xsl:text>book</xsl:text>
      <xsl:value-of select="count(preceding-sibling::book) + 1" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- this isn't the best implementation,
     but then most users probably aren't converting lone refentries
     to Texinfo anyway -->
<xsl:template match="/refentry" mode="for-texinfo-file-name" priority="3.0">
  <xsl:variable name="info" 
      select="docinfo | refentryinfo" />
  <xsl:choose>
    <xsl:when test="$info/titleabbrev[@role='texinfo-file']">
      <xsl:value-of select="$info/titleabbrev[@role='texinfo-file']" />
    </xsl:when>
    
    <xsl:when test="$info/titleabbrev">
      <xsl:apply-templates select="$info/titleabbrev[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="$info/title">
      <xsl:apply-templates select="$info/title[1]"
                           mode="texinfo-file-name" />
    </xsl:when>

    <xsl:when test="refmeta">
      <xsl:apply-templates select="refmeta/refentrytitle"
                           mode="texinfo-file-name" />
    </xsl:when>

    <xsl:when test="refnamediv">
      <xsl:apply-templates select="refnamediv/refname[1]"
                           mode="texinfo-file-name" />
    </xsl:when>

    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>


<xsl:template match="/*" mode="for-texinfo-file-name" priority="2.0">
  <xsl:variable name="info" 
      select="docinfo | *[local-name(.)=concat(local-name(current()),'info')]" />
  <xsl:choose>
    <xsl:when test="$info/titleabbrev[@role='texinfo-file']">
      <xsl:value-of select="$info/titleabbrev[@role='texinfo-file']" />
    </xsl:when>
    
    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="$info/titleabbrev">
      <xsl:apply-templates select="$info/titleabbrev[1]"
                           mode="texinfo-file-name" />
    </xsl:when>
    <xsl:when test="$info/title">
      <xsl:apply-templates select="$info/title[1]"
                           mode="texinfo-file-name" />
    </xsl:when>

    <xsl:otherwise></xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="/set/book//*" priority="1.0" 
              mode="for-texinfo-file-name">
  <xsl:apply-templates select="ancestor-or-self::book" 
                       mode="for-texinfo-file-name" />
</xsl:template>

<xsl:template match="node()" mode="for-texinfo-file-name">
  <xsl:apply-templates select="/*" mode="for-texinfo-file-name" />
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="get-texinfo-file-name" xmlns="">
<refpurpose>Find the file that contains the result</refpurpose>
<refdescription>
<para>
Returns the Texinfo file that contains the result when transforming
the context node.
</para>
<para>
In this implementation, every document element starts a new file, unless
the document element is <sgmltag class="element">set</sgmltag>, in which
case each child <sgmltag class="element">book</sgmltag> starts a new
file.
</para>
</refdescription>
<refparameter>
<variablelist>
<varlistentry>
<term><parameter>node</parameter></term>
<listitem><para>
The node to find information for.  Default is the context node.
</para></listitem>
</varlistentry>
</variablelist>
</refparameter>
</doc:template>
 
<xsl:template name="get-texinfo-file-name">
  <xsl:param name="node" select="." />
  
  <xsl:choose>
    <xsl:when test="$output-file != ''">
      <xsl:value-of select="$output-file" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates select="$node" mode="for-texinfo-file-name" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>

