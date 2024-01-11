<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:pp="http://pragprog.com"
version="2.0">

<xsl:template name="contact.text">
  <fo:block>
    For our complete catalog of hands-on, practical, and Pragmatic content for software developers, please visit
    <xsl:call-template name="external-link">
      <xsl:with-param name="url">https://pragprog.com</xsl:with-param>
      <xsl:with-param name="text">https:<xsl:call-template name="double-slash"/>pragprog.com</xsl:with-param>
    </xsl:call-template><xsl:text>.</xsl:text>
  </fo:block>
</xsl:template>

<xsl:template name="copyright.text">
  <fo:block space-after="0.5em">
    When we are aware that a term used in this book is claimed as a trademark,
    the designation is printed with an
    initial capital letter or in all capitals.
  </fo:block>

  <fo:block space-after="0.5em">
    The Pragmatic Starter Kit,
    The Pragmatic Programmer, Pragmatic Programming, Pragmatic Bookshelf, 
    PragProg and the linking 
    <fo:inline font-style="italic">g</fo:inline>
    device are trademarks of The Pragmatic Programmers,
    LLC. 
  </fo:block>
  <fo:block space-after="0.5em">
    Every precaution was taken in the preparation of this
    book. However, the publisher assumes no responsibility for errors or
    omissions, or for damages that may result from the use of information
    (including program listings) contained herein.
  </fo:block>
</xsl:template>


<xsl:template name="pp:extra-rights">
</xsl:template><!-- overridden in book -->

<xsl:template name="country-of-manufacture">  <!-- overridden in book -->
  <xsl:text>the United States of America</xsl:text>
</xsl:template>

</xsl:stylesheet>
