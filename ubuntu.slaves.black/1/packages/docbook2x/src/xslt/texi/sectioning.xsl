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
     $Id: sectioning.xsl,v 1.12 2004/08/22 22:46:07 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to Texinfo.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<doc:reference xmlns="">
<title>Mapping of DocBook sections into Texinfo sections</title>
</doc:reference>

<!-- ==================================================================== -->

<doc:template name="get-texinfo-section-level" xmlns="">
  <refpurpose>
    Give Texinfo structuring command for given section level
  </refpurpose>
  
  <refdescription>
    <para>
      This template returns the name of the Texinfo command that is mapped to
      the given DocBook element.
    </para>

    <para>
      This implementation internally uses numbers that reflect the DocBook
      hierarchy, like Norm's <function>section.level</function> template.
      However, <function>section.level</function> only maps the DocBook 
      sectioning elements (<sgmltag class="element">sect<replaceable>n</replaceable></sgmltag>
      and <sgmltag class="element">section</sgmltag>).
    </para>

    <para>
      This simplistic mapping of numbers to Texinfo commands sometimes yield
      results that do not make a lot of sense; e.g. if the document element is
      <sgmltag class="element">section</sgmltag>, then the first section is
      mapped to <markup>@top</markup>, but the next nested section would be a
      Texinfo <markup>chapter</markup>.  I have thought about letting each
      template specify their own structuring element, but from my testing,
      jumping around the hierarchy breaks at least the TeX portion of Texinfo.
      Besides, this neccessitated writing a <sgmltag>xsl:choose</sgmltag>s
      with non-trivial cases in many templates.
    </para>
    
    <para>
      The only thing I can say is that if you use 'weird' document elements,
      you can't reasonably transform to Texinfo (whose top level is
      semantically similar to <sgmltag>book</sgmltag>).  
      <command>docbook2texixml</command> takes the same approach.
    </para>

    <para>
      I also have a suspicion that calling this template will be slow, but 
      there's nothing we can do about it :-(
    </para>
  </refdescription>

  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>node</parameter></term>
        <listitem><para>
          The node to get the Texinfo structuring command mapping for.
          Default is the context node.
        </para></listitem>
      </varlistentry>

      <varlistentry>
        <term><parameter>heading-class</parameter></term>
        <listitem><para>
          The class of heading commands to use:
          <simplelist type="inline">
            <member><literal>chapter</literal></member>
            <member><literal>unnumbered</literal></member>
            <member><literal>appendix</literal></member>
            <member><literal>chapheading</literal></member>
          </simplelist>
    
          See the chart in the Texinfo manual for the meanings of each class.
          The default is <literal>chapter</literal>
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="get-texinfo-section-level">
  <xsl:param name="node" select="." />
  <xsl:param name="heading-class" select="'chapter'" />

  <xsl:variable name="count">
    <!-- part special case is needed because components which
         are children of part should be at the same level as
         components that are not enclosed in a part. -->
    <xsl:choose>
      <xsl:when test="self::part">
        <xsl:value-of select="count($node/ancestor::*)" />
      </xsl:when>
      <xsl:when test="/part">
        <!-- When part is a top node, then it counts normally.  -->
        <xsl:value-of 
          select="count($node/ancestor::*)" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of 
          select="count($node/ancestor::*[not(self::set | self::part)])" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>
  
  <xsl:choose>
    <xsl:when test="$heading-class = 'chapter'">
      <xsl:choose>
        <xsl:when test="$count = 0">top</xsl:when>
        <xsl:when test="$count = 1">chapter</xsl:when>
        <xsl:when test="$count = 2">section</xsl:when>
        <xsl:when test="$count = 3">subsection</xsl:when>
        <xsl:when test="$count = 4">subsubsection</xsl:when>
        <!-- Note: we use subsubheading so that it won't screw up the TOC -->
        <xsl:otherwise><xsl:text>subsubheading</xsl:text>
          <xsl:call-template name="user-message">
            <xsl:with-param name="key">section is too deep</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$heading-class = 'unnumbered'">
      <xsl:choose>
        <xsl:when test="$count = 0">top</xsl:when>
        <xsl:when test="$count = 1">unnumbered</xsl:when>
        <xsl:when test="$count = 2">unnumberedsec</xsl:when>
        <xsl:when test="$count = 3">unnumberedsubsec</xsl:when>
        <xsl:when test="$count = 4">unnumberedsubsubsec</xsl:when>
        <xsl:otherwise><xsl:text>subsubheading</xsl:text>
          <xsl:call-template name="user-message">
            <xsl:with-param name="key">section is too deep</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$heading-class = 'appendix'">
      <xsl:choose>
        <xsl:when test="$count = 0">top</xsl:when>
        <xsl:when test="$count = 1">appendix</xsl:when>
        <xsl:when test="$count = 2">appendixsec</xsl:when>
        <xsl:when test="$count = 3">appendixsubsec</xsl:when>
        <xsl:when test="$count = 4">appendixsubsubsec</xsl:when>
        <xsl:otherwise><xsl:text>subsubheading</xsl:text>
          <xsl:call-template name="user-message">
            <xsl:with-param name="key">section is too deep</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
    <xsl:when test="$heading-class = 'chapheading'">
      <xsl:choose>
        <xsl:when test="$count = 0">majorheading</xsl:when>
        <xsl:when test="$count = 1">chapheading</xsl:when>
        <xsl:when test="$count = 2">heading</xsl:when>
        <xsl:when test="$count = 3">subheading</xsl:when>
        <xsl:when test="$count = 4">subsubheading</xsl:when>
        <xsl:otherwise><xsl:text>subsubheading</xsl:text>
          <xsl:call-template name="user-message">
            <xsl:with-param name="key">section is too deep</xsl:with-param>
          </xsl:call-template>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:when>
  </xsl:choose>
