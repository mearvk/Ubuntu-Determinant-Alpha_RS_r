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
     $Id: lists.xsl,v 1.30 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
  
     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>All sorts of lists</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="itemizedlist">
  <xsl:call-template name="formal-object-title" />
  <itemize>
    <xsl:call-template name="anchor" />

    <!-- FIXME Implement mark database -->
    <xsl:attribute name="markchar">
      <xsl:text>&#x2022;</xsl:text>
    </xsl:attribute>
      
    <xsl:apply-templates select="listitem"/>
  </itemize>
</xsl:template>

<xsl:template match="orderedlist">
  <xsl:variable name="start">
    <xsl:choose>
      <xsl:when test="@continuation='continues'">
        <xsl:call-template name="orderedlist.starting.number" />
      </xsl:when>
      <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:call-template name="formal-object-title" />

  <enumerate>
    <xsl:call-template name="anchor" />
 
    <xsl:if test="$start != '1'">
      <xsl:attribute name="start">
        <xsl:value-of select="$start"/>
      </xsl:attribute>
    </xsl:if>
    <xsl:apply-templates select="listitem"/>
  </enumerate>
    
</xsl:template>

<xsl:template match="variablelist">
  <xsl:call-template name="formal-object-title" />
  <varlist>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates />
  </varlist>
</xsl:template>

<xsl:template match="listitem">
  <listitem>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </listitem>
</xsl:template>

<xsl:template match="varlistentry">
  <varlistentry>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates />
  </varlistentry>
</xsl:template>

<xsl:template match="varlistentry/term">
  <term><xsl:apply-templates /></term>
</xsl:template>

<xsl:template match="varlistentry/listitem">
  <listitem><xsl:apply-templates/></listitem>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="simplelist[@type='horiz']">
  <xsl:variable name="columns">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="anchor" />
  <multitable cols="{$columns}">
    <tbody>
      <xsl:call-template name="simplelist-horiz">
        <xsl:with-param name="cols" select="$columns" />
      </xsl:call-template>
    </tbody>
  </multitable>
</xsl:template>

<!-- type='vert' or not specified, which defaults to 'vert' -->
<xsl:template match="simplelist">
  <xsl:variable name="columns">
    <xsl:choose>
      <xsl:when test="@columns">
        <xsl:value-of select="@columns"/>
      </xsl:when>
    <xsl:otherwise>1</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:call-template name="anchor" />
  <multitable cols="{$columns}">
    <!-- with simplelists we can correctly assume all items have the
         same width -->
    <tbody>
      <xsl:call-template name="simplelist-vert">
        <xsl:with-param name="cols" select="$columns" />
      </xsl:call-template>
    </tbody>
  </multitable>
</xsl:template>

<xsl:template match="simplelist[@type='inline']">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template name="simplelist-horiz">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./member"/>

  <xsl:if test="$cell &lt;= count($members)">
    <row>
      <xsl:call-template name="simplelist-horiz-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
    </row>
    
    <xsl:call-template name="simplelist-horiz">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell + $cols"/>
      <xsl:with-param name="members" select="$members"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="simplelist-horiz-row">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./member"/>
  <xsl:param name="curcol">1</xsl:param>

  <xsl:if test="$curcol &lt;= $cols">
    <entry>
      <xsl:if test="$members[position()=$cell]">
        <xsl:apply-templates select="$members[position()=$cell]"/>
      </xsl:if>
    
      <xsl:call-template name="simplelist-horiz-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="cell" select="$cell+1"/>
        <xsl:with-param name="members" select="$members"/>
        <xsl:with-param name="curcol" select="$curcol+1"/>
      </xsl:call-template>
    </entry>
  </xsl:if>
</xsl:template>

<xsl:template name="simplelist-vert">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./member"/>
  <xsl:param name="rows"
             select="floor((count($members)+$cols - 1) div $cols)"/>

  <xsl:if test="$cell &lt;= $rows">
    <row>
      <xsl:call-template name="simplelist-vert-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="cell" select="$cell"/>
        <xsl:with-param name="members" select="$members"/>
      </xsl:call-template>
    </row>
   
    <xsl:call-template name="simplelist-vert">
      <xsl:with-param name="cols" select="$cols"/>
      <xsl:with-param name="cell" select="$cell+1"/>
      <xsl:with-param name="members" select="$members"/>
      <xsl:with-param name="rows" select="$rows"/>
    </xsl:call-template>
  </xsl:if>
</xsl:template>

<xsl:template name="simplelist-vert-row">
  <xsl:param name="cols">1</xsl:param>
  <xsl:param name="rows">1</xsl:param>
  <xsl:param name="cell">1</xsl:param>
  <xsl:param name="members" select="./member"/>
  <xsl:param name="curcol">1</xsl:param>

  <xsl:if test="$curcol &lt;= $cols">
    <entry>
      <xsl:if test="$members[position()=$cell]">
        <xsl:apply-templates select="$members[position()=$cell]"/>
      </xsl:if>
    
      <xsl:call-template name="simplelist-vert-row">
        <xsl:with-param name="cols" select="$cols"/>
        <xsl:with-param name="rows" select="$rows"/>
        <xsl:with-param name="cell" select="$cell+$rows"/>
        <xsl:with-param name="members" select="$members"/>
        <xsl:with-param name="curcol" select="$curcol+1"/>
      </xsl:call-template>
    </entry>
  </xsl:if>
</xsl:template>

<xsl:template match="member">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'inline-list-separator'" />
  </xsl:call-template>
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="simplelist[@type='inline']/member[1]" priority="1">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="procedure">
  <xsl:call-template name="formal-object-title" />
  
  <enumerate>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </enumerate>
</xsl:template>

<xsl:template match="substeps">
  <enumerate>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates/>
  </enumerate>
</xsl:template>

<xsl:template match="step">
  <listitem>
    <xsl:call-template name="anchor" />
    <xsl:call-template name="formal-object-title" />
    <xsl:apply-templates />
  </listitem>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="segmentedlist">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="segtitle">
</xsl:template>

<xsl:template match="segtitle" mode="segtitle-in-seg">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="seglistitem">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="seg">
  <xsl:variable name="segnum" select="position()"/>
  <xsl:variable name="seglist" select="ancestor::segmentedlist"/>
  <xsl:variable name="segtitles" select="$seglist/segtitle"/>

  <!--
     Note: segtitle is only going to be the right thing in a well formed
     SegmentedList.  If there are too many Segs or too few SegTitles,
     you'll get something odd...maybe an error
  -->

  <para>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates select="$segtitles[$segnum=position()]"
                           mode="segtitle-in-seg"/>

    <xsl:call-template name="gentext-text">
      <xsl:with-param name="key" select="'seg-separator'" />
    </xsl:call-template>
    
    <xsl:apply-templates/>
  </para>
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

