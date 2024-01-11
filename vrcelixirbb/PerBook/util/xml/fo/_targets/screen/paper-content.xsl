<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:pp="http://pragprog.com"
                version="1.0">            

  <xsl:template name="pp:paper-content">  <!-- may be overridden in book -->
    <xsl:call-template name="pp:paper-content-screen"/>
  </xsl:template>

  <xsl:template name="pp:paper-content-screen"> <!-- may be overridden -->
    <xsl:text>Encoded using the finest acid-free high-entropy binary digits.</xsl:text>
  </xsl:template>

</xsl:stylesheet>