</xsl:template>


<!-- ==================================================================== -->

<doc:template name="make-texinfo-section" xmlns="">
  <refpurpose>Make Texinfo section</refpurpose>
  <refdescription>
    <para>
      This template outputs the corresponding Texinfo sectioning
      command for the DocBook sectioning elements.
    </para>

    <para>
      Logically speaking, this template might better be
      called <function role="xsl-template">make-texinfo-heading</function>,
      as it only output the Texinfo sectioning command, but not
      the actual content of the section.
    </para>
  </refdescription>

  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>level</parameter></term>
        <listitem><para>
          The name of the Texinfo structuring command.  If not specified,
          automatically uses <function>get-texinfo-section-level</function>.
        </para></listitem>
      </varlistentry>
      <varlistentry>
        <term><parameter>title</parameter></term>
        <listitem><para>
        The title to use for the section.  The default is found by applying
        <function>title</function> mode templates to the context node.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="make-texinfo-section">
  <xsl:param name="level">
    <xsl:call-template name="get-texinfo-section-level" />
  </xsl:param>
  <xsl:param name="title">
    <xsl:apply-templates select="." mode="for-title" />
  </xsl:param>
 
  <xsl:element name="{$level}" 
               namespace="http://docbook2x.sourceforge.net/xmlns/Texi-XML">
    <xsl:copy-of select="$title" />
  </xsl:element>
 
</xsl:template>

<!-- ==================================================================== -->

<doc:template name="section" xmlns="">
  <refpurpose>Standard template for section structures</refpurpose>
  <refdescription>
    <para>
      For the given element, it creates a node for it if is.node=1, otherwise
      an anchor, and calls <function>make-texinfo-section</function> for the actual
      sectioning command.  Finally templates are applied for the child
      elements.
    </para>

    <para>
      With this, the user can easily decide what elements are to be converted
      to nodes with a simple change to <filename>texinode.xsl</filename>.
    </para>
  
   </refdescription>

  <refparameter>
    <para>
      The arguments are the same as the ones for
      <function>make-texinfo-section</function>, plus
      <parameter>content</parameter>.
    </para>

    <variablelist>
      <varlistentry>
        <term><parameter>content</parameter></term>
        <listitem><para>
          The result tree fragment of the section.  Defaults to applying
          templates.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="section">
  <xsl:param name="level">
    <xsl:call-template name="get-texinfo-section-level" />
  </xsl:param>
  <xsl:param name="title">
    <xsl:apply-templates select="." mode="for-title" />
  </xsl:param>
  <xsl:param name="content">
    <xsl:apply-templates />
  </xsl:param>
  
  <xsl:variable name="is-node">
    <xsl:apply-templates select="." mode="is-texinfo-node" />
  </xsl:variable>

  <xsl:choose>
    <xsl:when test="$is-node = '1'">
      <xsl:call-template name="make-texinfo-node" />
    </xsl:when>
    <xsl:otherwise>
      <xsl:call-template name="anchor" />
    </xsl:otherwise>
  </xsl:choose>
  
  <!-- FIXME: This doesn't catch all the cases -->
  <xsl:if test="@lang|@xml:lang">
    <documentlanguage>
      <xsl:attribute name="lang">
        <xsl:value-of select="(@lang|@xml:lang)[last()]" />
      </xsl:attribute>
    </documentlanguage>
  </xsl:if>

  <xsl:call-template name="make-texinfo-section">
    <xsl:with-param name="level" select="$level" />
    <xsl:with-param name="title" select="$title" />
  </xsl:call-template>

  <xsl:copy-of select="$content" />

  <xsl:if test="@lang|@xml:lang">
    <!-- Revert to previous document language -->
    <documentlanguage />
  </xsl:if>
</xsl:template>

</xsl:stylesheet>

