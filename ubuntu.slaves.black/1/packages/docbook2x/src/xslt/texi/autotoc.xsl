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
     $Id: autotoc.xsl,v 1.24 2004/08/22 22:46:06 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->
<doc:reference xmlns="">
<title>Texinfo menus and directory entries</title>
<partintro>
<para>
Generate Texinfo menus for each node.  Also optionally generate
directory entries used by <command>install-info</command>.  The user
generally does not modify these templates.
</para>

<para>
Menus are created by the first child sectioning element, so that the
<markup>@menu</markup> comes just after the text content of the parent
sectioning element, where Texinfo expects them to be.  This approach may
not be the most elegant, but it works, and its operation is hidden by
<function role="xsl-template">make-texinfo-node</function>.
</para>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<doc:mode mode="texinfo-menu" xmlns="">
<refpurpose>Make Texinfo menus</refpurpose>
<refdescription>
<para>
Any DocBook element that generates a Texinfo node
can be processed with this mode to generate
a menu for it.
</para>
<para>
If the element that is processed happens to be the Top node,
the <markup>@detailmenu</markup> is generated also.
</para>
</refdescription>
</doc:mode>

<xsl:variable name="make-detailed-menus" select="true()" />

<xsl:template match="*" mode="texinfo-menu">
  <menu>
    <xsl:apply-templates mode="texinfo-menu-entry" />
  </menu>
</xsl:template>

<xsl:template match="book|/*" mode="texinfo-menu">
  <menu>
    <xsl:apply-templates mode="texinfo-menu-entry" />

    <xsl:if test="$make-detailed-menus">
      <detailmenu>
        <menuline>
          <xsl:call-template name="gentext-text">
            <xsl:with-param name="key">--- The Detailed Node Listing ---</xsl:with-param>
          </xsl:call-template>
        </menuline>
        <menuline></menuline>
        <xsl:apply-templates mode="texinfo-detail-menu-entry" />
      </detailmenu>
    </xsl:if>
  </menu>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="book/*|/*/*|book/part/*" 
              mode="texinfo-detail-menu-entry">
  <xsl:variable name="isnode">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>

  <xsl:if test="$isnode = '1'">
    <xsl:variable name="detailmenuentries">
      <xsl:apply-templates mode="texinfo-detail-menu-entry" />
    </xsl:variable>

    <xsl:if test="$detailmenuentries != ''">
      <menuline>
        <xsl:apply-templates select="." mode="for-menu-title" />
      </menuline>
      <menuline />

      <xsl:copy-of select="$detailmenuentries" />

      <menuline />
    </xsl:if>

  </xsl:if>
</xsl:template>

<xsl:template match="book/part" mode="texinfo-detail-menu-entry">
  <xsl:apply-templates mode="texinfo-detail-menu-entry" />
</xsl:template>

<xsl:template match="*" mode="texinfo-detail-menu-entry">
  <xsl:apply-templates select="." mode="texinfo-menu-entry" />
</xsl:template>
    

<!-- ==================================================================== -->

<xsl:template match="part" mode="texinfo-menu-entry">
  <xsl:call-template name="make-texinfo-menu-entry" />
  <!-- List out all of part's children also -->
  <xsl:apply-templates mode="texinfo-menu-entry" />
</xsl:template>

<xsl:template name="make-texinfo-menu-entry" 
              match="*" 
              mode="texinfo-menu-entry">
  <xsl:variable name="isnode">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>

  <xsl:if test="$isnode = '1'">
    <menuentry>
      <xsl:attribute name="idref">
        <xsl:call-template name="print-id" />
      </xsl:attribute>
        
      <menuentrytitle>
        <xsl:apply-templates select="." mode="for-menu-title" />
      </menuentrytitle>

      <menuentrydescrip>
        <xsl:apply-templates select="." mode="for-menu-description" />
      </menuentrydescrip>
    </menuentry>
  </xsl:if>
</xsl:template>

    


<!-- ==================================================================== -->

<doc:template name="make-texinfo-directory" xmlns="">
<refpurpose>Make a Texinfo directory entry</refpurpose>
<refdescription>
<para>
Output commands so that install-info can automatically add a directory entry
when installing the document.
</para>
</refdescription>
</doc:template>

<xsl:template name="make-texinfo-directory">
  <directory>

    <xsl:variable name="category">
      <xsl:call-template name="get-texinfo-directory-category" />
    </xsl:variable>
    <xsl:if test="$category != ''">
      <xsl:attribute name="category">
        <xsl:copy-of select="$category" />
      </xsl:attribute>
    </xsl:if>
  
    <menuentry>
      <xsl:attribute name="file">
        <xsl:call-template name="get-texinfo-file-name" />
      </xsl:attribute>

      <menuentrytitle>
        <xsl:apply-templates select="." mode="for-menu-title" />
      </menuentrytitle>

      <menuentrydescrip>
        <xsl:variable name="description">
          <xsl:call-template name="get-texinfo-directory-description" />
        </xsl:variable>

        <xsl:choose>
          <xsl:when test="$description != ''">
            <xsl:copy-of select="$description" />
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="user-message">
              <xsl:with-param name="key">no description for directory entry</xsl:with-param>
            </xsl:call-template>

            <xsl:call-template name="gentext-text">
              <xsl:with-param name="key">[missing text]</xsl:with-param>
            </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
      </menuentrydescrip>
    </menuentry>
  </directory>
</xsl:template>

<xsl:template match="node()" mode="for-menu-title">
  <xsl:apply-templates select="." mode="for-title" />
</xsl:template>

</xsl:stylesheet>

