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
     $Id: table.xsl,v 1.17 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Table support</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="tgroup">
  <xsl:call-template name="anchor" />
  <multitable cols="{@cols}">
    <xsl:apply-templates select="colspec" />
    <tbody>
      <xsl:apply-templates select="thead" />
      <xsl:apply-templates select="tbody" />
      <xsl:apply-templates select="tfoot" />
    </tbody>
  </multitable>
</xsl:template>

<xsl:template match="colspec">
  <colspec>
    <xsl:attribute name="colwidth">
      <xsl:call-template name="get-proportional-colwidth" />
    </xsl:attribute>

    <xsl:attribute name="colnum">
      <xsl:value-of select="@colnum" />
    </xsl:attribute>
  </colspec>
</xsl:template>
    
<xsl:template match="spanspec">
  <spanspec spanname="{@spanname}"
            namest="{@namest}"
            nameend="{@nameend}" />
</xsl:template>

<xsl:template match="thead|tfoot|tbody">
  <xsl:apply-templates />
</xsl:template>

<!-- FIXME: Complain loudly -->
<xsl:template match="thead/colspec">
</xsl:template>

<xsl:template match="tfoot/colspec">
</xsl:template>


<xsl:template match="row">
  <row>
    <xsl:apply-templates />
  </row>
</xsl:template>

<xsl:template match="entry">
  <entry>
    <xsl:if test="@colname">
      <xsl:attribute name="colname">
        <xsl:value-of select="@colname" />
      </xsl:attribute>
    </xsl:if>
    
     <xsl:if test="@spanname">
      <xsl:attribute name="spanname">
        <xsl:value-of select="@spanname" />
      </xsl:attribute>
    </xsl:if>
    
    <xsl:if test="@namest">
      <xsl:attribute name="namest">
        <xsl:value-of select="@namest" />
      </xsl:attribute>
    </xsl:if>

    <xsl:if test="@nameend">
      <xsl:attribute name="nameend">
        <xsl:value-of select="@nameend" />
      </xsl:attribute>
    </xsl:if>

    <xsl:apply-templates mode="coerce-into-inline" />
  </entry>
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="get-proportional-colwidth" xmlns="">
  <refpurpose>
    Get the proportional width as specified in the given <sgmltag class="element">colspec</sgmltag>
  </refpurpose>

  <refdescription>
    <para>
      In CALS tables, the <sgmltag class="element">colspec</sgmltag> has
      the attribute <sgmltag class="attribute">colwidth</sgmltag>
      which can specify either absolute column widths, relative column widths,
      or a mixture of both measures.  Texinfo only supports relative column widths.
      This template coerces all absolute column widths into relative ones, 
      as follows:

      <variablelist>
        <varlistentry>
          <term>No width is specified</term>
          <listitem>
            <para>Then the column is assumed to have a relative column width of one.</para>
          </listitem>
        </varlistentry>
        
        <varlistentry>
          <term>Absolute widths</term>
          <listitem>
            <para>These are simply translated to a relative column width of one.</para>
          </listitem>
        </varlistentry>

        <varlistentry>
          <term>Mixture</term>
          <listitem>
            <para>These are of the form <literal><replaceable>P</replaceable>*+<replaceable>M</replaceable></literal>, where <replaceable>P</replaceable> is the relative column width, and <replaceable>M</replaceable> is an absolute column width.
The sign may also be minus instead of plus, with the obvious meaning.
This template drops the <replaceable>M</replaceable> part and its sign.
            </para>
          </listitem>
        </varlistentry>
      </variablelist>
    </para>
  </refdescription>

  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>colspec</parameter></term>
        <listitem><para>
          A node-set that is the <sgmltag class="element">colspec</sgmltag>
          element to determine widths for.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>
          
<xsl:template name="get-proportional-colwidth">
  <xsl:param name="colspec" select="." />
  <xsl:variable name="colwidth" select="$colspec/@colwidth" />

  <xsl:choose>
    <xsl:when test="$colwidth = ''">
      <xsl:value-of select="1" />
    </xsl:when>

    <xsl:when test="not(contains($colwidth,'*'))">
      <xsl:call-template name="user-message">
        <xsl:with-param name="node" select="$colspec" />
          <xsl:with-param name="key">absolute table column widths not supported</xsl:with-param>
      </xsl:call-template>
      <xsl:value-of select="1" />
    </xsl:when>

    <xsl:when test="$colwidth = '*'">
      <xsl:value-of select="1" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:if test="contains($colwidth,'+') or contains($colwidth,'-')">
        <xsl:call-template name="user-message">
          <xsl:with-param name="node" select="$colspec" />
          <xsl:with-param name="key">absolute table column widths not supported</xsl:with-param>
        </xsl:call-template>
      </xsl:if>
      <xsl:value-of select="substring-before($colwidth,'*')" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
