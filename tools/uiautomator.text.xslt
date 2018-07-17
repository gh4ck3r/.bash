<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:regexp="http://exslt.org/regular-expressions">
  <xsl:output method="text" omit-xml-declaration="yes" indent="no"/>

  <xsl:template match="/">
    <xsl:for-each select="//node[@text!='']">
      <xsl:value-of select="@text"/>
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>

</xsl:stylesheet>
