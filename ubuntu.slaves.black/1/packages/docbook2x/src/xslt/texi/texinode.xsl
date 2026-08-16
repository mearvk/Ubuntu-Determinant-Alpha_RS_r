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
     $Id: texinode.xsl,v 1.30 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<doc:reference xmlns="">
<title>Nodal elements and their node names</title>
<partintro>
<para>
These templates determine which elements get transformed into Texinfo
nodes, and how to derive a Texinfo node name for these nodes.
</para>

<section>
<title>Texinfo node names: processing expectations</title>

<para>
The templates try to derive a Texinfo node name of a nodal section from
the content of the following, in order of preference:

<orderedlist>
<listitem>
<para><sgmltag class="element">titleabbrev</sgmltag> with <sgmltag
class="attribute">role</sgmltag>="texinfo-node" in the <sgmltag
class="element"><replaceable>*</replaceable>info</sgmltag>
wrapper.</para>
</listitem>

<listitem>
<para>The <sgmltag class="attribute">xreflabel</sgmltag></para>
</listitem>

<listitem>
<para>The <sgmltag class="element">titleabbrev</sgmltag></para>
</listitem>

<listitem>
<para>The <sgmltag class="element">title</sgmltag></para>
</listitem>

</orderedlist>
</para>

</section>
</partintro>
</doc:reference>



<!-- ==================================================================== -->

<doc:mode mode="is-texinfo-node" xmlns="">
<refpurpose>Determine if given element is a Texinfo node</refpurpose>
<refdescription>
<para>
This mode defines which elements are to be transformed into Texinfo
node.  Elements that generate anchors are not considered nodes by this mode.
</para>
<para>
The set of nodal elements can be changed, but only sectioning elements
can be nodes and the stylesheets do not support any fancy interleaving
of nodal sections and non-nodal sections.
</para>
<para>
Return empty string for an element that is not a node,
and the string <literal>1</literal> if it is.
</para>
</refdescription>
</doc:mode>

<!-- Components, divisions. -->
<xsl:template match="dedication|preface|chapter|appendix|reference|article"
              mode="is-texinfo-node">
  <xsl:value-of select="1" />
</xsl:template>

<!-- Sections -->
<xsl:template match="sect1|sect2|sect3|sect4|sect5|section|simplesect"
              mode="is-texinfo-node">
  <xsl:value-of select="1" />
</xsl:template>

<xsl:template match="refentry" mode="is-texinfo-node">
  <xsl:value-of select="1" />
</xsl:template>

<xsl:template match="*" mode="is-texinfo-node">
</xsl:template>
  
<!-- Part and partintro behave specially for menus and heading hierarchy;
     do not change. -->
<xsl:template match="part" mode="is-texinfo-node">
  <xsl:value-of select="1" />
</xsl:template>

<xsl:template match="partintro|partintro//*" mode="is-texinfo-node">
</xsl:template>

<xsl:template match="book" mode="is-texinfo-node">
  <xsl:value-of select="1" />
</xsl:template>

<!-- The elements index, bibliography, and glossary.
     These occur in books, parts, and articles, where they behave
     as if they were a "component" (in DocBook parlance).
     
     But these three elements also occur as part of the nav.class 
     of sections and components.  In this case one has to be careful,
     since they are allowed to occur before any of the "mix" content
     (paras and so on). -->
<xsl:template match="index|bibliography|glossary" mode="is-texinfo-node">
  <xsl:choose>
    <xsl:when test="parent::book or parent::part or parent::article">
      <xsl:value-of select="1" />
    </xsl:when>
    
    <xsl:when test="count(following-sibling::*[
                            local-name(.) != 'toc' and
                            local-name(.) != 'lot' and
                            local-name(.) != 'index' and
                            local-name(.) != 'glossary' and
                            local-name(.) != 'bibliography']) &gt; 0">
      <!-- If true, this is the front nav.class,
           if false, this is the back nav.class -->
    </xsl:when>

    <xsl:otherwise>
      <xsl:value-of select="1" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

     

<!-- ==================================================================== -->

<doc:mode mode="for-texinfo-node-name" xmlns="">
<refpurpose>Return a suggested nodename</refpurpose>
<refdescription>
<para>
Processing an element using for-texinfo-node-name returns a suggested
nodename (or anchor name) for that element.
</para>
</refdescription>
</doc:mode>

<xsl:template match="*[@xreflabel]" mode="for-texinfo-node-name" 
                                    priority="2.0">
  <xsl:apply-templates select="@xreflabel" 
                       mode="texinfo-node-name" />
</xsl:template>

<xsl:template match="*[child::title]" mode="for-texinfo-node-name" priority="-1.0">
  <xsl:apply-templates select="title"
                       mode="texinfo-node-name" />
</xsl:template>

<xsl:template match="*" mode="for-texinfo-node-name" priority="-2.0">
  <!-- If the original document has an ID for this element, 
       try using it.  Otherwise, give no suggested name. -->
  <xsl:if test="not($explicit-node-names) and @id != ''">
    <xsl:value-of select="@id" />
  </xsl:if>
</xsl:template>

<!-- The top most node must be named "Top" in Texinfo.  -->
<xsl:template match="book|/*" mode="for-texinfo-node-name" priority="5.0">
  <xsl:value-of select="'Top'" />
</xsl:template>

