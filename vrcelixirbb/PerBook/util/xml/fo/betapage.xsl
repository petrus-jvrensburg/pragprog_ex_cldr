<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:date="http://exslt.org/dates-and-times"
                version="2.0">

  <xsl:attribute-set name="beta-block">
    <xsl:attribute name="margin-left">
      <xsl:choose>
        <xsl:when test="$booktype='pguide'">0.2in</xsl:when>
        <xsl:otherwise>0.5in</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="margin-right">
     <xsl:choose>
        <xsl:when test="$booktype='pguide'">0.2in</xsl:when>
        <xsl:otherwise>0.5in</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:choose>
        <xsl:when test="$booktype='pguide'">85%</xsl:when>
        <xsl:otherwise>90%</xsl:otherwise>
      </xsl:choose>
</xsl:attribute>
  </xsl:attribute-set>

  <xsl:template name="do-beta-page">
    <fo:page-sequence
	xsl:use-attribute-sets="end-on-even"
	master-reference="praise" format="i">
      <fo:flow flow-name="xsl-region-body">
        <fo:block>
          <xsl:call-template name="beta-content"/>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template name="beta-content">

    <fo:block-container
	    font-family="{$sans.font.family}"
      xsl:use-attribute-sets="beta-block"
      >


      <fo:float float="left">
	<fo:block line-stacking-strategy="max-height"
		  line-height="0pt"
		  margin-left="-0.5in"
		  margin-right="0.1in"
		  margin-bottom="-0.5in">
	  <fo:external-graphic
	      src="url(../PerBook/util/images/beta-book.pdf)"
	      content-width="40%"/>
	</fo:block>
      </fo:float>

      <fo:block margin-bottom="6pt">
	<fo:inline font-weight="bold">
	  Under Construction:
	</fo:inline>
	The book you’re reading is still under development. As part of
	our Beta book program, we’re releasing this copy well before a
	normal book would be released. That way you’re able to get this
	content a couple of months before it’s available in finished
	form, and we’ll get feedback to make the book even better. The
	idea is that everyone wins!
      </fo:block>


      <fo:block margin-bottom="6pt">
	<fo:inline font-weight="bold">
	  Be warned:
	</fo:inline>
	The book has not had a full technical edit, so it will contain
	errors. It has not been copyedited, so it will be full of
	typos, spelling mistakes, and the occasional creative piece of
	grammar. And there’s been no effort spent doing layout, so
	you’ll find bad page breaks, over-long code lines, incorrect
	hyphenation, and all the other ugly things that you wouldn’t
	expect to see in a finished book. It also doesn't have an
	index. We can’t be held liable if you use this book to try to
	create a spiffy application and you somehow end up with a
	strangely shaped farm implement instead. Despite all this, we
	think you’ll enjoy it!
      </fo:block>

      <fo:block margin-bottom="6pt">
	<fo:inline font-weight="bold">
	  Download Updates:
	</fo:inline>
	Throughout this process you’ll be able to get updated ebooks
	from your account at
	<xsl:call-template name="external-link">
	  <xsl:with-param name="url">http://pragprog.com/my_account</xsl:with-param>
	  <xsl:with-param name="text">pragprog.com/my_account</xsl:with-param>
	</xsl:call-template><xsl:text>.</xsl:text>
	When the book is complete, you’ll get the
	final version (and subsequent updates) from the same address.
      </fo:block>

      <fo:block margin-bottom="6pt">
	<fo:inline font-weight="bold">
	  Send us your feedback:
	</fo:inline>
	In the meantime, we’d appreciate you
	sending us your feedback on this book at
	<xsl:call-template name="external-link">
	  <xsl:with-param name="url">
	    <xsl:text>http://pragprog.com/titles/</xsl:text>
	    <xsl:value-of select="$book-code"/>
	    <xsl:text>/errata</xsl:text>
	  </xsl:with-param>
	  <xsl:with-param name="text">
	    <xsl:text>pragprog.com/titles/</xsl:text>
	    <xsl:value-of select="$book-code"/>
	    <xsl:text>/errata</xsl:text>
	  </xsl:with-param>
	</xsl:call-template><xsl:text>,</xsl:text>
	or by using
	the links at the bottom of each page.
      </fo:block>

      <fo:block margin-bottom="6pt">
	Thank you for being part of the Pragmatic community!
      </fo:block>

      <fo:block margin-top="0.5in" font-style="italic">
        The Pragmatic Bookshelf
      </fo:block>
    </fo:block-container>
  </xsl:template>

</xsl:stylesheet>
