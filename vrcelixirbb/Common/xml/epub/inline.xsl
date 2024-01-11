<xsl:stylesheet 
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"   
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"
>

<xsl:preserve-space elements="shade"/>
  <!-- remove for Saxon (consistency issue) 
  <xsl:output indent="no"/>-->

  <xsl:template name="missing" />
  <xsl:template match="missing">
    <xsl:call-template name="missing"/>
  </xsl:template>


<!-- remove match  tabletitle | -->
  <xsl:template match="acronym | b | booksectname |
     emph |
     initials | 
     standin |
     underline | 
     variablename" xml:space="default"><span><xsl:attribute name="class"><xsl:value-of select="local-name()"/></xsl:attribute><xsl:apply-templates/></span></xsl:template>
 
 
 
 <xsl:template match="elide"><span><xsl:attribute name="class"><xsl:value-of select="local-name()"/> emph</xsl:attribute><xsl:apply-templates/></span></xsl:template>

 <xsl:template match="dont-use-embolden">
   <strong><xsl:apply-templates/></strong>
 </xsl:template>

  <xsl:template match="cf"><code class="cf"><xsl:apply-templates/></code></xsl:template>

<!-- remove match  | parametername | stringinfile -->
  <xsl:template match="cf
    |  class
    | commandname
    | commandoption
    | constant
    | dir
    | fileextension
    | filename
    | ic
    | inlinecode 
    | keyword
    | sqlcolumn
    | sqltable
    | string
    | variable
    | xmlattrval"><span><xsl:attribute name="class"><xsl:text>cf </xsl:text><xsl:value-of select="local-name()"/></xsl:attribute><xsl:apply-templates/></span></xsl:template>

  <xsl:template match="fraction">
    <xsl:if test="./whole">
      <xsl:apply-templates select="top"/>
      <xsl:text> </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="top"/>
    <xsl:text>/</xsl:text>
    <xsl:apply-templates select="bottom"/>
  </xsl:template>

  <xsl:template match="whole | top | bottom">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="keystroke">
    <span class="keystroke">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="method">
   <span>
      <xsl:attribute name="class">cf methodname</xsl:attribute>
      <xsl:apply-templates/>
      <xsl:if test="@args and not(@args='')">  <!-- no odea why I have to do this -->
	<xsl:text>(</xsl:text>
	<xsl:value-of select="@args"/>
	<xsl:text>)</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>



  <xsl:template match="objcmethod">
    <span>
      <xsl:attribute name="class">cf methodname</xsl:attribute>
      <xsl:variable name="name">
        <xsl:value-of select="."/>
      </xsl:variable>
      <xsl:choose>
        <xsl:when test="starts-with($name, '-')">
          <xsl:text>&#8209;</xsl:text><!-- hyphen that doesn't become a hyphenation point -->
          <xsl:value-of select="substring($name, 2)"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="@args"/>
    </span>
  </xsl:template>
  
  <xsl:template match="objcmethodname">
    <span>
      <xsl:attribute name="class">cf methodname</xsl:attribute>
      <xsl:variable name="name">
	<xsl:value-of select="."/>
      </xsl:variable>
      <xsl:choose>
	<xsl:when test="starts-with($name, '-')">
	  <xsl:text>&#8209;</xsl:text><!-- hyphen that doesn't become a hyphenation point -->
	  <xsl:value-of select="substring($name, 2)"/>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
      <xsl:value-of select="@args"/>
    </span>
  </xsl:template>
<!-- remove match  | lmn -->
  <xsl:template match="lispmethodname">
    <span class="cf methodname">
      <xsl:choose>
	<xsl:when test="@args"><xsl:text>(</xsl:text>
	  <xsl:apply-templates/>
	  <xsl:text> </xsl:text>
	  <xsl:value-of select="@args"/>
	  <xsl:text>)</xsl:text>
	</xsl:when>
	<xsl:otherwise>
	  <xsl:apply-templates/>
	</xsl:otherwise>
      </xsl:choose>
   </span>
  </xsl:template>

  <xsl:template match="lispmethod">
    <span class="cf methodname">
      <xsl:choose>
        <xsl:when test="@args"><xsl:text>(</xsl:text>
          <xsl:apply-templates/>
          <xsl:text> </xsl:text>
          <xsl:value-of select="@args"/>
          <xsl:text>)</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates/>
        </xsl:otherwise>
      </xsl:choose>
    </span>
  </xsl:template>

  <xsl:template match="xmlattr">
    <span class="cf xmlattr">
      <xsl:apply-templates/>
      <xsl:if test="@value">
	<xsl:text>="</xsl:text>
	<xsl:value-of select="@value"/>
	<xsl:text>"</xsl:text>
      </xsl:if>
    </span>
  </xsl:template>

  <xsl:template match="firstuse">
   <span class="firstuseinline"><xsl:apply-templates/></span>
