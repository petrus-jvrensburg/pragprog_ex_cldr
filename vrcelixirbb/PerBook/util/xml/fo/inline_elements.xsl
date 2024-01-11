<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                version="2.0">
  <xsl:output indent="no"/>

  <xsl:attribute-set name="inline-code-font">
    <xsl:attribute name="font-family">
      <xsl:value-of select="$inline.code.font.family"/>
    </xsl:attribute>
    <xsl:attribute name="font-size">90%</xsl:attribute>
    <xsl:attribute name="font-stretch">semi-condensed</xsl:attribute>
  </xsl:attribute-set>

  <!-- code items -->
  <xsl:template match="
		         class
		       | commandname
		       | commandoption
		       | constant
		       | dir
		       | filename
		       | ic
		       | inlinecode
		       | keyword
		       | sqlcolumn
		       | sqltable
		       | variable
		       "><fo:inline xsl:use-attribute-sets="inline-code-font"><xsl:apply-templates mode="code"/></fo:inline></xsl:template>


  <!-- ALPHABETICAL FROM HERE DOWN, PLEASE -->

  <xsl:template match="acronym | initials">
    <fo:inline font-size="90%">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

    <!--
        We fill in the book name from the citation if there is one and
       the name is otherwise absent
       if a citation is present...
       make sure it's in the bibliography
       if the bookname tag has no content, supply from bibliography
  -->

  <xsl:template match="articlename | bookname">
    <fo:inline>
      <xsl:attribute name="font-style">
   	<xsl:choose>
   	  <xsl:when test="ancestor::epigraph or ancestor::said-by">normal</xsl:when>
   	  <xsl:otherwise>italic</xsl:otherwise>
   	</xsl:choose>
      </xsl:attribute>
      <xsl:choose>
        <xsl:when test="@cite">
	  <xsl:variable name="cite" select="@cite"/>
   	  <xsl:choose>
   	    <xsl:when test="$bib/*[@tag=$cite]">
   	      <xsl:choose>
   	        <xsl:when test="$target.for-screen='yes'">
   	          <fo:basic-link xsl:use-attribute-sets="hyperlink">
   	            <xsl:attribute name="internal-destination">
   	              <xsl:value-of select="generate-id($bib/*[@tag=$cite][1])"/>
   	            </xsl:attribute>
   	            <xsl:call-template name="bookname-content">
   	              <xsl:with-param name="cite" select="$cite"/>
   	            </xsl:call-template>
   	          </fo:basic-link>
   	        </xsl:when>
   	        <xsl:otherwise>
    	          <xsl:call-template name="bookname-content">
   	            <xsl:with-param name="cite" select="$cite"/>
   	          </xsl:call-template>
   	        </xsl:otherwise>
   	      </xsl:choose>
   	    </xsl:when>
	    <xsl:otherwise>
              <xsl:if test="not($ignore-workflow-tags='yes')">
	        <xsl:message>
	          Missing bibliography entry for <xsl:value-of select="@cite"/>
	        </xsl:message>
	        <fo:inline xsl:use-attribute-sets="highlight.missing-biblio">
	          Missing bibliography entry for <xsl:value-of select="@cite"/>
	        </fo:inline>
              </xsl:if>
	    </xsl:otherwise>
	  </xsl:choose>
        </xsl:when>
        <xsl:otherwise>
	  <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:inline>
  </xsl:template>

  <xsl:template name="bookname-content">
    <xsl:param name="cite"/>
    	       <fo:inline keep-together.within-line="auto" hyphenate="false">
           <xsl:choose>
		         <xsl:when test="text()"><xsl:apply-templates/></xsl:when>
		         <xsl:otherwise>
		           <xsl:for-each select="$bib/*[@tag=$cite]//title">
		             <xsl:apply-templates/>
		           </xsl:for-each>
		         </xsl:otherwise>
           </xsl:choose>
   	       </fo:inline>
   	       <fo:inline keep-with-previous.within-line="always">
   	         <xsl:text> [</xsl:text>
	           <xsl:value-of select="$bib/*[@tag=$cite]/@label"/>
	           <xsl:text>]</xsl:text>
   	      </fo:inline>
  </xsl:template>

   <xsl:template match="author">
     <xsl:if test="not($ignore-workflow-tags='yes')">
       <xsl:choose>
         <xsl:when test="parent::part | parent::chapter | parent::appendix | parent::recipe | parent::task">
            <fo:block xsl:use-attribute-sets="highlight.author">
             <xsl:text>Author: </xsl:text>
             <xsl:apply-templates/>
           </fo:block>
         </xsl:when>
         <xsl:otherwise>
           <fo:inline xsl:use-attribute-sets="highlight.author">
             <xsl:text>Author: </xsl:text>
             <xsl:apply-templates/>
           </fo:inline>
         </xsl:otherwise>
       </xsl:choose>
    <xsl:message>**** Missing Author: <xsl:apply-templates/></xsl:message>
       </xsl:if>
  </xsl:template>

  <xsl:template match="authorq">
     <xsl:if test="not($ignore-workflow-tags='yes')">
       <xsl:choose>
         <xsl:when test="parent::part | parent::chapter | parent::appendix | parent::recipe | parent::task">
            <fo:block xsl:use-attribute-sets="highlight.authorq">
             <xsl:text>Author asks: </xsl:text>
             <xsl:apply-templates/>
           </fo:block>
         </xsl:when>
         <xsl:otherwise>
           <fo:inline xsl:use-attribute-sets="highlight.authorq">
             <xsl:text>Author asks: </xsl:text>
             <xsl:apply-templates/>
           </fo:inline>
         </xsl:otherwise>
       </xsl:choose>
    <xsl:message>**** Missing Author asks: <xsl:apply-templates/></xsl:message>
       </xsl:if>
  </xsl:template>

