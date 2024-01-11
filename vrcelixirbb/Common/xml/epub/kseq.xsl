<xsl:stylesheet  
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"  
   xmlns="http://www.w3.org/1999/xhtml"
   version="2.0"> 

  <xsl:template match="kseq">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="kcontrol">
    <span style="font-family:Quivira;"><xsl:text>⌃</xsl:text></span>
  </xsl:template>

  <xsl:template match="kshift">
    <span class="keyboard"><xsl:text>⇧</xsl:text></span>
  </xsl:template>

  <xsl:template match="kcommand">
    <span style="font-family:Quivira;"><xsl:text>⌘</xsl:text></span>
  </xsl:template>

  <xsl:template match="koption">
    <span style="font-family:Quivira;"><xsl:text>⌥</xsl:text></span>
  </xsl:template>

  <xsl:template match="kesc">
    <span class="keyboard"><xsl:text>Esc</xsl:text></span>
  </xsl:template>

  <xsl:template match="ktab">
    <span class="keyboard"><xsl:text>⇥</xsl:text></span>
  </xsl:template>

  <xsl:template match="kreturn">
    <span class="keyboard"><xsl:text>↩</xsl:text></span>
  </xsl:template>

  <xsl:template match="kenter">
    <span style="font-family:Quivira;"><xsl:text>⌅</xsl:text></span>
  </xsl:template>

  <xsl:template match="kdelete">
    <span style="font-family:Quivira;"><xsl:text>⌫</xsl:text></span>
  </xsl:template>

  <xsl:template match="kup">
    <span class="keyboard"><xsl:text>↑</xsl:text></span>
  </xsl:template>

  <xsl:template match="kdown">
    <span class="keyboard"><xsl:text>↓</xsl:text></span>
  </xsl:template>

  <xsl:template match="kleft">
    <span class="keyboard"><xsl:text>←</xsl:text></span>
  </xsl:template>

  <xsl:template match="kright">
    <span class="keyboard"><xsl:text>→</xsl:text></span>
  </xsl:template>

  <!-- <xsl:template match="klinebreak">
    <span class="keyboard"><xsl:text>\MacLinebreak{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="kcapslock">
    <span style="font-family:DejaVuSans;"><xsl:text>⇪</xsl:text></span>
  </xsl:template> <xsl:text></xsl:text> <span style="font-family:AppleSymbol;"><xsl:text></xsl:text></span>-->

  <xsl:template match="kapple">
    <img src="images/apple-logo-black.jpg" alt="Apple"/>
  </xsl:template>

<!-- remove
  <xsl:template match="keject">
    <span class="keyboard"><xsl:text>⏏</xsl:text></span>
  </xsl:template> -->

  <xsl:template match="kpower">
    <span class="keyboard"><xsl:text>\MacPower{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="kbacktab">
    <span class="keyboard"><xsl:text>\MacBackTab{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="kpageup">
    <span class="keyboard"><xsl:text>\MacPageUp{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="kpagedown">
    <span class="keyboard"><xsl:text>\MacPageDown{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="khome">
    <span class="keyboard"><xsl:text>\MacHome{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="kend">
    <span class="keyboard"><xsl:text>\MacEnd{}</xsl:text></span>
  </xsl:template>

  <xsl:template match="kforwarddelete">
    <span class="keyboard"><xsl:text>⌦</xsl:text></span>
  </xsl:template>

  <xsl:template match="khelp">
    <span class="keyboard"><xsl:text>\MacHelp{}</xsl:text></span>
  </xsl:template>
  
  <xsl:template match="kreturn2">
    <span class="keyboard"><xsl:text>Return 2</xsl:text></span>
  </xsl:template>
  
  <xsl:template match="F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12">
    <span class="keyboard"><xsl:value-of select="local-name()"/></span>
  </xsl:template>
</xsl:stylesheet>
