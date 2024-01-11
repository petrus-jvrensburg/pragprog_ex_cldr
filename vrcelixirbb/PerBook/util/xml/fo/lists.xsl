<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">


  <xsl:attribute-set name="list-block.indentation">
    <xsl:attribute name="provisional-distance-between-starts">
      <xsl:value-of select="$indented-block-indentation"/>
    </xsl:attribute>
    <xsl:attribute name="provisional-label-separation">0.5em</xsl:attribute>
  </xsl:attribute-set>


  <xsl:template match="dl">
    <xsl:choose>
      <xsl:when test="descendant::coref">
        <fo:list-block provisional-distance-between-starts="{$indented-block-indentation}">
          <xsl:for-each select="dt">
          <fo:list-item>
            <fo:list-item-label end-indent="label-end()">
               <fo:block color="{$color.our-mid-heading-text}">
                 <xsl:if test="@bold = 'yes'">
	                 <xsl:attribute name="font-weight">bold</xsl:attribute>
                 </xsl:if>
                 <xsl:call-template name="add-id"/>
                 <xsl:apply-templates/>
              </fo:block>
            </fo:list-item-label>
            <fo:list-item-body start-indent="body-start()">
              <xsl:for-each select="following-sibling::dd[1]">
                <fo:block>
                  <xsl:apply-templates/>
                </fo:block>
              </xsl:for-each>
            </fo:list-item-body>
          </fo:list-item>
          </xsl:for-each>
        </fo:list-block>
      </xsl:when>
      <xsl:otherwise>
        <fo:block-container margin-left="0pt" margin-right="0pt">
          <xsl:apply-templates/>
        </fo:block-container>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- remove
  <xsl:template match="dl/dd/dxxl">
    <fo:block-container margin-left="{$indented-block-indentation}" margin-right="0pt">
      <xsl:apply-templates/>
    </fo:block-container>
  </xsl:template> -->

  <xsl:template match="dt">
     <xsl:if test="not(@newline='no'and following-sibling::dd[1]/child::*[1][(name()='p')])">
       <fo:block keep-with-next="always">
         <xsl:if test="$color = 'yes'">
           <xsl:attribute name="color">
             <xsl:value-of select="$color.our-mid-heading-text"/>
           </xsl:attribute>
         </xsl:if>
         <xsl:call-template name="add-id"/>
         <xsl:choose>
           <xsl:when test="parent::dl/@style = 'bold'">
	           <xsl:attribute name="font-weight">bold</xsl:attribute>
           </xsl:when>
           <xsl:when test="parent::dl/@style = 'plain'"/>
           <xsl:when test="parent::dl/@style = 'italic'">
             <xsl:attribute name="font-style">italic</xsl:attribute>
           </xsl:when>
           <xsl:otherwise>
             <xsl:attribute name="font-style">italic</xsl:attribute>
           </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates/>
      </fo:block>
    </xsl:if>
  </xsl:template>

  <xsl:template match="dd">
    <fo:block-container margin-left="{$indented-block-indentation}"  margin-right="0pt">
      <xsl:choose>
        <xsl:when test="preceding-sibling::dt[1][@newline='no'] and child::*[1][(name()='p')]">
          <fo:block text-indent="-{$indented-block-indentation}" space-after="6pt" >
            <fo:inline><xsl:for-each select="preceding-sibling::dt[1]">
              <xsl:call-template name="add-id"/>
         <xsl:choose>
           <xsl:when test="parent::dl/@style = 'bold'">
	           <xsl:attribute name="font-weight">bold</xsl:attribute>
           </xsl:when>
           <xsl:when test="parent::dl/@style = 'plain'"/>
           <xsl:when test="parent::dl/@style = 'italic'">
             <xsl:attribute name="font-style">italic</xsl:attribute>
           </xsl:when>
           <xsl:otherwise>
             <xsl:attribute name="font-style">italic</xsl:attribute>
           </xsl:otherwise>
        </xsl:choose>
                <xsl:apply-templates/>
              </xsl:for-each>
            </fo:inline>
            <xsl:text> </xsl:text>
            <fo:inline>
              <xsl:for-each select="*[1]">
                <xsl:apply-templates/>
              </xsl:for-each>
            </fo:inline>
          </fo:block>
           <xsl:apply-templates select="*[not(position() = 1)]"/>
        </xsl:when>
        <xsl:otherwise>
           <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </fo:block-container>
  </xsl:template>


  <xsl:template match="ol">
    <fo:list-block xsl:use-attribute-sets="list-block.indentation">
      <xsl:if test="not(following-sibling::*)
        or following-sibling::*[1][name() = 'sect1']
        or following-sibling::*[1][name() = 'sect2']
        or following-sibling::*[1][name() = 'sect3']
        or following-sibling::*[1][name() = 'recipe']
       ">
        <xsl:attribute name="space-after">4pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="@style='compact' and not(ancestor::li)">
        <xsl:attribute name="space-after">6pt</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:list-block>
    <!-- RenderX has a bug - if the last element in a float is a list-block, it omits the rest of the text from the page.
      So we check to see if this is in a float and add a block if this is the last one. -->
    <xsl:if test="ancestor::sidebar
      or ancestor::dialog
      or ancestor::said-by
      or ancestor::highlight
      or ancestor::figure
      or ancestor::someone-says
      and not(following-sibling::*)">
      <fo:block/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="li[count(ancestor::ol) = 1][not(parent::ul)]">
    <xsl:call-template name="ordered-item">
      <xsl:with-param name="format">1.</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="li[count(ancestor::ol) = 2][not(parent::ul)]">
    <xsl:call-template name="ordered-item">
      <xsl:with-param name="format">a.</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="li[count(ancestor::ol) = 3][not(parent::ul)]">
    <xsl:call-template name="ordered-item">
      <xsl:with-param name="format">i.</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="ordered-item">
    <xsl:param name="format"/>
    <xsl:variable name="offset">
      <xsl:number count="li"/>
    </xsl:variable>

    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
	<fo:block>
          <xsl:number value="$offset - 1 + parent::ol/@start" format="{$format}"/>
	</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
	<fo:block>
	  <xsl:apply-templates/>
	</fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>


  <xsl:template match="ul">
    <fo:list-block xsl:use-attribute-sets="list-block.indentation">
      <xsl:if test="(not(following-sibling::*)
        or following-sibling::*[1][name() = 'sect1']
        or following-sibling::*[1][name() = 'sect2']
        or following-sibling::*[1][name() = 'sect3']
        or following-sibling::*[1][name() = 'recipe'])
        and not(parent::li)
       ">
        <xsl:attribute name="space-after">4pt</xsl:attribute>
      </xsl:if>
      <xsl:if test="@style='compact' and not(ancestor::li)">
        <xsl:attribute name="space-after">6pt</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates/>
    </fo:list-block>
    <!-- RenderX has a bug - if the last element in a float is a list-block, it omits the rest of the text from the page.
      So we check to see if this is in a float and add a block if this is the last one. -->
    <xsl:if test="ancestor::sidebar
      or ancestor::dialog
      or ancestor::said-by
      or ancestor::highlight
      or ancestor::figure
      or ancestor::someone-says
      and not(following-sibling::*)">
      <fo:block/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="ul/li">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
        <fo:block text-align="right">
          <xsl:choose>
            <xsl:when test="((count(ancestor::ul) +2) mod 2) = 0">&#x2013;</xsl:when>
            <xsl:otherwise>•</xsl:otherwise>
          </xsl:choose>
        </fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
        <fo:block>
          <xsl:apply-templates/>
        </fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>

  <xsl:template match="ul[@style='compact']/li/p | ol[@style='compact']/li/p">
    <xsl:call-template name="p">
      <xsl:with-param name="add-space">none</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="calloutlist">
    <fo:list-block xsl:use-attribute-sets="list-block.indentation">
      <xsl:apply-templates/>
    </fo:list-block>
    <!-- RenderX has a bug - if the last element in a float is a list-block, it omits the rest of the text from the page.
      So we check to see if this is in a float and add a block if this is the last one. -->
    <xsl:if test="ancestor::sidebar
      or ancestor::dialog
      or ancestor::said-by
      or ancestor::highlight
      or ancestor::figure
      or ancestor::someone-says
      and not(following-sibling::*)">
      <fo:block/>
    </xsl:if>
  </xsl:template>

  <xsl:template match="callout[not(ancestor::codeline)]">
    <fo:list-item>
      <fo:list-item-label end-indent="label-end()">
	<fo:block text-align="right">
	  <xsl:call-template name="coref"/>
	</fo:block>
      </fo:list-item-label>
      <fo:list-item-body start-indent="body-start()">
	<fo:block>
	  <xsl:apply-templates/>
	</fo:block>
      </fo:list-item-body>
    </fo:list-item>
  </xsl:template>


</xsl:stylesheet>
