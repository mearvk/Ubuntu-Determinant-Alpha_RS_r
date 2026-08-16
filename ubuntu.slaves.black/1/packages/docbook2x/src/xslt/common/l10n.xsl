<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns:l="http://docbook2x.sourceforge.net/xsl/localization"
                exclude-result-prefixes="doc l"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: l10n.xsl,v 1.16 2003/05/24 13:52:38 stevecheng Exp $
     ********************************************************************

     &copy; 2000 Steve Cheng <stevecheng@users.sourceforge.net>

     Templates to help l10n.
     ******************************************************************** -->


<xsl:param name="localization-file" select="'text/l10n-set.xml'" />
<doc:param name="localization-file" xmlns="">
  <refpurpose>(URI of) XML document containing localization data</refpurpose>
  <refdescription>
    <para>
      This parameter specifies the URI of the localization-set document.
      This document, written in XML, describes all the text translations
      (and other locale-specific information) used by the stylesheet.
    </para>

    <para>
      You do not need to change this parameter unless you want to use
      custom localization data.
    </para>
  </refdescription>
</doc:param>

<xsl:variable name="l10n-data" select="document($localization-file)/l:localization-set" />
<doc:variable name="l10n-data" xmlns="">
  <refpurpose>XML element node containing localization-data</refpurpose>
  <refdescription>
    <para>
      This is just <userinput>document($localization-file)/l:localization-set</userinput>.
      There is no need to change this.
    </para>
  </refdescription>
</doc:variable>

<xsl:param name="default-document-language" select="'en'" />
<doc:param name="default-document-language" xmlns="">
  <refpurpose>Assumed language of the input document when it is not specified in the source</refpurpose>
  <refdescription>
    <para>
      If the source document does not specify what language
      it is written in using the <sgmltag class="attribute">lang</sgmltag>
      or <sgmltag class="attribute">xml:lang</sgmltag> attribute.
      then it is assumed to be in the language this parameter is set
      to.  If these attributes are present (and in effect, whenever
      the stylesheet needs language information), the language
      specified in this parameter is ignored.
    </para>

    <para>
      You rarely need to change this parameter; 
      it is better to change the source document instead,
      adding the <sgmltag class="attribute">lang</sgmltag> 
      or the <sgmltag class="attribute">xml:lang</sgmltag> attribute.
    </para>

    <para>
      The format of the value of this parameter is the usual
      <userinput><replaceable>language_code</replaceable>-<replaceable>country_code</replaceable></userinput>.  For example, <userinput>zh-TW</userinput>.
      The hyphen (<token>-</token>) may also be an 
      underscore (<token>_</token>).
    </para>
  </refdescription>
</doc:param>

<!-- ==================================================================== -->

<doc:template name="l10n-match-language">
  <refpurpose>Determine the language to translate to</refpurpose>
  <refdescription>
    <para>
      Given a language code <parameter>lang</parameter> 
      (usually obtained from 
      <function role="xsl-template">l10n-xml-language</function>),
      match it with a language code in the localization data file.
      The new language code may in fact be the same language code,
      or it could be the language code with the country-code part
      stripped.  If the localization data file does not contain
      the language <parameter>lang</parameter>, then some default
      language that does exist is returned.
    </para>
  </refdescription>
  
  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>lang</parameter></term>
        <listitem><para>
          The original language code.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="l10n-match-language">
  <xsl:param name="lang" />
  
  <xsl:choose>
    <xsl:when test="$l10n-data/l:locale[@lang=$lang]">
      <xsl:value-of select="$lang" />
    </xsl:when>

    <!-- Try just the language code without the country. -->
    <xsl:when test="$l10n-data/l:locale[@lang=substring-before($lang, '-')]">
      <xsl:value-of select="substring-before($lang, '-')" />
    </xsl:when>

    <!-- Default -->
    <xsl:otherwise>
      <xsl:call-template name="user-message">
        <xsl:with-param name="arg-1" select="$lang" />
        <xsl:with-param name="key" 
                        select="'No localization exists'" />
        <xsl:with-param name="content">No localization exists for language “<l:a1/>”</xsl:with-param>
      </xsl:call-template>

      <xsl:value-of select="$default-document-language" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

 
<!-- ==================================================================== -->

<doc:template name="l10n-xml-language">
  <refpurpose>Determine the language of the given XML fragment</refpurpose>
  <refdescription>
    <para>
      Returns the language of the XML content at the given node,
      as determined by the <sgmltag class="attribute">lang</sgmltag>
      or <sgmltag class="attribute">xml:lang</sgmltag> attribute.
    </para>

    <para>
      The result is always given in a normalized form:
      <literal><replaceable>language_code</replaceable>-<replaceable>country_code</replaceable></literal>, with the <replaceable>language_code</replaceable>
      and <replaceable>country_code</replaceable> always in lower case.
      The <literal>-<replaceable>country_code</replaceable></literal> 
      may be missing.
    </para>

    <para>
      No checking is done to make sure the language code is valid.
    </para>
  </refdescription>

  <refparameter>
    <variablelist>
      <varlistentry>
        <term><parameter>target</parameter></term>
        <listitem><para>
          The (element) node to find out the language for.
          Defaults to the context node.
        </para></listitem>
      </varlistentry>
    </variablelist>
  </refparameter>
</doc:template>

<xsl:template name="l10n-xml-language">
  <xsl:param name="target" select="." />

  <!-- 
    Look for the closest lang or xml:lang attribute in the element 
    hierarchy.  As the DocBook XSL stylesheets say, we need
    two xsl:variables to do this because attributes are not ordered.

    If nothing is found, use $default-document-language.
  -->
  <xsl:variable name="mc-lang">
    <xsl:variable name="lang-scope"
      select="($target/ancestor-or-self::*[@lang or @xml:lang])[1]" />
    <xsl:variable name="lang-attr"
      select="$lang-scope/@lang | $lang-scope/@xml:lang" />
    <xsl:choose>
      <xsl:when test="string($lang-attr) = ''">
        <xsl:value-of select="$default-document-language" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$lang-attr" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="normalized-lang"
                select="translate($mc-lang,
                                  'ABCDEFGHIJKLMNOPQRSTUVWXYZ_',
                                  'abcdefghijklmnopqrstuvwxyz-')" />

  <xsl:value-of select="$normalized-lang" />
</xsl:template>

<xsl:template name="l10n-xml-actual-language">
  <xsl:param name="target" select="." />
  <xsl:call-template name="l10n-match-language">
    <xsl:with-param name="lang">
      <xsl:call-template name="l10n-xml-language">
        <xsl:with-param name="target" select="$target" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<doc:mode mode="l10n-substitution">
  <refpurpose>Output localized text, substituting parameters if necessary</refpurpose>
  <refdescription>
    <para>
      A piece of the translated text is processed with this mode
      to perform any substitutions of parameters like
      chapter numbers, etc.  Text nodes are echoed through in
      this mode.
    </para>
  </refdescription>
</doc:mode>

<xsl:template match="text()" mode="l10n-substitution">
  <xsl:value-of select="." />
</xsl:template>

<!-- ==================================================================== -->

</xsl:stylesheet>

