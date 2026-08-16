<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:gt="http://docbook2x.sourceforge.net/xsl/gentext-title"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc gt"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: synop.xsl,v 1.15 2006/04/19 20:32:18 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Synopses</title>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="synopsis">
  <verbatim>
    <xsl:apply-templates mode="verbatim" />
  </verbatim>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="cmdsynopsis">
  <nh>
  <xsl:choose>
    <xsl:when test="local-name(*[1]) = 'command'">
      <TPauto align="l">
        <TPtag>
          <xsl:apply-templates select="*[1]" mode="cmdsynopsis" />
          <xsl:call-template name="cmdsynopsis-gentext-sepchar" />
        </TPtag>
        <TPitem><para>
          <!-- Hack -->
          <xsl:apply-templates select="*[position() = 2]" mode="cmdsynopsis">
            <xsl:with-param name="no-sepchar" select="true()" />
          </xsl:apply-templates>
          <xsl:apply-templates select="*[position() > 2]" mode="cmdsynopsis" />
        </para></TPitem>
      </TPauto>
    </xsl:when>
  
    <xsl:otherwise>
      <para align="l">
        <xsl:apply-templates mode="cmdsynopsis" />
      </para>
    </xsl:otherwise>
  </xsl:choose>
  </nh>
</xsl:template>

<xsl:template match="*" mode="cmdsynopsis">
  <xsl:value-of select="." />
</xsl:template>

<xsl:template match="sbr" mode="cmdsynopsis">
  <br />
</xsl:template>

<xsl:template match="synopfragmentref" mode="cmdsynopsis" priority="3.0">
  <xsl:variable name="target" select="key('id',@linkend)"/>
  <xsl:variable name="snum">
    <xsl:apply-templates select="$target" mode="synopfragment.number"/>
  </xsl:variable>
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$snum"/>
  <xsl:text>)</xsl:text>
  <i><xsl:apply-templates mode="cmdsynopsis" /></i>
</xsl:template>

<xsl:template match="synopfragment" mode="synopfragment.number">
  <xsl:number format="1"/>
</xsl:template>

<xsl:template match="synopfragment" mode="cmdsynopsis">
  <xsl:variable name="snum">
    <xsl:apply-templates select="." mode="synopfragment.number"/>
  </xsl:variable>
  <sp />
  <xsl:text>(</xsl:text>
  <xsl:value-of select="$snum"/>
  <xsl:text>) </xsl:text>
  <xsl:apply-templates mode="cmdsynopsis" />
</xsl:template>

<xsl:template match="command|option" mode="cmdsynopsis">
  <xsl:param name="no-sepchar" select="false()" />

  <xsl:if test="preceding-sibling::* and not($no-sepchar)">
    <xsl:call-template name="cmdsynopsis-gentext-sepchar" />
  </xsl:if>

  <b>
    <xsl:apply-templates mode="cmdsynopsis" />
  </b>
</xsl:template>

<xsl:template match="replaceable" mode="cmdsynopsis">
  <xsl:if test="preceding-sibling::*">
    <xsl:call-template name="cmdsynopsis-gentext-sepchar" />
  </xsl:if>

  <i>
    <xsl:apply-templates mode="cmdsynopsis" />
  </i>
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

  <xsl:apply-templates mode="cmdsynopsis" />
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

<xsl:template match="funcsynopsis">
  <nh>
  <xsl:choose>
    <xsl:when test="funcdef"><!-- Old content model -->
      <xsl:apply-templates select="funcsynopsisinfo" mode="funcsynopsis" />
      <xsl:call-template name="funcprototype" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:apply-templates mode="funcsynopsis" />
    </xsl:otherwise>
  </xsl:choose>
  </nh>
</xsl:template>

<xsl:template match="*" mode="funcsynopsis">
  <xsl:apply-templates select="." />
</xsl:template>

<xsl:template match="funcsynopsisinfo" mode="funcsynopsis">
  <verbatim><tt>
    <xsl:apply-templates mode="funcsynopsis" />
  </tt></verbatim>
  <sp length="1" />
</xsl:template>

<xsl:template match="funcprototype" name="funcprototype" mode="funcsynopsis">
  <TPauto align="l">
    <TPtag>
      <tt>
        <xsl:apply-templates select="modifier[count(following-sibling::funcdef) &gt; 0]"
                             mode="funcsynopsis" />
        <xsl:apply-templates select="funcdef" mode="funcsynopsis" />
      </tt>
      <xsl:text> </xsl:text>
    </TPtag>
  
    <TPitem><para><tt>
      <xsl:text>(</xsl:text>
      <xsl:apply-templates select="void|varargs|paramdef|varargs"
                           mode="funcsynopsis" />
      <xsl:text>)</xsl:text>
    
      <xsl:apply-templates select="modifier[count(following-sibling::funcdef) = 0]"
                           mode="funcsynopsis" />

      <xsl:text>;</xsl:text>
    </tt></para></TPitem>
  </TPauto>
</xsl:template>

<xsl:template match="modifier" mode="funcsynopsis">
  <xsl:apply-templates mode="funcsynopsis" />
</xsl:template>

<xsl:template match="funcdef" mode="funcsynopsis">
  <xsl:apply-templates mode="funcsynopsis" />
</xsl:template>

<xsl:template match="function" mode="funcsynopsis">
  <b><xsl:apply-templates mode="funcsynopsis" /></b>
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
  <i><xsl:apply-templates mode="funcsynopsis" /></i>
</xsl:template>

<xsl:template match="funcparams" mode="funcsynopsis">
  <xsl:text>(</xsl:text>
  <xsl:apply-templates mode="funcsynopsis" />
  <xsl:text>)</xsl:text>
</xsl:template>

<!-- ==================================================================== -->
<!-- FIXME: bring back classsynopsis stuff ! -->

</xsl:stylesheet>
