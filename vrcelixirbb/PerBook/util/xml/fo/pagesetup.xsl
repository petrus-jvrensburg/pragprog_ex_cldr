<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
version="2.0">

<xsl:attribute-set name="all-pages">
  <xsl:attribute name="page-width">   <xsl:value-of select="$page.width"/></xsl:attribute>
  <xsl:attribute name="page-height">  <xsl:value-of select="$page.height"/></xsl:attribute>
  <xsl:attribute name="margin-top">   <xsl:value-of select="$page.margin.top"/></xsl:attribute>
  <!--    <xsl:attribute name="margin-bottom"><xsl:value-of select="$page.margin.bottom"/></xsl:attribute> -->
</xsl:attribute-set>

<xsl:attribute-set name="praise-pages">
  <xsl:attribute name="page-width">   <xsl:value-of select="$page.width"/></xsl:attribute>
  <xsl:attribute name="page-height">  <xsl:value-of select="$page.height"/></xsl:attribute>
  <xsl:attribute name="margin-top">   <xsl:value-of select="$praise.margin.top"/></xsl:attribute>
  <xsl:attribute name="margin-bottom"><xsl:value-of select="$praise.margin.bottom"/></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="odd-page">
  <xsl:attribute name="margin-left"> <xsl:value-of select="$page.margin.inner"/></xsl:attribute>
  <xsl:attribute name="margin-right"><xsl:value-of select="$page.margin.outer" /></xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="even-page">
  <xsl:attribute name="margin-left">
    <xsl:choose>
      <xsl:when test="$target.recto-verso-headings='yes'"> 
        <xsl:value-of select="$page.margin.outer"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page.margin.inner" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
  <xsl:attribute name="margin-right">
    <xsl:choose>
      <xsl:when test="$target.recto-verso-headings='yes'"> 
        <xsl:value-of select="$page.margin.inner" />
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$page.margin.outer"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="normal-header">
  <xsl:attribute name="extent">       <xsl:value-of select="$page.header.extent"/></xsl:attribute>
  <xsl:attribute name="padding">      0pt 0pt 0pt 0pt</xsl:attribute>
  <xsl:attribute name="display-align">after</xsl:attribute>
  <xsl:attribute name="precedence">   false</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="normal-footer">
  <xsl:attribute name="extent"><xsl:value-of select="$page.footer.extent"/></xsl:attribute> 
  <xsl:attribute name="padding">0pt</xsl:attribute>
  <xsl:attribute name="precedence">false</xsl:attribute>
</xsl:attribute-set>

<xsl:attribute-set name="standard-region">
  <xsl:attribute name="margin-top">
    <xsl:value-of select="$page.header.extent.number + 16"/>pt
  </xsl:attribute>
  <xsl:attribute name="margin-bottom">
    <xsl:value-of select="$page.footer.extent"/>
  </xsl:attribute>

  <xsl:attribute name="column-count">1</xsl:attribute>
  <xsl:attribute name="padding">0pt 0pt</xsl:attribute>
</xsl:attribute-set>

