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
     $Id: menudescrip.xsl,v 1.16 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Texinfo menu descriptions</title>
<partintro>

<para>
Make descriptions for Texinfo menu entries, if available.
</para>

<section>
<title>Menu descriptions: processing expectations</title>

<para>
If an <sgmltag class="element">abstract</sgmltag> with a <sgmltag
class="attribute">role</sgmltag> of <literal>texinfo-node</literal>
is found, that is rendered as the menu description for the node.
</para>

<para>
Descriptions should be one sentence or phrase long, since
space is limited in a Texinfo menu.  For the same reason,
only the first paragraph of such an 
<sgmltag class="element">abstract</sgmltag> is rendered.
</para>

<para>
Menu descriptions also appear for the Info directory entry
for an Info file; these descriptions are handled just the same
as normal menus, with the <sgmltag class="element">abstract</sgmltag>
apparatus.  On the other hand, the Info directory category
is specified using a <sgmltag class="element">subjectset</sgmltag>
with a <sgmltag class="attribute">scheme</sgmltag> of
<literal>texinfo-directory</literal>.
</para>

<example>
<title>Menu descriptions in the source document</title>

<programlisting
><![CDATA[<article>
  <articleinfo>
    <titleabbrev role="texinfo-node">wget</titleabbrev>
    <abstract role="texinfo-node">
      The non-interactive network downloader.
    </abstract>
    <subjectset scheme="texinfo-directory">
      <subject><subjectterm>Network Applications</subjectterm></subject>
    </subjectset>
  </articleinfo>
]]>
  <replaceable>&#x2026; article content goes here &#x2026;</replaceable>

&lt;/article&gt;</programlisting>
</example>
                
<para>
You may prefer to put the Texinfo descriptions outside of the source document.
This is possible with a custom stylesheet:

<example>
<title>Specifying Texinfo directory entries in a stylesheet</title>

<programlisting
><![CDATA[<xsl:param name="directory-category">
  <xsl:text>General Commands</xsl:text>
</xsl:param>

<xsl:param name="directory-description">
  <xsl:text>Make hard links between files.</xsl:text>
</xsl:param>

<xsl:template match="id('invoking')" mode="for-menu-description">
  <xsl:text>Command-line options</xsl:text>
</xsl:template>

<xsl:template match="id('os')" mode="for-menu-description">
  <xsl:text>Restrictions on linking imposed by the OS</xsl:text>
</xsl:template>
]]>
<replaceable>&#x2026; more entries &#x2026;</replaceable></programlisting>
</example>
</para>

</section>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<doc:mode mode="for-menu-description" xmlns="">
<refpurpose>Return description for Texinfo node</refpurpose>
<refdescription>
<para>
Processing an element using menu-description-mode returns a result tree
fragment that is the description for its menu entry.
</para>
</refdescription>
</doc:mode>

<xsl:template match="refentry" mode="for-menu-description">
  <xsl:variable name="a"
                select="(docinfo/abstract[@role='texinfo-node'] | 
                         refentryinfo/abstract[@role='texinfo-node'])[1]" />
  <xsl:choose>
    <xsl:when test="$a">
      <xsl:apply-templates select="($a/simpara | $a/para | $a/formalpara)[1]"
                           mode="coerce-into-inline" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates select="refnamediv/refpurpose/node()" />
    </xsl:otherwise>
  </xsl:choose>
  
</xsl:template>



<xsl:template match="reference|preface|chapter|appendix|glossary|
                     bibliography|article|part|
                     sect1|sect2|sect3|sect4|sect5|refsect1|refsect2|refsect3|
                     partintro|section|book"
              mode="for-menu-description">
  
  <xsl:variable name="info"
    select="./docinfo|*[local-name(.)=concat(local-name(current()),'info')]" />
  <xsl:variable name="a" select="($info/abstract[@role='texinfo-node'])[1]" />

  <xsl:if test="$a">
    <xsl:apply-templates select="($a/simpara | $a/para | $a/formalpara)[1]"
                         mode="coerce-into-inline" />
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="for-menu-description">
</xsl:template>

<xsl:template name="get-texinfo-directory-description">
  <xsl:param name="node" select="." />
  <xsl:choose>
    <xsl:when test="$directory-description != ''">
      <xsl:value-of select="$directory-description" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates select="$node" mode="for-menu-description" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>


<!-- ==================================================================== -->

<doc:mode mode="for-directory-category" xmlns="">
<refpurpose>Return Info directory category</refpurpose>
<refdescription>
<para>
Processing an element (normally the root element, but also 
<sgmltag class="element">book</sgmltag>s) using menu-description-mode 
returns a result tree fragment that is the Info categorization
for the Texinfo file.
</para>
</refdescription>
</doc:mode>

<xsl:template name="get-texinfo-directory-category">
  <xsl:param name="node" select="." />
  <xsl:choose>
    <xsl:when test="$directory-category != ''">
      <xsl:value-of select="$directory-category" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:apply-templates select="$node" mode="for-directory-category" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="reference|preface|chapter|appendix|glossary|
                     bibliography|article|part|
                     sect1|sect2|sect3|sect4|sect5|refsect1|refsect2|refsect3|
                     partintro|section|book|refentry"
              mode="for-directory-category">

  <xsl:variable name="info"
    select="./docinfo|*[local-name(.)=concat(local-name(current()),'info')]" />
  <xsl:variable name="s" select="($info/subjectset[@scheme='texinfo-directory'])[1]" />

  <xsl:if test="$s">
    <xsl:apply-templates select="($s/subject/subjectterm)[1]/node()" />
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="for-directory-category">
</xsl:template>

</xsl:stylesheet>
