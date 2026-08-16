<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:gt="http://docbook2x.sourceforge.net/xsl/gentext"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                exclude-result-prefixes="doc gt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: synop.xsl,v 1.31 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Synopses</title>
</doc:reference>

<!-- ==================================================================== -->

<doc:mode mode="no-inline-markup" xmlns="">
<refpurpose>Plain text synopses</refpurpose>
<refdescription>
<para>
Info uses decorations to represent semantic markup, which
is undesirable in a verbatim synopsis.  So we use
<function>verbatim</function> to not use Texinfo's semantic markup. 
</para>
<para>
However, we lose the ability to make links :(
</para>
</refdescription>
</doc:mode>

<xsl:template match="synopsis">
  <example>
    <xsl:call-template name="anchor" />
    <xsl:apply-templates mode="no-inline-markup" />
  </example>
</xsl:template>

<xsl:template match="*" mode="no-inline-markup">
  <xsl:apply-templates mode="no-inline-markup" />
</xsl:template>

<xsl:template match="text()" mode="no-inline-markup">
  <xsl:value-of select="." />
</xsl:template>




<!-- ==================================================================== -->

<xsl:template match="cmdsynopsis">
  <quotation> 
    <xsl:call-template name="anchor" />
    <para><t>
        <xsl:apply-templates mode="cmdsynopsis" />
    </t></para>
  </quotation>
</xsl:template>

<xsl:template match="*" mode="cmdsynopsis">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="sbr" mode="cmdsynopsis">
  <sp lines="1" />
</xsl:template>

<xsl:template match="command" mode="cmdsynopsis">
  <xsl:if test="preceding-sibling::*">
    <xsl:call-template name="cmdsynopsis-gentext-sepchar" />
  </xsl:if>

  <xsl:apply-templates mode="cmdsynopsis" />
</xsl:template>

<xsl:template match="group|arg" mode="cmdsynopsis">
  <xsl:if test="preceding-sibling::* and not(parent::arg)">
    <xsl:call-template name="cmdsynopsis-gentext-sepchar" />
  </xsl:if>

  <xsl:call-template name="arg-gentext-choice-start" />
  <xsl:apply-templates mode="cmdsynopsis" />
  <xsl:call-template name="arg-gentext-choice-end" />
  <xsl:call-template name="arg-gentext-rep" />
</xsl:template>

<!-- Member of groups -->

<xsl:template match="group/*" mode="cmdsynopsis" priority="2.0">
  <xsl:if test="position()>1">
    <xsl:call-template name="arg-gentext-or-separator" />
  </xsl:if>
  <xsl:apply-templates mode="cmdsynopsis" />
</xsl:template>

<xsl:template match="group/group" mode="cmdsynopsis" priority="2.5">
  <xsl:if test="position()>1">
    <xsl:call-template name="arg-gentext-or-separator" />
  </xsl:if>

  <xsl:call-template name="arg-gentext-choice-start" />
  <xsl:apply-templates mode="cmdsynopsis" />
  <xsl:call-template name="arg-gentext-choice-end" />
  <xsl:call-template name="arg-gentext-rep" />
</xsl:template>

<xsl:template match="group/option" mode="cmdsynopsis" priority="2.5">
  <xsl:if test="position()>1">
    <xsl:choose>
      <xsl:when test="preceding-sibling::*[local-name(.) != 'option']
                      or following-sibling::*[local-name(.) != 'option']">
        <xsl:call-template name="arg-gentext-or-separator" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:call-template name="arg-gentext-or-separator-nospace" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:if>

  <xsl:apply-templates mode="cmdsynopsis.mode" />
  <xsl:call-template name="arg-gentext-rep" />
</xsl:template>

<xsl:template match="group/arg" mode="cmdsynopsis" priority="2.5">
  <xsl:if test="position()>1">
    <xsl:call-template name="arg-gentext-or-separator" />
  </xsl:if>

  <xsl:apply-templates mode="cmdsynopsis" />
  <xsl:call-template name="arg-gentext-rep" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="synopfragment|synopfragmentref" mode="cmdsynopsis">
  <xsl:call-template name="gentext-label">
    <xsl:with-param name="content">
      <xsl:for-each select="key('id', @linkend)">
        <xsl:number format="1" />
      </xsl:for-each>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="funcsynopsis">
  <quotation>
    <xsl:call-template name="anchor" />
    <xsl:choose>
      <xsl:when test="funcdef"><!-- Old content model -->
        <xsl:apply-templates select="funcsynopsisinfo" mode="funcsynopsis" />
        <xsl:call-template name="funcprototype" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="funcsynopsis" />
      </xsl:otherwise>
    </xsl:choose>
  </quotation>
</xsl:template>

<xsl:template match="*" mode="funcsynopsis">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="funcsynopsisinfo" mode="funcsynopsis">
  <!-- format rather than example is used to avoid indenting the
       funcsynopsisinfo block -->
  <format><t>
    <xsl:apply-templates mode="funcsynopsis" />
  </t></format>
</xsl:template>

<xsl:template match="funcprototype" name="funcprototype" mode="funcsynopsis">
  <para>
    <t>  
      <xsl:apply-templates select="modifier[count(following-sibling::funcdef) &gt; 0]"
                           mode="funcsynopsis" />
      <xsl:apply-templates select="funcdef" mode="funcsynopsis" />

      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="void|varargs|paramdef|varargs"
                           mode="funcsynopsis" />
      <xsl:text>)</xsl:text>
    
      <xsl:apply-templates select="modifier[count(following-sibling::funcdef) = 0]"
                           mode="funcsynopsis" />

      <xsl:text>;</xsl:text>
    </t>
  </para>
</xsl:template>

<xsl:template match="modifier" mode="funcsynopsis">
  <xsl:apply-templates mode="funcsynopsis" />
</xsl:template>

<xsl:template match="funcdef" mode="funcsynopsis">
  <xsl:apply-templates mode="funcsynopsis" />
</xsl:template>

<xsl:template match="function" mode="funcsynopsis">
  <xsl:choose>
    <xsl:when test="$funcsynopsis-decoration">
      <b><xsl:apply-templates mode="funcsynopsis" /></b>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="funcsynopsis" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="void" mode="funcsynopsis">
  <xsl:text>void</xsl:text>
</xsl:template>

<xsl:template match="varargs" mode="funcsynopsis">
  <xsl:if test="preceding-sibling::paramdef">
    <xsl:text>, </xsl:text>
  </xsl:if>

  <xsl:text>...</xsl:text>
</xsl:template>

<xsl:template match="paramdef" mode="funcsynopsis">
  <xsl:if test="preceding-sibling::paramdef">
    <xsl:text>, </xsl:text>
  </xsl:if>
  
  <xsl:apply-templates mode="funcsynopsis" />
</xsl:template>

<xsl:template match="paramdef/parameter" mode="funcsynopsis">
  <xsl:choose>
    <xsl:when test="$funcsynopsis-decoration">
      <i><xsl:apply-templates mode="funcsynopsis" /></i>
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="funcsynopsis" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="funcparams" mode="funcsynopsis">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates mode="funcsynopsis" />
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- ==================================================================== -->
<!-- FIXME: bring back classsynopsis stuff ! -->

</xsl:stylesheet>