<!--
  <xsl:template match="b">
    <fo:inline font-weight="bold">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>
-->

  <xsl:template match="booksectname"><fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline></xsl:template>

  <xsl:template match="ce">
      <xsl:if test="not($ignore-workflow-tags='yes')">
   <fo:inline xsl:use-attribute-sets="highlight.ce">
      <xsl:text>CE: </xsl:text>
      <xsl:apply-templates/>
   </fo:inline>

    <xsl:message>**** Missing CE: <xsl:apply-templates/></xsl:message>
        </xsl:if>
  </xsl:template>

  <xsl:template match="cite">
    <xsl:message terminate="yes">
      You have &lt;cite ref="<xsl:value-of select="@ref"/>" /&gt;

      The &lt;cite&gt; tag is now deprecated, because authors were using it without giving the
      book or article name. Our style is always to give the name inline. Use the bookname
      tag with the cite= attribute instead.
    </xsl:message>
  </xsl:template>

  <xsl:template match="ed">
     <xsl:if test="not($ignore-workflow-tags='yes')">
       <xsl:choose>
         <xsl:when test="parent::part | parent::chapter | parent::appendix | parent::recipe | parent::task">
            <fo:block xsl:use-attribute-sets="highlight.ed">
             <xsl:text>Ed: </xsl:text>
             <xsl:apply-templates/>
           </fo:block>
         </xsl:when>
         <xsl:otherwise>
           <fo:inline xsl:use-attribute-sets="highlight.ed">
             <xsl:text>Ed: </xsl:text>
             <xsl:apply-templates/>
           </fo:inline>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:message>**** Missing Ed: <xsl:apply-templates/></xsl:message>
    </xsl:if>
  </xsl:template>

  <xsl:template match="elide"><xsl:call-template name="elide"/></xsl:template>

  <xsl:template match="elide" mode="code"><xsl:call-template name="elide"/></xsl:template>

 <xsl:template name="elide"><fo:inline font-style="italic"><fo:inline font-size="150%">&#171;</fo:inline><xsl:apply-templates mode="code"/><fo:inline font-size="150%">&#187;</fo:inline></fo:inline></xsl:template>

  <xsl:template match="emph | firstuse"><fo:inline font-style="italic"><xsl:apply-templates/></fo:inline></xsl:template>

  <xsl:template match="dont-use-embolden"><fo:inline font-weight="bold"><xsl:apply-templates/></fo:inline></xsl:template>

<!-- remove
<xsl:template match="eof">
    <fo:inline font-style="italic" xsl:use-attribute-sets="inline.code.font">
      <fo:inline font-size="150%">&#171;</fo:inline>
      <fo:inline font-size="80%">EOF</fo:inline>
      <fo:inline font-size="150%">&#187;</fo:inline>
    </fo:inline>
  </xsl:template> -->

  <xsl:template match="fileextension"><fo:inline xsl:use-attribute-sets="inline-code-font">
      <xsl:text>.</xsl:text>
      <xsl:apply-templates/>
    </fo:inline></xsl:template>

   <xsl:template match="flag">
      <xsl:if test="not($ignore-workflow-tags='yes')">
       <xsl:choose>
         <xsl:when test="parent::part | parent::chapter | parent::appendix | parent::recipe | parent::task">
            <fo:block border="1pt solid red"
	       padding="2pt 1pt 1pt 1pt">
             <xsl:apply-templates/>
           </fo:block>
         </xsl:when>
         <xsl:otherwise>
           <fo:inline border="1pt solid red"
	       padding="2pt 1pt 1pt 1pt">
             <xsl:apply-templates/>
           </fo:inline>
         </xsl:otherwise>
      </xsl:choose>
        </xsl:if>
  </xsl:template>