<!--    <span class="firstusemargin"><xsl:apply-templates/></span> -->
  </xsl:template>

  <xsl:template match="p/flag">
    <span class="flag">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="flag">
    <p>
      <span class="flag">
        <xsl:apply-templates/>
      </span>
    </p>
  </xsl:template>
  <!-- remove
  <xsl:template name="flagmaterial">
    <div>
      <xsl:attribute name="class">
	<xsl:text>flag</xsl:text>
	<xsl:value-of select="@type"/>
      </xsl:attribute>
      <img src="images/WigglyRoad.jpg" alt="Here be dragons..."/>
    </div>
  </xsl:template> -->

  <!-- ignore indexing -->
  <xsl:template match="i" />

  <xsl:template match="inlineimage">
    <xsl:call-template name="internal-imagedata">
      <xsl:with-param name="inline">inline</xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template match="authorq | ed | ce | author">
  </xsl:template>



  <xsl:template match="url">
    <xsl:variable name="protocol">
      <xsl:value-of select="substring-before(.,':')"/>
    </xsl:variable>
    <xsl:variable name="protocol-string">
      <xsl:if test="string-length($protocol) = 0">
        <xsl:choose>
          <xsl:when test="string-length(@protocol) &gt; 0">
            <xsl:value-of select="@protocol"/>
          </xsl:when>
          <xsl:otherwise>http://</xsl:otherwise>
        </xsl:choose>
      </xsl:if>
    </xsl:variable>
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="concat($protocol-string,.)"/>
      </xsl:attribute>
      <xsl:value-of select="concat($protocol-string,.)"/>
    </a>
  </xsl:template>
 
  <!-- remove
  <xsl:template match="a">
    <a>
      <xsl:attribute name="href">
	<xsl:value-of select="@href"/>
      </xsl:attribute>
      <xsl:apply-templates />
    </a>
  </xsl:template> -->
  
  <xsl:template match="xmltag"><span class="cf xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates mode="strip"/>
      <xsl:if test="@attrs">
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@attrs"/>
      </xsl:if>
      <xsl:if test="@close">
	      <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:text>&gt;</xsl:text>
    </span></xsl:template>
  
   <xsl:template match="xmltag" mode="strip" xml:space="default"><span class="cf xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:apply-templates mode="strip"/>
      <xsl:if test="@attrs">
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@attrs"/>
      </xsl:if>
      <xsl:if test="@close">
	      <xsl:text>/</xsl:text>
      </xsl:if>
      <xsl:text>&gt;</xsl:text>
    </span></xsl:template> 

  <xsl:template match="xmltagpair" xml:space="default">
    <span class="cf xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:if test="@attrs">
	      <xsl:text> </xsl:text>
	      <xsl:value-of select="@attrs"/>
      </xsl:if>
      <xsl:text>&gt;</xsl:text>
    </span><xsl:apply-templates mode="strip" xml:space="default"/><span class="cf xmltag">
      <xsl:text>&lt;</xsl:text>
      <xsl:value-of select="@name"/>
      <xsl:text>&gt;</xsl:text>
    </span>
  </xsl:template>

  <xsl:template match="nohyphen">
    <span class="nohyphen">
      <xsl:apply-templates/>
    </span>
  </xsl:template>

  <xsl:template match="raise">
    <xsl:apply-templates/><sup><xsl:value-of select="@power"/></sup>
  </xsl:template>

  <xsl:template match="lower">
    <xsl:apply-templates/><sub><xsl:value-of select="@subscript"/></sub>
  </xsl:template>


  <xsl:template match="shade" name="shade"><xsl:choose><xsl:when test=". = ' '"><span><xsl:attribute name="class"><xsl:text>shade-fg-</xsl:text><xsl:value-of select="@fg"/><xsl:text> shade-bg-</xsl:text><xsl:value-of select="@bg"/></xsl:attribute>&#x2002;</span></xsl:when><xsl:otherwise><span><xsl:attribute name="class"><xsl:text>shade-fg-</xsl:text><xsl:value-of select="@fg"/><xsl:text> shade-bg-</xsl:text><xsl:value-of select="@bg"/></xsl:attribute><xsl:apply-templates xml:space="preserve"/></span></xsl:otherwise></xsl:choose></xsl:template>

  <xsl:template match="shade" mode="code"><xsl:call-template name="shade"/></xsl:template>


  <xsl:template match="sqrt">
      <xsl:text>sqrt(</xsl:text>
      <xsl:apply-templates/>
      <xsl:text>)</xsl:text>
  </xsl:template>
  
  <xsl:template match="strike">
    <span class="strike"><xsl:apply-templates/></span>
  </xsl:template>
  
  <xsl:template match="vector">
    <u>
      <i>
      <xsl:apply-templates/>
    </i>
    </u>
  </xsl:template>
  
   <xsl:template match="if-inline">
    <xsl:if test="@target='epub' or @hyphenate='yes'">
      <xsl:apply-templates/>
    </xsl:if>
 </xsl:template>

  
</xsl:stylesheet>