<xsl:template name="setup.pagemasters">
  <fo:layout-master-set>


    <!-- COVER -->

    <fo:simple-page-master master-name="cover-page"
    page-width="{$page.width}"
    page-height="{$page.height}"
    margin="0pt"
    >
    <fo:region-body margin="0pt"
    padding="0pt"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="cover">
    <fo:repeatable-page-master-reference master-reference="cover-page"/>
  </fo:page-sequence-master>  

  <!-- PRAISE -->

  <fo:simple-page-master master-name="praise-odd-page" xsl:use-attribute-sets="praise-pages odd-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="praise-even-page" xsl:use-attribute-sets="praise-pages even-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region" />
  </fo:simple-page-master>

  <!-- 
    this is a hack—use use the blank region to display the "THis Page Intentionally left blank" image
    on blank pages. It's only set up for _target == screen
  -->
  <fo:simple-page-master master-name="blank-page" xsl:use-attribute-sets="all-pages">
    <fo:region-body /> <!-- not used -->
    <fo:region-start  region-name="blank" extent="{$page.width}"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="praise">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference odd-or-even="odd"  master-reference="praise-odd-page"/>
      <fo:conditional-page-master-reference blank-or-not-blank="blank" master-reference="blank-page"/>
      <fo:conditional-page-master-reference odd-or-even="even" master-reference="praise-even-page"/>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>  


  <!-- TITLE -->

  <fo:simple-page-master master-name="title-odd-page" xsl:use-attribute-sets="all-pages odd-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region"/>
    <fo:region-after region-name="imprint-name" extent="1in"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="title-odd-page-no-imprint" xsl:use-attribute-sets="all-pages odd-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="title-even-page" xsl:use-attribute-sets="all-pages even-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="title-even-page-extract" xsl:use-attribute-sets="all-pages even-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region"/>
    <fo:region-after region-name="imprint-name" extent="1in"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="title">
    <fo:single-page-master-reference  master-reference="title-odd-page"/>
    <xsl:choose>
      <xsl:when test="$target.recto-verso-headings='yes'">
        <fo:single-page-master-reference  master-reference="title-even-page"/>
      </xsl:when>
      <xsl:otherwise>
        <fo:single-page-master-reference  master-reference="title-odd-page-no-imprint"/>
        <!--   <xsl:if test="$extracts = 'yes'">
          <fo:single-page-master-reference  master-reference="blank-page" />
        </xsl:if>-->
      </xsl:otherwise>
    </xsl:choose>
  </fo:page-sequence-master>  

  <fo:page-sequence-master master-name="extract-title">
    <fo:repeatable-page-master-alternatives maximum-repeats="1">
      <fo:conditional-page-master-reference master-reference="title-even-page-extract" odd-or-even="odd" page-position="first" blank-or-not-blank="not-blank"/>
      <xsl:if test="$extracts = 'yes'">
        <fo:conditional-page-master-reference odd-or-even="any"
        page-position="last" blank-or-not-blank="blank" master-reference="blank-page" />
      </xsl:if>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>  


  <!-- verso/reco spread -->

  <fo:page-sequence-master master-name="spread">
    <fo:repeatable-page-master-reference master-reference="title-even-page"/>
  </fo:page-sequence-master>  



  <!--- PART -->

  <fo:simple-page-master master-name="part-odd-page" xsl:use-attribute-sets="all-pages odd-page">
    <fo:region-body xsl:use-attribute-sets="standard-region"/>
    <fo:region-before region-name="odd-header" xsl:use-attribute-sets="normal-header"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="part-even-page" xsl:use-attribute-sets="all-pages even-page">
    <fo:region-body xsl:use-attribute-sets="standard-region" />
    <fo:region-before region-name="even-header" xsl:use-attribute-sets="normal-header"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="part-first-page" xsl:use-attribute-sets="all-pages odd-page">
    <fo:region-body xsl:use-attribute-sets="standard-region"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="part">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference page-position="first" odd-or-even="any" master-reference="part-first-page"/>
      <fo:conditional-page-master-reference odd-or-even="odd"  master-reference="part-odd-page" page-position="rest"/>
      <fo:conditional-page-master-reference odd-or-even="even" master-reference="part-even-page" page-position="rest"/>
      <fo:conditional-page-master-reference page-position="last" blank-or-not-blank="not-blank" odd-or-even="odd" master-reference="part-odd-page"/>
      <fo:conditional-page-master-reference page-position="last" blank-or-not-blank="not-blank" odd-or-even="even" master-reference="part-even-page"/>
      <xsl:if test="$target.recto-verso-headings='yes' or $booktype='pguide'"><!-- paper -->
        <fo:conditional-page-master-reference page-position="last" blank-or-not-blank="blank" master-reference="blank-page"/>
      </xsl:if> 
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>

  <fo:page-sequence-master master-name="long-intro">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference odd-or-even="odd"  master-reference="chapter-odd-page" page-position="first"/>
      <fo:conditional-page-master-reference odd-or-even="odd"  master-reference="chapter-odd-page" page-position="rest"/>
      <fo:conditional-page-master-reference odd-or-even="even" master-reference="chapter-even-page" page-position="rest"/>
      <fo:conditional-page-master-reference page-position="last" blank-or-not-blank="not-blank" odd-or-even="odd" master-reference="chapter-odd-page"/>
      <fo:conditional-page-master-reference page-position="last" blank-or-not-blank="not-blank" odd-or-even="even" master-reference="chapter-even-page"/>
      <xsl:if test="$target.recto-verso-headings='yes' or $booktype='pguide'"><!-- paper -->
        <fo:conditional-page-master-reference page-position="last" blank-or-not-blank="blank" master-reference="blank-page"/>
      </xsl:if> 
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>



  <!--- CHAPTER -->

  <fo:simple-page-master master-name="chapter-first-page" 
  xsl:use-attribute-sets="all-pages" 
  margin-left="{$page-master-horizontal-margins}" 
  margin-right="{$page-master-horizontal-margins}">
  <fo:region-body xsl:use-attribute-sets="standard-region" 
  margin="0in {$region-body-offset-outer} 0in {$region-body-offset-inner}"/>
  <fo:region-after region-name="footer"     
  xsl:use-attribute-sets="normal-footer"/>