<xsl:template match="reference|preface|chapter|appendix|glossary|bibliography|
                     sect1|sect2|sect3|sect4|sect5|section|refsect1|refsect2|refsect3"
              mode="for-texinfo-node-name">
  
  <xsl:variable name="info" 
    select="docinfo|*[local-name(.)=concat(local-name(current()),'info')]" />
  
  <xsl:choose>
    <xsl:when test="$info/titleabbrev[@role='texinfo-node']">
      <xsl:apply-templates select="($info/titleabbrev[@role='texinfo-node'])[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    
    <xsl:when test="@xreflabel">
      <xsl:apply-templates select="@xreflabel"
                           mode="texinfo-node-name" />
    </xsl:when>

    <xsl:when test="$explicit-node-names">
      <!-- We can either stop processing normal titles here, or
           do the processing and then warn the user.  We choose
           the former because:
             1) for texinode-impl-default.xsl it cannot check for
                collisions, so we want to be on the safe side and
                fallback to generate-id for these cases.
             2) it doesn't really matter what the content actually
                is, since the point of the warnings is for the user
                to fix the document, and ignoring normal titles here
                is easier code-wise.
      -->
    </xsl:when>
    
    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="article"
              mode="for-texinfo-node-name">
  
  <xsl:variable name="info" select="artheader|articleinfo" />
  
  <xsl:choose>
    <xsl:when test="$info/titleabbrev[@role='texinfo-node']">
      <xsl:apply-templates select="($info/titleabbrev[@role='texinfo-node'])[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    
    <xsl:when test="@xreflabel">
      <xsl:apply-templates select="@xreflabel"
                           mode="texinfo-node-name" />
    </xsl:when>

    <xsl:when test="$explicit-node-names">
    </xsl:when>

    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]"
                           mode="texinfo-node-name" />
    </xsl:when>

    <!-- Titles on articles are optional.  It may be specified in 
         the article "header" -->
    <xsl:when test="$info/title">
      <xsl:apply-templates select="$info/title[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="refentry"
              mode="for-texinfo-node-name">

  <xsl:variable name="info" select="docinfo|refentryinfo" />
  
  <xsl:choose>
    <xsl:when test="$info/titleabbrev[@role='texinfo-node']">
      <xsl:apply-templates select="($info/titleabbrev[@role='texinfo-node'])[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    
    <xsl:when test="@xreflabel">
      <xsl:apply-templates select="@xreflabel"
                           mode="texinfo-node-name" />
    </xsl:when>

    <xsl:when test="$explicit-node-names">
    </xsl:when>

    <xsl:when test="refmeta/refentrytitle">
      <xsl:apply-templates select="refmeta/refentrytitle[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    <xsl:when test="refnamediv/refname">
      <xsl:apply-templates select="refnamediv/refname[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="part" mode="for-texinfo-node-name">
  <xsl:variable name="info" select="docinfo" />
  
  <xsl:choose>
    <xsl:when test="$info/titleabbrev[@role='texinfo-node']">
      <xsl:apply-templates select="($info/titleabbrev[@role='texinfo-node'])[1]"
                           mode="texinfo-node-name" />
    </xsl:when>

    <xsl:when test="@xreflabel">
      <xsl:apply-templates select="@xreflabel"
                           mode="texinfo-node-name" />
    </xsl:when>
    
    <xsl:when test="$explicit-node-names">
    </xsl:when>

    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
  </xsl:choose>
</xsl:template>

<xsl:template match="varlistentry" mode="for-texinfo-node-name">
  <xsl:apply-templates select="term[1]"
                       mode="texinfo-node-name" />
</xsl:template>

<xsl:template match="index" mode="for-texinfo-node-name">
  <xsl:variable name="info" select="docinfo" />
  
  <xsl:choose>
    <xsl:when test="$info/title[@role='texinfo-node']">
      <xsl:apply-templates select="($info/title[@role='texinfo-node'])[1]"
                           mode="texinfo-node-name" />
    </xsl:when>

    <xsl:when test="@xreflabel">
      <xsl:apply-templates select="@xreflabel"
                           mode="texinfo-node-name" />
    </xsl:when>
    
    <xsl:when test="$explicit-node-names">
    </xsl:when>

    <xsl:when test="titleabbrev">
      <xsl:apply-templates select="titleabbrev[1]"
                           mode="texinfo-node-name" />
    </xsl:when>
    <xsl:when test="title">
      <xsl:apply-templates select="title[1]"
                           mode="texinfo-node-name" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key">
          <xsl:choose>
            <xsl:when test="@role = 'fn' or @role = 'f'">Function index</xsl:when>
            <xsl:when test="@role = 'vr' or @role = 'v'">Variables index</xsl:when>
            <xsl:when test="@role = 'ky' or @role = 'k'">Keystroke index</xsl:when>
            <xsl:when test="@role = 'pg' or @role = 'p'">Program index</xsl:when>
            <xsl:when test="@role = 'tp' or @role = 'd'">Data type index</xsl:when>
            <xsl:otherwise>Concept index</xsl:otherwise>
          </xsl:choose>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="book|/*" mode="is-texinfo-top-node" priority="5.0">
  <xsl:value-of select="1" />
</xsl:template>

<xsl:template match="*" mode="is-texinfo-top-node">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="*" mode="texinfo-node-name">
  <xsl:apply-templates mode="texinfo-node-name" />
</xsl:template>

<xsl:template match="text()" mode="texinfo-node-name">
  <xsl:value-of select="translate(string(.), '().,:', '[]_;;')" />
</xsl:template>

</xsl:stylesheet>

