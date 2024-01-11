<?xml version="1.0" encoding="utf-8"?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:str="http://exslt.org/strings"
version="2.0">


  <xsl:include href="airport-backpage.xsl"/>

<xsl:attribute-set name="adpagetitle">
  <xsl:attribute name="font-family">MyriadCond</xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:choose>
      <xsl:when test="@titlesize = 'small'">26pt</xsl:when>
      <xsl:when test="@titlesize = 'smaller'">24pt</xsl:when>
      <xsl:when test="@titlesize = 'smallest'">22pt</xsl:when>
      <xsl:otherwise>28pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="margin-top">
    <xsl:choose>
      <xsl:when test="ancestor::backpage">24pt</xsl:when>
      <xsl:otherwise>0pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="border-bottom">4pt solid <xsl:value-of select="$color.heading-underline"/></xsl:attribute>
  <xsl:attribute name="padding-bottom">-12.75pt</xsl:attribute>
  <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="adtitle">
  <xsl:attribute name="font-family">MyriadCond</xsl:attribute>
  <xsl:attribute name="font-size">20pt</xsl:attribute>
  <xsl:attribute name="margin-top">
    <xsl:choose>
      <xsl:when test="ancestor::backpage">24pt</xsl:when>
      <xsl:otherwise>0pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="border-bottom">2pt solid <xsl:value-of select="$color.heading-underline"/></xsl:attribute>
  <xsl:attribute name="padding-bottom">-9pt</xsl:attribute>
  <xsl:attribute name="margin-bottom">8pt</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="adcontent">
  <xsl:attribute name="font-family">
    <xsl:choose>
      <xsl:when test="$booktype='pguide'">Palatino</xsl:when>
      <xsl:otherwise>Bookman</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="font-size">
    <xsl:choose>
      <xsl:when test="$booktype='pguide'">7.5pt</xsl:when>
      <xsl:otherwise>8pt</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="padding-top">4pt</xsl:attribute>
  <xsl:attribute name="text-align">left</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="adlink">
  <xsl:attribute name="font-family">
    <xsl:choose>
      <xsl:when test="$booktype='pguide'">Palatino</xsl:when>
      <xsl:otherwise>Myriad</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="font-size">7pt</xsl:attribute>
  <xsl:attribute name="color">
    <xsl:choose>
      <xsl:when test="$target.for-screen = 'yes'">rgb-icc(255,0,255,#SpotColor,fuschia,16711935)</xsl:when>
      <xsl:otherwise>black</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="backmatter-sect2">
  <xsl:attribute name="font-family">
    <xsl:choose>
      <xsl:when test="$booktype='pguide'">Palatino</xsl:when>
      <xsl:otherwise>Myriad</xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="font-weight">bold</xsl:attribute>
  <xsl:attribute name="font-size">9pt</xsl:attribute>
</xsl:attribute-set>


<xsl:template match="backmatter">
  <xsl:apply-templates/>
</xsl:template>

<!-- Added backmatter and related elements. -->
<xsl:template match="backpage">
  <fo:page-sequence master-reference="back-last-page">
    <fo:flow flow-name="xsl-region-body">
      <fo:block>
        <xsl:if test="$target.recto-verso-headings='yes'">
          <xsl:attribute name="break-before">even-page</xsl:attribute>
        </xsl:if>
        <xsl:attribute name="font-size">
          <xsl:choose>
            <xsl:when test="$booktype='pguide'">7.5pt</xsl:when>
            <xsl:otherwise>8pt</xsl:otherwise>
          </xsl:choose>
        </xsl:attribute>
        <xsl:choose>
          <xsl:when test="$booktype='airport'">
            <xsl:call-template name="airport-backpage"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:call-template name="draw-back-page"/>
            <xsl:apply-templates mode="backmatter"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:block>
    </fo:flow>
  </fo:page-sequence>
</xsl:template>

<xsl:template match="ads">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template match="adpage">
  <fo:page-sequence master-reference="adpage">
    <fo:flow flow-name="xsl-region-body">
      <fo:block keep-together.within-page="always">
        <xsl:if test="string-length(title) &gt; 0">
          <fo:block xsl:use-attribute-sets="adtitle">
            <xsl:apply-templates select="title" mode="force"/>
          </fo:block>
        </xsl:if>
        <fo:block xsl:use-attribute-sets="adcontent">
          <xsl:apply-templates
          select="*[not(name() = 'title') and not(name() = 'ad')]"/>
        </fo:block>
        <fo:block display-align="after">

          <xsl:if test="@codes">
            <!-- SAXON change: use tokenize() function instead of str:tokenize -->
            <!--	<xsl:for-each select="str:tokenize(@codes, ' ')"> -->
              <xsl:for-each select="tokenize(@codes,' ')">
                <xsl:variable name="path">
                  <xsl:text>../../../../Common/backmatter/ads/</xsl:text>
                  <xsl:value-of select="."/>
                  <xsl:text>.pml</xsl:text>
                </xsl:variable>
                <xsl:variable name="ad-content">
                  <xsl:apply-templates select="document($path)/ad"/>
                </xsl:variable>
                <xsl:choose>
                  <xsl:when test="string-length($ad-content) &gt; 0">
                    <xsl:copy-of select="$ad-content"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <xsl:choose>
                      <xsl:when test="$target.for-screen = 'no'">
                        <xsl:message terminate="yes">WARNING: Ad text for <xsl:value-of select="."/> is not available.</xsl:message>
                      </xsl:when>
                      <xsl:otherwise>
                        <xsl:message>WARNING: Ad text for <xsl:value-of select="."/> is not available.</xsl:message>
                      </xsl:otherwise>
                    </xsl:choose>
                  </xsl:otherwise>
                </xsl:choose>
              </xsl:for-each>
            </xsl:if>
            <xsl:apply-templates select="ad"/>
          </fo:block>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <!-- Build a coupon that holds an image. Base this on the adpage template. -->
  <xsl:template match="coupon">
    <fo:page-sequence master-reference="adpage">
      <fo:flow flow-name="xsl-region-body">
        <fo:block keep-together.within-page="always">
          <xsl:if test="string-length(title) &gt; 0">
            <fo:block xsl:use-attribute-sets="adtitle">
              <xsl:apply-templates select="title" mode="force"/>
            </fo:block>
          </xsl:if>
          <fo:block>
            <xsl:apply-templates/>
          </fo:block>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>

  <xsl:template match="ad">
    <fo:block keep-with-previous="always">
      <xsl:attribute name="space-before">24pt</xsl:attribute>
      <fo:block xsl:use-attribute-sets="adtitle">
        <xsl:apply-templates select="title" mode="force"/>
      </fo:block>
      <fo:table width="100%">
        <fo:table-column column-number="2" column-width="2in"/>
        <fo:table-body text-indent="0pt">
          <fo:table-row>
            <fo:table-cell display-align="before">
              <fo:block xsl:use-attribute-sets="adcontent" padding-right="2em">
                <xsl:apply-templates select="blurb"/>

                <fo:block font-weight="bold" space-before="6pt">
                  <xsl:apply-templates select="booktitle"/>
                  <xsl:if test="string-length(booksubtitle) &gt; 0">
                    <xsl:text>: </xsl:text>
                    <xsl:apply-templates select="booksubtitle"/>
                  </xsl:if>
                </fo:block>
                <fo:block>
                  <xsl:apply-templates select="author-list"/>
                </fo:block>
                <fo:block>
                  <xsl:text>(</xsl:text>
                  <xsl:apply-templates select="pagecount"/>
                  <xsl:text> pages) </xsl:text>
                  <fo:inline font-size="smaller">
                    <xsl:text>ISBN</xsl:text>
                  </fo:inline>
                  <xsl:text>: </xsl:text>
                  <xsl:apply-templates select="isbn13"/>
                  <xsl:text>. $</xsl:text>
                  <xsl:apply-templates select="price"/>
                </fo:block>
                <fo:block>
                  <xsl:call-template name="external-link">
                    <xsl:with-param name="url">
                      <xsl:text>https://pragprog.com/book/</xsl:text>
                      <xsl:value-of select="bookcode"/>
                    </xsl:with-param>
                    <xsl:with-param name="text">https:<xsl:call-template name="double-slash"/>pragprog.com/book/<xsl:value-of select="bookcode"/></xsl:with-param>
                  </xsl:call-template>
                </fo:block>
              </fo:block>
            </fo:table-cell>
            <fo:table-cell padding-left="18pt" display-align="before">
              <fo:block line-stacking-strategy="max-height"
              line-height="0pt"
              margin="0pt 0pt 6pt 0pt" width="100%">
              <xsl:variable name="cover-path">
                <xsl:call-template name="cover-image"/>
              </xsl:variable>
              <fo:external-graphic
              border-width="1.2pt"
              border-style="solid"
              border-color="{$color.ad-cover-border}"
              src="url({$cover-path})"
              content-height="2in"
              scaling="uniform"/>
            </fo:block>
          </fo:table-cell>
        </fo:table-row>
      </fo:table-body>
    </fo:table>
  </fo:block>
</xsl:template>

<xsl:template match="bookcode"/>

<xsl:template match="blurb">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="booktitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="booksubtitle">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="author-list">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="pagecount">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="person">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="name">
  <xsl:apply-templates/>
  <xsl:if test="parent::person/following-sibling::person/name">
    <xsl:text>, </xsl:text>
  </xsl:if>
</xsl:template>

<xsl:template match="isbn13">
  <xsl:apply-templates/>
</xsl:template>

<xsl:template match="price">
  <xsl:apply-templates/>
</xsl:template>


<xsl:template name="draw-back-page">
  <xsl:call-template name="back-page-heading">
    <xsl:with-param name="title">The Pragmatic Bookshelf</xsl:with-param>
  </xsl:call-template>
  <xsl:call-template name="back-page-para">
    <xsl:with-param name="content">
      The Pragmatic Bookshelf features books written by professional developers
      for professional developers. The titles continue the well-known Pragmatic
      Programmer style and continue to garner awards and rave
      reviews. As development gets more and more difficult, the
      Pragmatic Programmers will be there with more titles and
      products to help you stay on top of your game.
    </xsl:with-param>
  </xsl:call-template>

  <xsl:call-template name="back-page-heading">
    <xsl:with-param name="title">Visit Us Online</xsl:with-param>
  </xsl:call-template>

  <xsl:call-template name="visit-chunk">
    <xsl:with-param name="title">This Book’s Home Page</xsl:with-param>
    <xsl:with-param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com/book/<xsl:value-of select="$book-code"/></xsl:with-param>
    <xsl:with-param name="description">
      Source code from this book, errata, and other resources. Come give us feedback, too!
    </xsl:with-param>
  </xsl:call-template>

  <!--    <xsl:call-template name="visit-chunk">
    <xsl:with-param name="title">Register for Updates</xsl:with-param>
    <xsl:with-param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com/updates</xsl:with-param>
    <xsl:with-param name="description">
    Be notified when updates and new books become available.
    </xsl:with-param>
  </xsl:call-template> -->

  <!--    <xsl:call-template name="visit-chunk">
    <xsl:with-param name="title">Join the Community</xsl:with-param>
    <xsl:with-param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com/community</xsl:with-param>
    <xsl:with-param name="description">
    Read our weblogs, join our online discussions, participate in
    our mailing list, interact with our wiki, and benefit from the
    experience of other Pragmatic Programmers.
    </xsl:with-param>
  </xsl:call-template> -->

  <xsl:call-template name="visit-chunk">
    <xsl:with-param name="title">Keep Up-to-Date</xsl:with-param>
    <xsl:with-param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com</xsl:with-param>
    <xsl:with-param name="description">
      Join our announcement mailing list (low volume) or follow us on Twitter @pragprog for new titles, sales, coupons, hot tips, and more.
    </xsl:with-param>
  </xsl:call-template>

  <xsl:call-template name="visit-chunk">
    <xsl:with-param name="title">New and Noteworthy</xsl:with-param>
    <xsl:with-param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com/news</xsl:with-param>
    <xsl:with-param name="description">
      Check out the latest Pragmatic developments, new titles, and other offerings.
    </xsl:with-param>
  </xsl:call-template>

  <xsl:call-template name="backpage-buy-the-book"/>  <!--- in _targets/... -->


  <xsl:call-template name="back-page-heading">
    <xsl:with-param name="title">Contact Us</xsl:with-param>
  </xsl:call-template>

  <xsl:call-template name="contact-us-table"/>
</xsl:template>

<xsl:template name="back-page-heading">
  <xsl:param name="title"/>
  <fo:block xsl:use-attribute-sets="adpagetitle">
    <xsl:attribute name="margin-top">
      <xsl:choose>
        <xsl:when test="$target.for-screen = 'no'">6pt</xsl:when>
        <xsl:otherwise>16pt</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
    <xsl:value-of select="$title"/>
  </fo:block>
</xsl:template>

<xsl:template name="back-page-para">
  <xsl:param name="content"/>
  <fo:block>
    <xsl:value-of select="$content"/>
  </fo:block>
</xsl:template>


<xsl:template name="visit-chunk">
  <xsl:param name="title"/>
  <xsl:param name="url"/>
  <xsl:param name="description"/>

  <fo:block xsl:use-attribute-sets="backmatter-sect2">
    <xsl:value-of select="$title"/>
  </fo:block>

  <fo:block>
    <xsl:call-template name="external-link">
      <xsl:with-param name="url">
        <xsl:value-of select="$url"/>
      </xsl:with-param>
      <xsl:with-param name="text">
        <xsl:copy-of select="$url"/>
      </xsl:with-param>
    </xsl:call-template>
  </fo:block>
  <fo:block space-after="4pt">
    <xsl:value-of select="$description"/>
  </fo:block>
</xsl:template>


<xsl:template name="contact-us">
  <xsl:param name="for"/>
  <xsl:param name="url"/>
  <xsl:param name="other"/>
  <xsl:variable name="padding-top">
    <xsl:choose>
      <xsl:when test="$target.for-screen = 'no'">2pt</xsl:when>
      <xsl:otherwise>4pt</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <fo:table-row>
    <fo:table-cell padding-top="{$padding-top}">
      <fo:block>
        <xsl:value-of select="$for"/><xsl:text>:</xsl:text>
      </fo:block>
    </fo:table-cell>
    <fo:table-cell padding-top="{$padding-top}">
      <fo:block>
        <xsl:if test="$url">
          <xsl:call-template name="external-link">
            <xsl:with-param name="url">
              <xsl:value-of select="$url"/>
            </xsl:with-param>
            <xsl:with-param name="text">
              <xsl:copy-of select="$url"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:if>
        <xsl:if test="$other">
          <xsl:value-of select="$other"/>
        </xsl:if>
      </fo:block>
    </fo:table-cell>
  </fo:table-row>

</xsl:template>


<xsl:template name="contact-us-table">
  <fo:table>
    <fo:table-column column-number="1" column-width="1.2in"/>
    <fo:table-body>
      <xsl:call-template name="contact-us">
        <xsl:with-param name="for">Online Orders</xsl:with-param>
        <xsl:with-param name="url">https:<xsl:call-template name="double-slash"/>pragprog.com/catalog</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="contact-us">
        <xsl:with-param name="for">Customer Service</xsl:with-param>
        <xsl:with-param name="url">support@pragprog.com</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="contact-us">
        <xsl:with-param name="for">International Rights</xsl:with-param>
        <xsl:with-param name="url">translations@pragprog.com</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="contact-us">
        <xsl:with-param name="for">Academic Use</xsl:with-param>
        <xsl:with-param name="url">academic@pragprog.com</xsl:with-param>
      </xsl:call-template>

      <xsl:call-template name="contact-us">
        <xsl:with-param name="for">Write for Us</xsl:with-param>
        <xsl:with-param name="url">http:<xsl:call-template name="double-slash"/>write-for-us.pragprog.com</xsl:with-param>
      </xsl:call-template>


      <!--<xsl:call-template name="contact-us">
        <xsl:with-param name="for">Or Call</xsl:with-param>
        <xsl:with-param name="other">+1 800-699-7764</xsl:with-param>
      </xsl:call-template>-->
    </fo:table-body>
  </fo:table>
  </xsl:template>

<xsl:template match="backsheet"/>

<!--   <xsl:template match="permissions"/> -->


<!--

  <xsl:template match="sect1" mode="backmatter">
  <xsl:apply-templates mode="backmatter"/>
  </xsl:template>

  <xsl:template match="sect2" mode="backmatter">
  <xsl:apply-templates mode="backmatter"/>
  </xsl:template>

  <xsl:template match="sect1/title" mode="backmatter">
  <fo:block xsl:use-attribute-sets="adpagetitle">
  <xsl:apply-templates mode="backmatter"/>
  </fo:block>
  </xsl:template>

  <xsl:template match="sect2/title" mode="backmatter">
  <fo:block xsl:use-attribute-sets="backmatter-sect2">
  <xsl:apply-templates mode="backmatter"/>
  </fo:block>
  </xsl:template>

  <xsl:template match="table" mode="backmatter">
  <xsl:call-template name="table">
  <xsl:with-param name="backmatter" select="'yes'"/>
  </xsl:call-template>
  </xsl:template>

  <xsl:template match="url" mode="backmatter">
  <fo:inline>
  <xsl:call-template name="external-link">
  <xsl:with-param name="url">
  <xsl:apply-templates/>
  </xsl:with-param>
  <xsl:with-param name="text">
  <xsl:apply-templates/>
  </xsl:with-param>
  </xsl:call-template>
  </fo:inline>
  </xsl:template>

  <xsl:template match="p" mode="backmatter">
  <fo:block>
  <xsl:call-template name="add-or-generate-id"/>
  <xsl:call-template name="add-id"/>
  <xsl:apply-templates/>
  </fo:block>
  </xsl:template>
-->

</xsl:stylesheet>
