<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">            

  <xsl:template name="build-image-list"/>

  <xsl:template name="get-image-name">
    <xsl:param name="file">
      <xsl:value-of select="@fileref"/>
    </xsl:param>
    <xsl:value-of select="$file"/>
  </xsl:template>

</xsl:stylesheet>