</fo:simple-page-master>

<fo:simple-page-master master-name="chapter-first-page-even" 
xsl:use-attribute-sets="all-pages" 
margin-left="{$page-master-horizontal-margins}" 
margin-right="{$page-master-horizontal-margins}">
<fo:region-body xsl:use-attribute-sets="standard-region" 
margin="0in {$region-body-offset-inner} 0in {$region-body-offset-outer}"/>
<fo:region-after region-name="footer"     
xsl:use-attribute-sets="normal-footer"/>
      </fo:simple-page-master>

      <fo:simple-page-master master-name="chapter-odd-page"  
      xsl:use-attribute-sets="all-pages" 
      margin-left="{$page-master-horizontal-margins}" 
      margin-right="{$page-master-horizontal-margins}">
      <fo:region-body xsl:use-attribute-sets="standard-region" 
      margin="0in {$region-body-offset-outer} 0in {$region-body-offset-inner}"/>
      <fo:region-before region-name="odd-header" 
      xsl:use-attribute-sets="normal-header"/>
      <fo:region-after  region-name="footer"     
      xsl:use-attribute-sets="normal-footer"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="chapter-even-page" 
    xsl:use-attribute-sets="all-pages" 
    margin-left="{$page-master-horizontal-margins}" 
    margin-right="{$page-master-horizontal-margins}">
    <fo:region-body  xsl:use-attribute-sets="standard-region" 
    margin="0in {$region-body-offset-inner} 0in {$region-body-offset-outer}"/>
    <fo:region-before region-name="even-header" 
    xsl:use-attribute-sets="normal-header"/>
    <fo:region-after  region-name="footer"      
    xsl:use-attribute-sets="normal-footer"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="chapter">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference
      page-position="first" odd-or-even="odd" master-reference="chapter-first-page"/>
      <fo:conditional-page-master-reference
      page-position="rest" odd-or-even="odd" master-reference="chapter-odd-page"/>
      <fo:conditional-page-master-reference
      page-position="first" odd-or-even="even" master-reference="chapter-first-page-even"/>
      <fo:conditional-page-master-reference
      page-position="rest" odd-or-even="even" master-reference="chapter-even-page"/>

      <xsl:choose>
        <xsl:when test="$target.recto-verso-headings='yes'"><!-- paper -->
          <fo:conditional-page-master-reference
          page-position="last" 
          odd-or-even="odd" 
          master-reference="chapter-odd-page" 
          blank-or-not-blank="not-blank"/>
          <fo:conditional-page-master-reference
          page-position="last" 
          odd-or-even="even" 
          master-reference="chapter-even-page" 
          blank-or-not-blank="not-blank" />
          <fo:conditional-page-master-reference
          page-position="last" 
          blank-or-not-blank="blank" 
          master-reference="blank-page" />
        </xsl:when>
        <xsl:otherwise>
          <fo:conditional-page-master-reference
          page-position="last" odd-or-even="odd" master-reference="chapter-odd-page" blank-or-not-blank="not-blank"/>
          <fo:conditional-page-master-reference
          page-position="last" odd-or-even="even" master-reference="chapter-even-page" blank-or-not-blank="not-blank"/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>  


  <!-- Contents -->

  <fo:simple-page-master master-name="contents-first-page" xsl:use-attribute-sets="all-pages odd-page">
    <fo:region-body xsl:use-attribute-sets="standard-region"/>
    <fo:region-after region-name="footer"     xsl:use-attribute-sets="normal-footer"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="contents-first-page-even" xsl:use-attribute-sets="all-pages even-page">
    <fo:region-body xsl:use-attribute-sets="standard-region"/>
    <fo:region-after region-name="footer"     xsl:use-attribute-sets="normal-footer"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="contents-odd-page" xsl:use-attribute-sets="all-pages odd-page">
    <fo:region-body xsl:use-attribute-sets="standard-region"/>
    <fo:region-before region-name="odd-header" xsl:use-attribute-sets="normal-header"/>
    <fo:region-after  region-name="footer"     xsl:use-attribute-sets="normal-footer"/>
  </fo:simple-page-master>

  <fo:simple-page-master master-name="contents-even-page" xsl:use-attribute-sets="all-pages even-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region"/>
    <fo:region-before region-name="even-header" xsl:use-attribute-sets="normal-header"/>
    <fo:region-after  region-name="footer"      xsl:use-attribute-sets="normal-footer"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="contents">
    <fo:repeatable-page-master-alternatives>
      <fo:conditional-page-master-reference
      page-position="first" odd-or-even="odd" master-reference="contents-first-page"/>
      <fo:conditional-page-master-reference
      page-position="rest" odd-or-even="odd" master-reference="contents-odd-page"/>
      <xsl:choose>
        <xsl:when test="$target.recto-verso-headings='yes'">
          <fo:conditional-page-master-reference
          page-position="rest" odd-or-even="even" master-reference="contents-even-page"/>
        </xsl:when>
        <xsl:otherwise>
          <fo:conditional-page-master-reference
          page-position="first" odd-or-even="even" master-reference="contents-first-page"/>
          <fo:conditional-page-master-reference
          page-position="rest" odd-or-even="even" master-reference="contents-odd-page"/>
        </xsl:otherwise>
      </xsl:choose>
      <fo:conditional-page-master-reference
      page-position="last" master-reference="blank-page" blank-or-not-blank="blank"/>
      <fo:conditional-page-master-reference
      page-position="last" master-reference="contents-even-page" blank-or-not-blank="not-blank"/>

    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>  


  <!--- Index -->

  <fo:simple-page-master master-name="index-first-page-odd" 
  xsl:use-attribute-sets="all-pages odd-page"
  >

  <fo:region-body xsl:use-attribute-sets="standard-region"/>

  <fo:region-before region-name="index-first-page-header"
  extent="0in"
  padding="0pt"
  display-align="after"
  precedence="false"/>
