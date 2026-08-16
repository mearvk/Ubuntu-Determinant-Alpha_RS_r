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
     $Id: xref.xsl,v 1.23 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Handle cross references and links</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template name="anchor">
  <xsl:if test="@id">
    <anchor id="{@id}" />
  </xsl:if>
</xsl:template>

<xsl:template match="anchor">
  <xsl:call-template name="anchor" />
</xsl:template>


<!-- ==================================================================== -->

<xsl:template name="check-xref">
  <xsl:param name="target" />
  <xsl:param name="content" />
  <xsl:param name="bad-content" />

  <xsl:choose>
    <xsl:when test="not($target)">
      <!-- No such ID -->
      <xsl:call-template name="user-message">
        <xsl:with-param name="arg-1" select="@linkend" />
        <xsl:with-param name="key">reference to non-existent ID</xsl:with-param>
        <xsl:with-param name="content">reference to non-existent ID "<l:a1 />"</xsl:with-param>
      </xsl:call-template>

      <xsl:copy-of select="$bad-content" />
    </xsl:when>

    <xsl:otherwise>
      <xsl:copy-of select="$content" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>
      
<xsl:template match="xref">
  <xsl:variable name="target" select="key('id', @linkend)"/>

  <xsl:call-template name="check-xref">
    <xsl:with-param name="target" select="$target" />
    
    <xsl:with-param name="bad-content">
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'dangling-xref'" />
        <xsl:with-param name="content" select="string(@linkend)" />
      </xsl:call-template>
    </xsl:with-param>
    
    <xsl:with-param name="content">
      <ref>
        <xsl:attribute name="idref">
          <xsl:call-template name="print-id">
            <xsl:with-param name="node" select="$target" />
          </xsl:call-template>
        </xsl:attribute>

        <!-- FIXME Printed manual name -->

        <xsl:apply-templates select="$target" mode="xref-to" />
      </ref>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="link">
  <xsl:variable name="target" select="key('id', @linkend)"/>

  <xsl:call-template name="check-xref">
    <xsl:with-param name="target" select="$target" />
    <xsl:with-param name="bad-content">
      <xsl:call-template name="gentext-rendering">
        <xsl:with-param name="key" select="'dangling-xref'" />
        <xsl:with-param name="content" select="string(@linkend)" />
      </xsl:call-template>
    </xsl:with-param>

    <xsl:with-param name="content">
    <xsl:choose>
    <xsl:when test="$links-use-pxref">
      <xsl:apply-templates />
      <xsl:text> (</xsl:text>
    
      <pxref>
        <xsl:attribute name="idref">
          <xsl:call-template name="print-id">
            <xsl:with-param name="node" select="$target" />
          </xsl:call-template>
        </xsl:attribute>
      </pxref>
    
      <xsl:text>)</xsl:text>
    </xsl:when>

    <xsl:otherwise>
      <ref>
        <xsl:attribute name="idref">
          <xsl:call-template name="print-id">
            <xsl:with-param name="node" select="$target" />
          </xsl:call-template>
        </xsl:attribute>

        <!-- FIXME Printed manual name -->

        <xsl:apply-templates />
      </ref>
    </xsl:otherwise>
    </xsl:choose>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<xsl:template match="ulink">
  <uref>
    <xsl:attribute name="url"><xsl:value-of select="@url"/></xsl:attribute>
    <xsl:apply-templates/>
  </uref>
</xsl:template>

<xsl:template match="olink">
  <xsl:apply-templates/>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode mode="xref-to" xmlns="">
<refpurpose>Give cross-reference markup</refpurpose>
<refdescription>
<para>
Processing an element with this mode returns the markup/text that should
be used for referring to it in cross-references.</para>
<para>
Since Texinfo already handles cross references to nodes, this mode
does mostly nothing.  FIXME: However we need something for anchors...
</para>
</refdescription>
</doc:mode>

<xsl:template match="*" mode="xref-to">
  <xsl:choose>
    <xsl:when test="@xreflabel">
      <xsl:value-of select="@xreflabel" />
    </xsl:when>

    <xsl:otherwise>
      <!-- Otherwise same as the title.
           If the title doesn't exist, $title is empty,
           then we let Texinfo take care of it.
      -->
      <xsl:apply-templates select="." mode="for-title">
        <xsl:with-param name="suppress-error" select="true()" />
      </xsl:apply-templates>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>



<xsl:template match="co" mode="xref-to">
  <xsl:apply-templates select="." mode="co" />
</xsl:template>

          

</xsl:stylesheet>
