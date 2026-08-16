<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

  <xsl:import href="http://docbook.sourceforge.net/release/xsl/current/xhtml/chunk.xsl"/>
  <xsl:include href="common.xsl"/>

  <xsl:output method="html" encoding="UTF-8"/>

  <xsl:param name="use.id.as.filename">1</xsl:param>

  <xsl:param name="chunk.section.depth">0</xsl:param>
  <xsl:param name="chunker.output.indent">yes</xsl:param>
  <xsl:param name="chunker.output.encoding" select="'utf-8'"/>

</xsl:stylesheet>