<!--
  <xsl:template match="flagmaterial">
    <fo:float float="outside"
	      start-indent="0pt"
	      end-indent="0pt"
	      clear="both">
      <fo:block
	  width="{$sidebar.width}"
	  padding-left="0.1in"
	  padding-right="0.1in"
	  >
	  <fo:external-graphic content-width="0.6in" src="url(../PerBook/util/images/WigglyRoad.jpg)"/>
	</fo:block>
    </fo:float>
  </xsl:template>
-->

  <xsl:template match="fraction"><xsl:if test="./whole"><fo:inline><xsl:apply-templates select="whole"/></fo:inline></xsl:if><fo:inline font-size="70%" baseline-shift="super"><xsl:apply-templates select="top"/></fo:inline><fo:inline font-family="Arial">&#8260;</fo:inline><fo:inline font-size="70%" baseline-shift="sub"><xsl:apply-templates select="bottom"/></fo:inline></xsl:template>

  <xsl:template match="whole | top | bottom"><xsl:apply-templates/></xsl:template>


  <xsl:template match="il"><fo:inline width="2em">&#160;</fo:inline><xsl:text>•&#160;</xsl:text><xsl:apply-templates/></xsl:template>

  <!-- The zwsp is to allow breaks between keystroke tags that are connected by the + sign, because the hyphenator doesn't know how to break it. -->
  <xsl:template match="keystroke"><fo:inline xsl:use-attribute-sets="inline-code-font"
    background-color="{$color.our-keystroke-background-shade}"
    padding-top="1.5pt"
    padding-left="1pt"
    padding-right="1pt" >
    <xsl:attribute name="keep-together.within-line">
      <xsl:choose>
        <xsl:when test="allow-break='yes'">auto</xsl:when>
        <xsl:otherwise>always</xsl:otherwise>
      </xsl:choose>
    </xsl:attribute>
      <xsl:apply-templates/>
    </fo:inline></xsl:template>

  <xsl:template match="nobreak"><fo:inline keep-together.within-line="always"><xsl:apply-templates/></fo:inline></xsl:template>

  <!-- remove
