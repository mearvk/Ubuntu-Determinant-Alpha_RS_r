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
     $Id: index.xsl,v 1.17 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Texinfo Indices</title>
</doc:reference>

<!-- ==================================================================== -->

<!-- FIXME: also do setindex -->
<xsl:template match="index">
  <!-- Norm says: 
       some implementations use completely empty index tags to indicate
       where an automatically generated index should be inserted. so
       if the index is completely empty, skip it.

       I say:
       Only if the index does not contain indexdiv or indexentry
       then the above should occur.  It's perfectly reasonable that
       someone would want to write introductory matter before
       the generated index is inserted.  However, where we can find
       out what type of index to generate is a bit ill-defined.
       For now, use the role attribute on the index/setindex itself.
  -->

  <xsl:call-template name="section">
    <xsl:with-param name="level">
      <xsl:call-template name="get-texinfo-section-level">
        <xsl:with-param name="heading-class" select="'unnumbered'" />
      </xsl:call-template>
    </xsl:with-param>
    <xsl:with-param name="content">
      <xsl:if test="count(./indexdiv | ./indexentry)=0">
        <printindex>
          <xsl:attribute name="class">
            <xsl:choose>
              <xsl:when test="@role">
                <xsl:value-of select="@role" />
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$index-category" />
              </xsl:otherwise>
            </xsl:choose>
          </xsl:attribute>
        </printindex>
      </xsl:if>
    </xsl:with-param>
  </xsl:call-template>
      
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="indexdiv">
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="indexterm">
  <indexterm>
    <xsl:attribute name="class">
      <xsl:choose>
        <xsl:when test="@role">
          <!-- FIXME (perhaps at texi_xml level):
               define indices with @defindex if it is not one of the
               predefined c,f,v,k,p,t -->
          <xsl:value-of select="@role" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$index-category" />
        </xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:apply-templates />
  </indexterm>
</xsl:template>

<xsl:template match="primary">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="secondary|tertiary">
  <xsl:call-template name="gentext-title" />
</xsl:template>

<xsl:template match="see|seealso">
<!-- FIXME -->
</xsl:template>

<xsl:template match="indexentry"></xsl:template>
<xsl:template match="primaryie|secondaryie|tertiaryie|seeie|seealsoie">
</xsl:template>

</xsl:stylesheet>
