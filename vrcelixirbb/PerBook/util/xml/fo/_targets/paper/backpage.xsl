<?xml version="1.0" encoding="utf-8"?>
   
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">            


  <xsl:template name="backpage-buy-the-book">
    <xsl:param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com/coupon</xsl:param>
    <xsl:if test="not(//book/options/omitcoupon)">
    <xsl:call-template name="back-page-heading">
      <xsl:with-param name="title">Save on the ebook</xsl:with-param>
    </xsl:call-template>
    <fo:block>
      Save on the ebook versions of this title. Owning the paper
      version of this book entitles you to purchase the electronic
      versions at a terrific discount.
    </fo:block>
    <fo:block space-before="4pt">
      PDFs are great for carrying around on your laptop—they
      are hyperlinked, have color, and are fully searchable.  Most
      titles are also available for the iPhone and iPod touch, Amazon
      Kindle, and other popular e-book readers.
    </fo:block>
<fo:block space-before="4pt">
      Send a copy of your receipt to support@pragprog.com and we'll provide you with a discount coupon. 
</fo:block>
    <fo:block space-before="4pt">
  <!--    Buy now at
      <xsl:call-template name="external-link">
        <xsl:with-param name="url">
          <xsl:value-of select="$url"/>
        </xsl:with-param>
        <xsl:with-param name="text">
          <xsl:copy-of select="$url"/>
        </xsl:with-param>
      </xsl:call-template> -->
    </fo:block>
    </xsl:if>
  </xsl:template>

  

</xsl:stylesheet>