<xsl:template match="ldots">
    <xsl:text>…</xsl:text>
  </xsl:template> -->

  <xsl:template match="lispmethod "><fo:inline xsl:use-attribute-sets="inline-code-font">
 	  <xsl:text>(</xsl:text>
	  <xsl:apply-templates mode="code"/>
	  <xsl:if test="@args">
	    <xsl:text> </xsl:text>
	    <xsl:value-of select="@args"/>
	  </xsl:if>
	  <xsl:text>)</xsl:text>
    </fo:inline></xsl:template>

  <xsl:template match="lower"><xsl:apply-templates/><fo:inline baseline-shift="sub" font-size="70%">
      <xsl:value-of select="@subscript"/>
    </fo:inline></xsl:template>

  <xsl:template match="method"><fo:inline xsl:use-attribute-sets="inline-code-font">
      <xsl:apply-templates mode="code"/>
      <xsl:if test="@args or not(//book/options/omitmethodparens)">
	     <xsl:text>(</xsl:text>
	     <xsl:value-of select="@args"/>
	     <xsl:text>)</xsl:text>
      </xsl:if>
    </fo:inline></xsl:template>

  <xsl:template match="missing">
     <xsl:if test="not($ignore-workflow-tags='yes')">
   <fo:float float="outside"
	      start-indent="0pt"
	      end-indent="0pt"
	      clear="both">
      <fo:block-container
	  width="1in"
	  margin-left="0.1in"
	  margin-right="0.1in"
	  text-align="left"
	  xsl:use-attribute-sets="highlight.missing">
	<fo:block>
	  <xsl:text>&#9758; </xsl:text>
	  <xsl:apply-templates/>
	</fo:block>
      </fo:block-container>
    </fo:float>
    <xsl:message>
      <xsl:text>**** Missing: </xsl:text>
      <xsl:apply-templates/>
    </xsl:message>
    </xsl:if>
  </xsl:template>


  <xsl:template match="footnote//missing |
    sidebar//missing |
    joeasks//missing |
    said//missing |
    figure//missing |
    dialog//missing |
    highlight//missing |
    someone-says//missing |
    marginnote//missing ">
    <fo:inline
	xsl:use-attribute-sets="highlight.missing"
	>
      <fo:block>
	<xsl:text>&#9758; </xsl:text>
	<xsl:apply-templates/>
      </fo:block>
    </fo:inline>
    <xsl:message>
      <xsl:text>**** Missing: </xsl:text>
      <xsl:apply-templates/>
    </xsl:message>
  </xsl:template>

  <xsl:template match="newline">
    <fo:block>
    </fo:block>
  </xsl:template>

  <xsl:template match="nohyphen"><fo:inline hyphenate="false">
      <xsl:apply-templates/>
    </fo:inline></xsl:template>

  <xsl:template match="objcmethod"><fo:inline xsl:use-attribute-sets="inline-code-font">
      <xsl:apply-templates mode="code"/>
      <xsl:if test="@args">
      	<xsl:value-of select="@args"/>
      </xsl:if>
    </fo:inline></xsl:template>

   <xsl:template match="permissions">
    <xsl:if test="not($ignore-workflow-tags='yes')">
       <xsl:choose>
         <xsl:when test="parent::part | parent::chapter | parent::appendix | parent::recipe | parent::task">
            <fo:block xsl:use-attribute-sets="highlight.permissions"  padding="0.2em">
             <xsl:text>Permission </xsl:text>
             <xsl:value-of select="@status"/>
             <xsl:text>: </xsl:text>
             <xsl:apply-templates/>
           </fo:block>
         </xsl:when>
         <xsl:otherwise>
           <fo:inline xsl:use-attribute-sets="highlight.permissions"  padding="0.2em">
             <xsl:text>Permission </xsl:text>
             <xsl:value-of select="@status"/>
             <xsl:text>: </xsl:text>
             <xsl:apply-templates/>
           </fo:inline>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:message>**** Missing Permission <xsl:value-of select="@status"/>: <xsl:apply-templates/></xsl:message>
    </xsl:if>
  </xsl:template>


  <xsl:template match="raise">
    <xsl:apply-templates/><fo:inline baseline-shift="super" font-size="70%">
      <xsl:value-of select="@power"/>
    </fo:inline></xsl:template>

  <xsl:template match="shade" name="shade">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="shade" mode="code">
    <xsl:call-template name="shade"/>
  </xsl:template>


  <xsl:template match="sqrt"><fo:inline font-size="110%">&#8730;</fo:inline><fo:inline font-size="90%">
      <xsl:text>&#8202;</xsl:text>
      <xsl:apply-templates/>
    </fo:inline></xsl:template>

  <xsl:template match="standin">
    <fo:inline font-style="italic" padding-right="1pt">
      <xsl:apply-templates/>
    </fo:inline>
  </xsl:template>

<!-- remove
  match: | stringinfile -->
  <xsl:template match="string"><fo:inline font-style="italic"><xsl:apply-templates/></fo:inline></xsl:template>

  <xsl:template match="strike"><fo:inline text-decoration="line-through"><xsl:apply-templates/></fo:inline></xsl:template>

  <xsl:template match="underline"><fo:inline text-decoration="underline"><xsl:apply-templates/></fo:inline></xsl:template>

  <xsl:template match="vector"><fo:inline font-style="italic" text-decoration="underline">
      <xsl:apply-templates/>
      </fo:inline></xsl:template>

  <xsl:template match="xmlattr"><fo:inline xsl:use-attribute-sets="inline-code-font">
      <xsl:apply-templates mode="code"/>
      <xsl:text>=</xsl:text>
      <xsl:if test="@value">
	<xsl:text>"</xsl:text>
	<xsl:value-of select="@value"/>
	<xsl:text>"</xsl:text>
      </xsl:if>
    </fo:inline></xsl:template>

  <xsl:template match="xmlattrval"><fo:inline font-style="italic">
      <xsl:apply-templates/>
    </fo:inline></xsl:template>

  <xsl:template match="xmltag"><fo:inline xsl:use-attribute-sets="inline-code-font">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:if test="@attrs">
	<xsl:text> </xsl:text>
	<xsl:value-of select="@attrs"/>
      </xsl:if>
      <xsl:if test="@close">
	<xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:text>&gt;</xsl:text>
    </fo:inline></xsl:template>

  <xsl:template match="xmltagpair"><fo:inline xsl:use-attribute-sets="inline-code-font">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:if test="@attrs">
	<xsl:text> </xsl:text>
	<xsl:value-of select="@attrs"/>
      </xsl:if>
      <xsl:text>&gt;</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>&lt;/</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&gt;</xsl:text>
    </fo:inline>
  </xsl:template>

