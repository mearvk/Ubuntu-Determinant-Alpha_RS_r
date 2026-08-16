<?xml version='1.0'?>
<!-- vim: sta et sw=2
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns="http://docbook2x.sourceforge.net/xmlns/Texi-XML"
                version='1.0'
                xml:lang="en">

<xsl:import href="../texi/docbook.xsl" />
<xsl:import href="../texi/jrefentry.xsl" />

<xsl:template match="/part/partintro" mode="is-texinfo-node">
  <xsl:value-of select="1" />
</xsl:template>

</xsl:stylesheet>