</fo:simple-page-master>


<fo:simple-page-master master-name="index-first-page-even" 
xsl:use-attribute-sets="all-pages even-page"
>

<fo:region-body xsl:use-attribute-sets="standard-region"/>

<fo:region-before region-name="index-first-page-header"
extent="0in"
padding="0pt"
display-align="after"
precedence="false"/>
      </fo:simple-page-master>


      <fo:simple-page-master master-name="index-odd-page" 
      xsl:use-attribute-sets="all-pages odd-page"
      >

      <fo:region-body xsl:use-attribute-sets="standard-region" column-count="3" />
      <fo:region-before region-name="odd-header" xsl:use-attribute-sets="normal-header"/>
    </fo:simple-page-master>

    <fo:simple-page-master master-name="index-even-page"
    xsl:use-attribute-sets="all-pages even-page">
    <fo:region-body  xsl:use-attribute-sets="standard-region" column-count="3"/>

    <fo:region-before region-name="even-header" xsl:use-attribute-sets="normal-header"/>
  </fo:simple-page-master>

  <fo:page-sequence-master master-name="index">
    <fo:repeatable-page-master-alternatives>

      <fo:conditional-page-master-reference
      page-position="first" odd-or-even="odd" master-reference="index-first-page-odd"/>

      <fo:conditional-page-master-reference
      page-position="first" odd-or-even="even" master-reference="index-first-page-even"/>

      <fo:conditional-page-master-reference
      page-position="rest" odd-or-even="odd" master-reference="index-odd-page"/>

      <fo:conditional-page-master-reference
      page-position="rest" odd-or-even="even" master-reference="index-even-page"/>


      <fo:conditional-page-master-reference
      page-position="last" odd-or-even="odd" master-reference="index-odd-page"/>

      <fo:conditional-page-master-reference
      page-position="last" odd-or-even="even" master-reference="index-even-page"/>

    </fo:repeatable-page-master-alternatives>
  </fo:page-sequence-master>  



  <!-- Ad pages -->

  <fo:simple-page-master master-name="ad-odd-page" xsl:use-attribute-sets="all-pages" margin-right="{$page.margin.outer}" margin-left="{$page.margin.inner}"> 

    <fo:region-body/>

  </fo:simple-page-master>

  <fo:simple-page-master master-name="ad-even-page" xsl:use-attribute-sets="all-pages" margin-right="{$page.margin.inner}" margin-left="{$page.margin.outer}">

    <fo:region-body/>

  </fo:simple-page-master>

  <fo:page-sequence-master master-name="adpage">

    <fo:repeatable-page-master-alternatives> 
      <fo:conditional-page-master-reference
      page-position="any" odd-or-even="odd" master-reference="ad-odd-page"/>
      <fo:conditional-page-master-reference
      page-position="any" odd-or-even="even" master-reference="ad-even-page"/>
      <fo:conditional-page-master-reference master-reference="ad-odd-page" page-position="last" odd-or-even="odd"/>
    </fo:repeatable-page-master-alternatives>

  </fo:page-sequence-master>  


  <!-- Back Page -->


  <fo:simple-page-master master-name="back-last-page" 
  xsl:use-attribute-sets="all-pages even-page">
  <fo:region-body xsl:use-attribute-sets="standard-region"/>
