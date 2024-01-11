<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
		xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version="2.0">            


  <xsl:include href="fo/layout-parameters.xsl"/>  <!-- page width/height etc -->
 
  <xsl:include href="../../../Common/xml/lib/pml_only_tags.xsl"/>
  <xsl:include href="fo/backmatter.xsl"/> 
  <xsl:include href="fo/betapage.xsl"/>
  <xsl:include href="fo/block_elements.xsl"/>
  <xsl:include href="fo/bookmarks.xsl"/>
  <xsl:include href="fo/code.xsl"/>
  <xsl:include href="fo/contents-page.xsl"/>
  <xsl:include href="fo/copyright-page-text.xsl"/>
  <xsl:include href="fo/fonts.xsl"/>
  <xsl:include href="fo/floats.xsl"/>
  <xsl:include href="fo/indexing.xsl"/>
  <xsl:include href="fo/inline_elements.xsl"/>
  <xsl:include href="fo/lists.xsl"/>
  <xsl:include href="fo/mackeys.xsl"/>
  <xsl:include href="fo/pagesetup.xsl"/>
  <xsl:include href="fo/pragprog-stuff.xsl"/>
  <xsl:include href="fo/praisepage.xsl"/>
  <xsl:include href="fo/sectioning.xsl"/>
  <xsl:include href="fo/tables.xsl"/>
  <xsl:include href="fo/text-escapes.xsl"/>
  <xsl:include href="fo/titlepage.xsl"/>
  <xsl:include href="fo/util.xsl"/>
  <xsl:include href="fo/xref.xsl"/>
  <xsl:include href="fo/extract.xsl"/>
  <xsl:include href="pocket_guide.xsl"/>

  <xsl:attribute-set name="root.properties">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$body.fontset"/>
    </xsl:attribute>
    <xsl:attribute name="font-size">
      <xsl:value-of select="$body.font.size"/>
    </xsl:attribute>
    <xsl:attribute name="text-align">
      <xsl:value-of select="$alignment"/>
    </xsl:attribute>
    <xsl:attribute name="line-height">
      <xsl:value-of select="$line-height"/>
    </xsl:attribute>
    <xsl:attribute name="line-stacking-strategy">font-height</xsl:attribute>
    <xsl:attribute name="font-selection-strategy">character-by-character</xsl:attribute>
    <xsl:attribute name="line-height-shift-adjustment">disregard-shifts</xsl:attribute>
    <xsl:attribute name="hyphenate">true</xsl:attribute>
    <xsl:attribute name="rx:merge-subsequent-page-numbers">true</xsl:attribute>
  </xsl:attribute-set>                     
  
  
  
  <!-- The list of top-level tags that we can generate output from -->
  
  <xsl:variable
      name="root.elements"
      select="' appendix book chapter recipe '"/> 
  
  <xsl:variable name="recipetitle">
  <!--   <xsl:choose>
      <xsl:when test="string-length(//book/options/recipetitle/@name) &gt; 0 ">
        <xsl:value-of select="//book/options/recipetitle/@name"/>
      </xsl:when>
      <xsl:otherwise>Recipe</xsl:otherwise>
      </xsl:choose>   -->
    <xsl:choose>
      <xsl:when test="string-length(//book/options/recipetitle/@name) &gt; 0 ">
        <xsl:value-of select="//book/options/recipetitle/@name"/>
      </xsl:when>
      <xsl:otherwise>Recipe</xsl:otherwise>
      </xsl:choose>
  </xsl:variable>

  <xsl:variable name="tasktitle">
    <xsl:choose>
      <xsl:when test="string-length(//book/options/tasktitle/@name) &gt; 0 ">
        <xsl:value-of select="//book/options/tasktitle/@name"/>
      </xsl:when>
      <xsl:otherwise>Task</xsl:otherwise>
      </xsl:choose>
  </xsl:variable>
  
  <xsl:variable name="recipe.padding">
    <xsl:value-of select="/book/options/recipepadding/@padded"/>
  </xsl:variable>
   <xsl:variable name="omit.chapnums">
     <xsl:choose>
       <xsl:when test="//book/options/omitchapnums">yes</xsl:when>
       <xsl:otherwise>no</xsl:otherwise>
     </xsl:choose>
  </xsl:variable>


  <xsl:template match="/">   
    <xsl:variable name="document.element" select="*[1]"/>
    <xsl:choose>
      <xsl:when test="not(contains($root.elements,
		      concat(' ', local-name($document.element), ' ')))">
	<xsl:message terminate="yes">
	  <xsl:text>ERROR: You can only format one of: </xsl:text>
	  <xsl:value-of select="$root.elements"/>
	</xsl:message>
      </xsl:when>
      <xsl:when test="descendant::imagedata[@width and not(contains(@width,'%')) and not(@width = 'fit')]">
        <xsl:message terminate="yes">IMAGEDATA WIDTH ERROR: The width attribute for imagedata requires the value 'fit' or a percentage value with the % symbol. Referenced images are:
	<xsl:for-each select="descendant::imagedata[@width and not(contains(@width,'%')) and not(@width = 'fit')]">
	  <xsl:value-of select="@fileref"/>.
	</xsl:for-each>
	</xsl:message>
      </xsl:when>
      <xsl:otherwise>
	<xsl:apply-templates select="/" mode="process.root"/>
      </xsl:otherwise>
    </xsl:choose>                
  </xsl:template>
  



  <xsl:template match="book" mode="process.root">
    <fo:root xsl:use-attribute-sets="root.properties">  
      <xsl:if test="$target.for-screen = 'no'">
        <xsl:choose>
          <xsl:when test="$color = 'yes'">
            <xsl:processing-instruction name="xep-pdf-icc-profile">url('../../../util/Photoshop5DefaultCMYK.icc')</xsl:processing-instruction>
          </xsl:when>
          <xsl:otherwise>
            <xsl:processing-instruction name="xep-pdf-icc-profile">url('../../../util/Gray_Gamma_22.icc')</xsl:processing-instruction>
          </xsl:otherwise>
        </xsl:choose>
        
      </xsl:if>
      <rx:meta-info>
	<rx:meta-field name="copyright" value="Pragmatic Bookshelf"/>
	<rx:meta-field name="creator" value="Pragmatic Bookshelf"/>
	<rx:meta-field name="title">
	  <xsl:attribute name="value">
	    <xsl:value-of select="/book/bookinfo/booktitle"/>
	  </xsl:attribute>
	</rx:meta-field>
	<rx:meta-field name="author">
	  <xsl:attribute name="value">
	    <xsl:for-each select="/book/bookinfo/authors/person">
	      <xsl:apply-templates select="./name"/>
	      <xsl:if test="position() &lt; last()">
		<xsl:text>, </xsl:text>
	      </xsl:if>
	    </xsl:for-each>
	  </xsl:attribute>
	</rx:meta-field>
      </rx:meta-info>
      
      
      <xsl:call-template name="setup.pagemasters"/>

      <xsl:if test="$target.for-screen='yes' or $sitb = 'yes'">
	<xsl:call-template name="create-bookmarks"/>
      </xsl:if>
     
     <xsl:if test="$sitb='yes'">
        <xsl:result-document href="{'isbn.txt'}" indent="no" method="text">
          <xsl:variable name="isbn">
            <xsl:value-of select="//book/bookinfo/isbn13"/>
          </xsl:variable>
          <xsl:variable name="no-dashes">
            <xsl:value-of select="translate($isbn,'1234567890-','1234567890')"/>
          </xsl:variable>
          <xsl:value-of select="concat($no-dashes,'.pdf')"/>
        </xsl:result-document>
     </xsl:if>
     
      <xsl:if test="$extracts = 'yes'">
        <xsl:call-template name="extracts-cover"/>
      </xsl:if>

      <xsl:call-template name="draw-cover"/>

      <xsl:if test="bookinfo/@in-beta='yes'">
	<xsl:call-template name="do-beta-page"/>
      </xsl:if>

      <xsl:if test="frontmatter/praisepage">
	<xsl:call-template name="do-praise-page"/>
      </xsl:if>

      <xsl:call-template name="title.title-page"/>
 
      <xsl:if test="frontmatter/dedication">
        <xsl:call-template name="do-dedication-page"/>
      </xsl:if>

      <xsl:call-template name="contents-page"/> 

      <xsl:call-template name="build-image-list"/>

      <!-- Body -->
     <xsl:choose>
        <xsl:when test="$extracts = 'yes'">
           <xsl:apply-templates select="frontmatter" mode="extract" />
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates select="frontmatter/chapter" />
        </xsl:otherwise>
      </xsl:choose>
 
      <xsl:apply-templates select="mainmatter" />
      <xsl:apply-templates select="//index" mode="force"/>
      <xsl:apply-templates select="backmatter"/>
    </fo:root>
  </xsl:template>

  <xsl:template match="chapter|appendix|recipe" mode="process.root">
    <xsl:variable name="document.element" select="self::*"/> 
    <xsl:comment><xsl:copy-of select="$document.element"/></xsl:comment>
    <fo:root xsl:use-attribute-sets="root.properties">         
      
      <rx:meta-info>
	<rx:meta-field name="author" value="Pragmatic Bookshelf"/>
      </rx:meta-info>
      
      
      <xsl:call-template name="setup.pagemasters"/>
      
      <!-- Body -->
      <xsl:apply-templates select="$document.element" />
      
    </fo:root>
  </xsl:template>

  <xsl:template match="options">
  </xsl:template>

  <xsl:template match="*">
    <xsl:message>
      <xsl:text>Missing template for </xsl:text><xsl:value-of select="local-name()"/>
    </xsl:message>
  </xsl:template>

</xsl:stylesheet>
