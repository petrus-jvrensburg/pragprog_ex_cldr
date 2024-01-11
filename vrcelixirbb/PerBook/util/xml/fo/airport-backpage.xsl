<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:str="http://exslt.org/strings"
version="2.0">


<xsl:template name="airport-backpage">
  <fo:block margin-top="96pt" start-indent="0.5in" end-indent="0.5in">
    <fo:block font-family="MyriadCond" font-size="18pt" border-bottom="1pt solid {$color.heading-underline}"
    padding-bottom="-7pt" margin-bottom="8pt"
    >
      The Pragmatic Bookshelf
  </fo:block >

  <fo:block margin-bottom="4pt" font-size="7pt">
    The Pragmatic Bookshelf is a small independent publisher.
    We're lucky to be able to publish books that we love, written
    by authors we consider friends.
  </fo:block>

  <fo:block margin-bottom="4pt" font-size="7pt">
    We publish deeply technical books written by software developers for software developers. 
    Recently we've expanded our catalog to include titles covering the
    history of software development, along with issues regarding health and well being.
  </fo:block>

  <fo:block margin-bottom="4pt" font-size="7pt">
    Please visit us at 
    <xsl:call-template name="external-link">
      <xsl:with-param name="url">https://pragprog.com</xsl:with-param>
      <xsl:with-param name="text">https://pragprog.com</xsl:with-param>
      </xsl:call-template>.
    </fo:block>
  </fo:block>
</xsl:template>

</xsl:stylesheet>