</fo:simple-page-master>

<fo:page-sequence-master master-name="backpage">
  <fo:repeatable-page-master-alternatives>

    <fo:conditional-page-master-reference
    page-position="any" odd-or-even="even" master-reference="back-last-page"/>

  </fo:repeatable-page-master-alternatives>
</fo:page-sequence-master>  

<!-- Task Pages -->


<fo:simple-page-master master-name="task-first-page" 
xsl:use-attribute-sets="all-pages even-page">
<fo:region-body xsl:use-attribute-sets="standard-region"/>
<fo:region-before region-name="even-header" xsl:use-attribute-sets="normal-header"/>
<fo:region-after  region-name="footer"     xsl:use-attribute-sets="normal-footer"/>
      </fo:simple-page-master>

      <fo:simple-page-master master-name="task-last-page" 
      xsl:use-attribute-sets="all-pages odd-page">
      <fo:region-body xsl:use-attribute-sets="standard-region"/>
      <fo:region-before region-name="odd-header" xsl:use-attribute-sets="normal-header"/>
      <fo:region-after  region-name="footer"     xsl:use-attribute-sets="normal-footer"/>
    </fo:simple-page-master>

    <fo:page-sequence-master master-name="task">
      <fo:repeatable-page-master-alternatives>

        <fo:conditional-page-master-reference
        page-position="first" odd-or-even="even" master-reference="task-first-page"/>

        <fo:conditional-page-master-reference
        page-position="any" odd-or-even="odd" master-reference="task-last-page"/>
        <fo:conditional-page-master-reference
        page-position="rest"  blank-or-not-blank="not-blank" odd-or-even="even" master-reference="task-last-page"/>
        <fo:conditional-page-master-reference
        page-position="last" blank-or-not-blank="not-blank" odd-or-even="even" master-reference="task-last-page"/>

        <fo:conditional-page-master-reference
        page-position="last" blank-or-not-blank="blank" odd-or-even="even" master-reference="blank-page"/>
        <fo:conditional-page-master-reference
        page-position="last" blank-or-not-blank="blank" odd-or-even="odd" master-reference="blank-page"/>

      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>  



  </fo:layout-master-set>

</xsl:template>
</xsl:stylesheet>