<!-- NAMED TEMPLATES -->

  <xsl:template name="small-capper">
    <xsl:param name="string"/>
    <xsl:choose>
      <xsl:when test="contains($string,' ')">
        <xsl:variable name="first-word">
          <xsl:value-of select="substring-before(.,' ')"/>
        </xsl:variable>
        <xsl:variable name="first-char">
          <xsl:value-of select="substring($first-word,1,1)"/>
        </xsl:variable>
        <xsl:variable name="not-first-char">
          <xsl:value-of select="substring($first-word,2)"/>
        </xsl:variable>
        <xsl:variable name="remaining-words">
          <xsl:value-of select="substring-after($string,' ')"/>
        </xsl:variable>

        <fo:inline font-size="x-small">
          <xsl:value-of select="$first-char"/>
        </fo:inline>
        <fo:inline font-size="xx-small">
          <xsl:call-template name="capper">
            <xsl:with-param name="string" select="$not-first-char"/>
          </xsl:call-template>
        </fo:inline>
        <xsl:text> </xsl:text>

        <xsl:call-template name="small-capper">
          <xsl:with-param name="string" select="$remaining-words"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="first-char">
          <xsl:value-of select="substring($string,1,1)"/>
        </xsl:variable>
        <xsl:variable name="not-first-char">
          <xsl:value-of select="substring($string,2)"/>
        </xsl:variable>

       <fo:inline font-size="x-small">
         <xsl:value-of select="$first-char"/>
       </fo:inline>
       <fo:inline font-size="xx-small">
         <xsl:call-template name="capper">
           <xsl:with-param name="string" select="$not-first-char"/>
         </xsl:call-template>
       </fo:inline>

      </xsl:otherwise>
    </xsl:choose>

  </xsl:template>

<xsl:template name="capper">
  <xsl:param name="string"/>
  <xsl:value-of select="translate($string,'abcdefghijklmnopqrstuvwxyz','ABCDEFGHIJKLMNOPQRSTUVWXYZ')"/>
</xsl:template>

  <!-- This uses the XEP 4.19 extension to add comments to a PDF -->
   <!-- Removed sticky-notes in favor of inline.  Retaining in comments in case needed for other markup in the future.
  <xsl:template name="add-sticky-note">
    <xsl:param name="prefix"/>
    <xsl:param name="color">yellow</xsl:param>
    <xsl:param name="content">
      <xsl:apply-templates />
    </xsl:param>

    <xsl:if test="not($ignore-workflow-tags='yes')">
       <rx:pdf-comment>
      <xsl:attribute name="title"><xsl:value-of select="$prefix"/></xsl:attribute>
      <xsl:attribute name="color"><xsl:value-of select="$color"/></xsl:attribute>
      <xsl:attribute name="content">
	<xsl:value-of select="normalize-space($content)"/>
      </xsl:attribute>
      <rx:pdf-sticky-note icon-type="note" open="true"/>
      </rx:pdf-comment>
      <fo:inline>
	       <xsl:value-of select="normalize-space($content)"/>
      </fo:inline>
     </xsl:if>

    <xsl:message>
      <xsl:text>**** Missing</xsl:text>
      <xsl:if test="$prefix">
	<xsl:text> </xsl:text>
      </xsl:if>
      <xsl:value-of select="$prefix"/>
      <xsl:text>: </xsl:text>
      <xsl:value-of select="normalize-space($content)"/>
    </xsl:message>
  </xsl:template>
 -->

  <xsl:template match="inlineimage">
    <fo:external-graphic scaling="uniform"
                         overflow="hidden"
                         alignment-adjust="-4.7pt">

      <xsl:if test="@baseline-shift">
        <xsl:attribute name="alignment-adjust">
          <xsl:value-of select="@baseline-shift"/>
          <xsl:text>pt</xsl:text>
        </xsl:attribute>
      </xsl:if>

      <xsl:if test="@border = 'yes'">
        <xsl:attribute name="border-width">1pt</xsl:attribute>
        <xsl:attribute name="border-style">solid</xsl:attribute>
        <xsl:attribute name="border-color"><xsl:value-of select="$color.our-mid-line"/></xsl:attribute>
      </xsl:if>
       <xsl:attribute name="src">
	 <xsl:text>url(</xsl:text>
	 <xsl:call-template name="get-image-name"/>
	 <xsl:text>)</xsl:text>
       </xsl:attribute>
      </fo:external-graphic>
  </xsl:template>

</xsl:stylesheet>
