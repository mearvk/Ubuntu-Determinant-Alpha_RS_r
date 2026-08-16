<?xml version='1.0'?>
<!-- vim: sta et sw=2
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                version='1.0'
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                exclude-result-prefixes="doc xsl"
                xml:lang="en">

<xsl:import href="extract-jrefentry.xsl" />
<xsl:include href="../backend/string.xsl" />

<!-- ==================================================================== -->

<xsl:param name="process-includes" select="true()" />
<xsl:param name="process-imports"  select="false() " />

<!-- ==================================================================== -->
<xsl:template match="/">
  <part>
    <partinfo>
      <subjectset scheme="texinfo-directory">
        <subject><subjectterm>Document Preparation</subjectterm></subject>
      </subjectset>
      <abstract role="texinfo-node"><para>.</para></abstract>
    </partinfo>
  
    <title>
      <xsl:copy-of select="$title" />
    </title>

    <partintro>
      <title>Guide to the stylesheet reference</title>

      <para>
      For the most part, this reference assumes knowledge of XSLT.
      But if you are not familiar with XSLT, you can still look
      at the page of stylesheet parameters; they are the commonly
      used options to the stylesheets that may be directly 
      set from the command line.  Also take a look at the 
      introductory text to each XSL file, which gives some
      general advice to tweaking the output of the stylesheets.
      </para>

      <para>
      In the lists of stylesheet items, the following symbols are 
      prefixed before each item to indicate their type:

      <variablelist>
        <varlistentry>
          <term>[P]</term>
          <listitem><para>A global parameter.</para>
                    <para>The synopsis for the parameter 
                          shows its default value.</para></listitem>
        </varlistentry>

        <varlistentry>
          <term>[V]</term>
          <listitem><para>A global variable.</para></listitem>
        </varlistentry>
        
        <varlistentry>
          <term>[M]</term>
          <listitem><para>A template mode.</para></listitem>
        </varlistentry>

        <varlistentry>
          <term>[T]</term>
          <listitem><para>A named template.</para></listitem>
        </varlistentry>
        
        <varlistentry>
          <term>[t <replaceable>mode</replaceable>]</term>
          <listitem>
            <para>
              A template with a 
              <sgmltag class="attribute">match</sgmltag> attribute,
              for the given mode.  If <replaceable>mode</replaceable>
              is omitted, that means the default mode.
            </para>

            <para>
              These usually have no description; they are just
              listed so that you know the template exists.
            </para>
          </listitem>
        </varlistentry>
      </variablelist>
      </para>
      
    </partintro>

    <xsl:apply-templates />
  </part>
</xsl:template>

<!-- ==================================================================== -->
                    
<xsl:strip-space elements="xsl:stylesheet"/>

<!-- ==================================================================== -->

<xsl:template name="display-filename">
  <xsl:param name="filename" />
  <!-- Texinfo cannot handle dots in node names, so avoid them -->
  <xsl:call-template name="string-subst">
    <xsl:with-param name="content">
  <xsl:call-template name="string-subst">
    <xsl:with-param name="content" select="$filename" />
    <xsl:with-param name="replace" select="'.xsl'" />
    <xsl:with-param name="with"    select="''" />
  </xsl:call-template>
    </xsl:with-param>
    
    <xsl:with-param name="replace" select="'../'" />
    <xsl:with-param name="with"    select="''" />
  </xsl:call-template>
</xsl:template>

<!-- ==================================================================== -->

<xsl:template match="xsl:include" mode="process-includes">
  <!-- Don't go up directories -->
  <xsl:apply-templates select="document(@href)/*">
    <xsl:with-param name="filename" select="@href" />
  </xsl:apply-templates>
</xsl:template>

<xsl:template match="xsl:import" mode="process-includes">
  <xsl:if test="$process-imports">
    <xsl:apply-templates select="document(@href)/*">
      <xsl:with-param name="filename" select="@href" />
    </xsl:apply-templates>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
