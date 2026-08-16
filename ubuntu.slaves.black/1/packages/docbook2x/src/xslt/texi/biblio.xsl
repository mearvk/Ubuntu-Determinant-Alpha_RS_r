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
     $Id: biblio.xsl,v 1.19 2006/04/14 03:24:30 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->
<doc:reference xmlns="">
<title>Bibliographies</title>
<partintro>
<note>
<para>
Bibliographies are probably broken right now.
They may still work for you, but the entire system really needs
an overhaul.
</para>
</note>
</partintro>
</doc:reference>

<!-- ==================================================================== -->

<xsl:template match="bibliography">
  <xsl:call-template name="section" />
</xsl:template>

<xsl:template name="biblio-item-separator">
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'biblio-item-separator'" />
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="bibliodiv">
  <xsl:call-template name="section" />
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="biblioentry">
  <xsl:call-template name="anchor" />
  <para>
    <xsl:apply-templates mode="bibliography" />
  </para>
</xsl:template>

<xsl:template match="bibliomixed">
  <xsl:call-template name="anchor" />
  <para>
    <xsl:apply-templates mode="bibliomixed" />
  </para>
</xsl:template>


<!-- ==================================================================== -->

<xsl:template match="*" mode="bibliography">
  <xsl:apply-templates select="." /><!-- try the default mode -->
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="abbrev" mode="bibliography">
    <xsl:text>[</xsl:text>
    <xsl:apply-templates mode="bibliography" />
    <xsl:text>] </xsl:text>
</xsl:template>

<xsl:template match="abstract" mode="bibliography">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="address" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="affiliation" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="shortaffil" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="jobtitle" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="artheader" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="artpagenums" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="author" mode="bibliography">
  <xsl:call-template name="person.name" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="authorblurb" mode="bibliography">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="authorgroup" mode="bibliography">
  <xsl:call-template name="person.name.list" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="authorinitials" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="bibliomisc" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="bibliomset" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<!-- ================================================== -->

<xsl:template match="biblioset" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
</xsl:template>

<xsl:template match="biblioset/title|biblioset/citetitle" 
              mode="bibliography">
  <xsl:variable name="relation" select="../@relation" />
  <xsl:choose>
    <xsl:when test="$relation='article'">
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'citetitle-quote-start'" />
      </xsl:call-template>
      <xsl:apply-templates />
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="'citetitle-quote-end'" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <i><xsl:apply-templates /></i>
    </xsl:otherwise>
  </xsl:choose>
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<!-- ================================================== -->

<xsl:template match="bookbiblio" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="citetitle" mode="bibliography">
  <i><xsl:apply-templates mode="bibliography" /></i>
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="collab" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="collabname" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="confgroup" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="confdates" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="conftitle" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="confnum" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="confsponsor" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="contractnum" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="contractsponsor" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="contrib" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<!-- ================================================== -->

<xsl:template match="copyright" mode="bibliography">
  <xsl:call-template name="gentext-title">
    <xsl:with-param name="content">
      <xsl:apply-templates select="year" mode="bibliography" />
    </xsl:with-param>

    <xsl:with-param name="content2">
      <xsl:apply-templates select="holder" mode="bibliography" />
    </xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="year" mode="bibliography">
  <xsl:apply-templates />
  <xsl:call-template name="gentext-text">
    <xsl:with-param name="key" select="'year-separator'" />
  </xsl:call-template>
</xsl:template>

<xsl:template match="year[position()=last()]" mode="bibliography">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="holder" mode="bibliography">
  <xsl:apply-templates />
</xsl:template>

<!-- ================================================== -->

<xsl:template match="corpauthor" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="corpname" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="date" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="edition" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="editor" mode="bibliography">
  <xsl:call-template name="person.name" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="personname" mode="bibliography">
  <xsl:apply-templates />
</xsl:template>

<xsl:template match="firstname" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="honorific" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="indexterm" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="invpartnumber" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="isbn" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="issn" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="issuenum" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="lineage" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="orgname" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="orgdiv" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="othercredit" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="othername" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="pagenums" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="printhistory" mode="bibliography">
  <!-- suppressed -->
</xsl:template>

<xsl:template match="productname" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="productnumber" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="pubdate" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="publisher" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
</xsl:template>

<xsl:template match="publishername" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="pubsnumber" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="releaseinfo" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="revhistory" mode="bibliography">
  <!-- Suppress -->
</xsl:template>

<xsl:template match="seriesinfo" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
</xsl:template>

<xsl:template match="seriesvolnums" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="subtitle" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="surname" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="title" mode="bibliography">
  <i><xsl:apply-templates mode="bibliography" /></i>
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="titleabbrev" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<xsl:template match="volumenum" mode="bibliography">
  <xsl:apply-templates mode="bibliography" />
  <xsl:call-template name="biblio-item-separator" />
</xsl:template>

<!-- ==================================================================== -->
<!-- Bibliomixed content.  Basically, the contents of the 
     bibliomixed are treated just as normal text.                         -->
<!-- ==================================================================== -->

<xsl:template match="*" mode="bibliomixed">
  <xsl:apply-templates select="." /><!-- try the default mode -->
</xsl:template>

<xsl:template match="abbrev" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="abstract" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="address" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="affiliation" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="artpagenums" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="author" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="authorblurb" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="authorgroup" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="authorinitials" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="bibliomisc" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<!-- ================================================== -->

<xsl:template match="bibliomset" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="bibliomset/title|bibliomset/citetitle" 
              mode="bibliomixed">
  <xsl:variable name="relation" select="../@relation" />
  <xsl:choose>
    <xsl:when test="$relation='article'">
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="citetitle-start-quote" />
      </xsl:call-template>
      <xsl:apply-templates />
      <xsl:call-template name="gentext-text">
        <xsl:with-param name="key" select="citetitle-end-quote" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <i><xsl:apply-templates /></i>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- ================================================== -->

<xsl:template match="biblioset" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="citetitle" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="collab" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="confgroup" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="contractnum" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="contractsponsor" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="contrib" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="copyright" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="corpauthor" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="corpname" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="date" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="edition" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="editor" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="firstname" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="honorific" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="indexterm" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="invpartnumber" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="isbn" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="issn" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="issuenum" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="lineage" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="orgname" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="othercredit" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="othername" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="pagenums" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="printhistory" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="productname" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="productnumber" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="pubdate" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="publisher" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="publishername" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="pubsnumber" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="releaseinfo" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="revhistory" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="seriesvolnums" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="subtitle" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="surname" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="title" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="titleabbrev" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<xsl:template match="volumenum" mode="bibliomixed">
  <xsl:apply-templates mode="bibliomixed" />
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>
