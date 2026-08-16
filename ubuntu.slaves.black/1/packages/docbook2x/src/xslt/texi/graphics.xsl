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
     $Id: graphics.xsl,v 1.17 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Graphics and media objects</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="screenshot">
  <xsl:call-template name="anchor" />
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="screeninfo">
</xsl:template>


<!-- ==================================================================== -->
<!-- Templates common to both *graphic and *object elements -->

<xsl:template name="imagedata">

  <xsl:variable name="filename">
    <xsl:choose>
      <xsl:when test="@entityref">
        <xsl:value-of select="unparsed-entity-uri(@entityref)" />
      </xsl:when>

      <xsl:when test="@fileref">
        <xsl:value-of select="@fileref" />
      </xsl:when>

      <xsl:otherwise>
        <xsl:call-template name="user-message">
          <xsl:with-param name="key">Image data must be specified with entityref or fileref attribute</xsl:with-param>
        </xsl:call-template>
        <xsl:text>broken-graphic</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- Texinfo's image width and height are device-independent values,
       so we cannot use the width and depth values from the DocBook 
       source. -->

  <image filename="{$filename}" />
</xsl:template>


<!-- ==================================================================== -->
<!-- *graphic -->

<xsl:template match="graphic">
  <para>
    <xsl:call-template name="anchor" />
    <xsl:call-template name="imagedata" />
  </para>
</xsl:template>

<xsl:template match="inlinegraphic">
  <xsl:call-template name="imagedata" />
</xsl:template>


<!-- ==================================================================== -->
<!-- DocBook 3.1 MediaObjects -->

<xsl:template name="select-mediaobject">
  <xsl:choose>
    <xsl:when test="$prefer-textobjects = '2' and textobject">
      <xsl:apply-templates select="imageobject[1]" />
      <xsl:apply-templates select="textobject[1]" />
    </xsl:when>
    
    <xsl:when test="$prefer-textobjects and textobject">
      <xsl:apply-templates select="textobject[1]" />
    </xsl:when>
    
    <xsl:otherwise>
      <xsl:apply-templates select="(textobject|imageobject)[1]" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:template match="mediaobject">
  <para>
    <xsl:call-template name="anchor" />
    <xsl:call-template name="select-mediaobject" />
    <xsl:apply-templates select="make-caption"/>
  </para>
</xsl:template>

<xsl:template match="inlinemediaobject">
  <xsl:call-template name="select-mediaobject" />
</xsl:template>

<xsl:template match="objectinfo">
</xsl:template>

<xsl:template match="imageobject">
  <xsl:for-each select="imagedata">
    <xsl:call-template name="imagedata" />
  </xsl:for-each>
</xsl:template>

<xsl:template match="textobject">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="caption">
  <xsl:call-template name="make-caption">
    <xsl:with-param name="content">
      <xsl:apply-templates />
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
