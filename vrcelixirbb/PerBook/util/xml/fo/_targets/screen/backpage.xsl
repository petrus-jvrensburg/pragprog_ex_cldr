<?xml version="1.0" encoding="utf-8"?>
   
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="1.0">            


  <xsl:template name="backpage-buy-the-book">
    <xsl:param name="url">https://pragprog.com/book/<xsl:value-of select="$book-code"/></xsl:param>
    <xsl:call-template name="back-page-heading">
      <xsl:with-param name="title">Buy the Book</xsl:with-param>
    </xsl:call-template>
   <fo:block>
      If you liked this ebook, perhaps you’d like to have a paper
      copy of the book. Paperbacks are available from your local independent bookstore and wherever fine books are sold. <!--It’s available for purchase at our store:
      <xsl:call-template name="external-link">
        <xsl:with-param name="url">
          <xsl:value-of select="$url"/>
        </xsl:with-param>
        <xsl:with-param name="text">
          <xsl:copy-of select="$url"/>
        </xsl:with-param>
      </xsl:call-template>-->
    </fo:block>
  </xsl:template>
  

</xsl:stylesheet>
