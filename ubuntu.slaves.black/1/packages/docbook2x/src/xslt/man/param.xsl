<?xml version='1.0'?>
<!-- vim: sw=2 sta et
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:doc="http://nwalsh.com/xsl/documentation/1.0"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Man-XML"
                exclude-result-prefixes="doc"
                version='1.0'
                xml:lang="en">

<!-- ********************************************************************
     $Id: param.xsl,v 1.15 2006/04/19 20:31:19 stevecheng Exp $
     ********************************************************************

     (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>

     This file is part of the docbook2X XSLT stylesheets for
     converting DocBook to man pages.

     See ../../COPYING for the copyright status of this software.

     ******************************************************************** -->

<!-- ==================================================================== -->

<doc:reference xmlns="">
<title>Stylesheet parameters</title>

<para>
Stylesheet parameters influence various aspects of the rendering.  They
can be set from the command line (the exact syntax depends on the XSLT
processor), or in a custom stylesheet.  
</para>

<para>
To set them in a custom stylesheet, simply copy the definition here and
change the <sgmltag class="attribute">select</sgmltag> attribute to
something else.
</para>

<para>
If a parameter for what you want to change does not exist, you can write
templates in the custom stylesheet instead.
</para>

</doc:reference>

<xsl:param name="user-message-prefix" select="'docbook2man:'" />

<!-- ==================================================================== -->
<xsl:param name="lowercase-file" select="false()" />
<doc:param name="lowercase-file" xmlns="">
<refpurpose>Make man-page file names lowercase?</refpurpose>
<refdescription>
<para>
Whenever a man-page title is 
all uppercase and this option is set,  then the name
of the file that contains that man-page should be changed to lowercase.
If the man-page title is mixed-case, the file name will be unchanged.
</para>
<para>
This option is intended for the situation where 
the title of the man-page is an identifier
in some language (e.g. SQL) that is case-insensitive,
but the official version of the identifier is in uppercase.
The user would probably prefer 
that the man-page should not be filed as all uppercase,
even though the title displayed on the man-page should be upper-case.
</para>
</refdescription>
</doc:param>

<xsl:param name="uppercase-headings" select="true()" />
<doc:param name="uppercase-headings" xmlns="">
<refpurpose>Make headings uppercase?</refpurpose>
<refdescription>
<para>
Headings in man page content should be or should not be uppercased.
</para>
</refdescription>
</doc:param>

<xsl:param name="manvolnum-cite-numeral-only" select="true()" />
<doc:param name="manvolnum-cite-numeral-only" xmlns="">
<refpurpose>Man page section citation should use only the number</refpurpose>
<refdescription>
<para>
When citing other man pages, the man-page section is either given as is,
or has the letters stripped from it, citing only the number of the
section (e.g. section <literal>3x</literal> becomes
<literal>3</literal>).  This option specifies which style. 
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="quotes-on-literals" select="false()" />
<doc:param name="quotes-on-literals" xmlns="">
<refpurpose>Display quotes on <sgmltag class="element">literal</sgmltag>
elements?</refpurpose>
<refdescription>
<para>
If true, render <sgmltag class="element">literal</sgmltag> elements
with quotes around them.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="show-comments" select="true()"/>

<doc:param name="show-comments" xmlns="">
<refpurpose>Display <sgmltag>comment</sgmltag> elements?</refpurpose>
<refdescription>
<para>If true, comments will be displayed, otherwise they are suppressed.
Comments here refers to the <sgmltag>comment</sgmltag> element,
which will be renamed <sgmltag>remark</sgmltag> in DocBook V4.0,
not XML comments (&lt;-- like this --&gt;) which are unavailable.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="function-parens" select="false()" />

<doc:param name="function-parens" xmlns="">
<refpurpose>Generate parentheses after a function?</refpurpose>
<refdescription>
<para>If true, the formatting of
a <sgmltag class="starttag">function</sgmltag> element will include
generated parenthesis.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="xref-on-link" select="true()" />

<doc:param name="xref-on-link" xmlns="">
<refpurpose>Should <sgmltag class="element">link</sgmltag> generate a
cross-reference?</refpurpose>
<refdescription>
<para>
Man pages cannot render the hypertext links created by <sgmltag
class="element">link</sgmltag>.  If this option is set, then the
stylesheet renders a cross reference to the target of the link.
(This may reduce clutter).  Otherwise, only the content of the <sgmltag
class="element">link</sgmltag> is rendered and the actual link itself is
ignored.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="header-3" select="''" />

<doc:param name="header-3" xmlns="">
<refpurpose>Third header text</refpurpose>
<refdescription>
<para>
Specifies the text of the third header of a man page,
typically the date for the man page.  If empty, the <sgmltag
class="element">date</sgmltag> content for the <sgmltag
class="element">refentry</sgmltag> is used.
</para>
</refdescription>
</doc:param>

<xsl:param name="header-4" select="''" />

<doc:param name="header-4" xmlns="">
<refpurpose>Fourth header text</refpurpose>
<refdescription>
<para>
Specifies the text of the fourth header of a man page.
If empty, the <sgmltag class="element">refmiscinfo</sgmltag> content for
the <sgmltag class="element">refentry</sgmltag> is used.
</para>
</refdescription>
</doc:param>

<xsl:param name="header-5" select="''" />

<doc:param name="header-5" xmlns="">
<refpurpose>Fifth header text</refpurpose>
<refdescription>
<para>
Specifies the text of the fifth header of a man page.
If empty, the <quote>manual name</quote>, that is, the title of the
<sgmltag class="element">book</sgmltag> or <sgmltag
class="element">reference</sgmltag> container is used.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="default-manpage-section" select="'1'" />

<doc:param name="default-manpage-section" xmlns="">
<refpurpose>Default man page section</refpurpose>
<refdescription>
<para>
The source document usually indicates the sections that each man page
should belong to (with <sgmltag class="element">manvolnum</sgmltag> in
<sgmltag class="element">refmeta</sgmltag>).  In case the source
document does not indicate man-page sections, this option specifies the
default.
</para>
</refdescription>
</doc:param>

<!-- ==================================================================== -->
<xsl:param name="custom-localization-file" select="''" />

<doc:param name="custom-localization-file" xmlns="">
<refpurpose>URI of XML document containing custom localization data</refpurpose>
<refdescription>
<para>
This parameter specifies the URI of a XML document
that describes text translations (and other locale-specific information)
that is needed by the stylesheet to process the DocBook document.
</para>
<para>
The text translations pointed to by this parameter always
override the default text translations 
(from the internal parameter <parameter>localization-file</parameter>).
If a particular translation is not present here,
the corresponding default translation 
is used as a fallback.
</para>
<para>
This parameter is primarily for changing certain
punctuation characters used in formatting the source document.
The settings for punctuation characters are often specific
to the source document, but can also be dependent on the locale.
</para>
<para>
To not use custom text translations, leave this parameter 
as the empty string.
</para>
</refdescription>
</doc:param>

<xsl:param name="custom-l10n-data" 
           select="document($custom-localization-file)" />

<doc:param name="custom-l10n-data" xmlns="">
<refpurpose>XML document containing custom localization data</refpurpose>
<refdescription>
<para>
This parameter specifies the XML document
that describes text translations (and other locale-specific information)
that is needed by the stylesheet to process the DocBook document.
</para>

<para>
This parameter is internal to the stylesheet.
To point to an external XML document with a URI or a file name, 
you should use the <parameter>custom-localization-file</parameter>
parameter instead.
</para>

<para>
However, inside a custom stylesheet 
(<emphasis>not on the command-line</emphasis>)
this paramter can be set to the XPath expression
<literal>document('')</literal>,
which will cause the custom translations 
directly embedded inside the custom stylesheet to be read.
</para>
</refdescription>
</doc:param>


<!-- ==================================================================== -->
<xsl:param name="author-othername-in-middle" select="1"/>

<doc:param name="author-othername-in-middle" xmlns="">
<refpurpose>Is <sgmltag>othername</sgmltag> in <sgmltag>author</sgmltag> a
middle name?</refpurpose>
<refdescription>
<para>If true, the <sgmltag>othername</sgmltag> of an <sgmltag>author</sgmltag>
appears between the <sgmltag>firstname</sgmltag> and
<sgmltag>surname</sgmltag>.  Otherwise, <sgmltag>othername</sgmltag>
is suppressed.
</para>
</refdescription>
</doc:param>


</xsl:stylesheet>

