<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:fo="http://www.w3.org/1999/XSL/Format"
xmlns:pp="http://pragprog.com"
version="2.0">

  <xsl:template name="airport.copyright">
		<xsl:param name="small-print">5pt</xsl:param>
    <xsl:param name="print">7pt</xsl:param>
   
    <fo:block break-before="page" space-before="0.25in" space-before.conditionality="retain"
    >

    <fo:external-graphic  content-width="2in" src="url(../PerBook/util/images/Bookshelf_BW_2in.png)"/>

    <fo:block space-before="0.15in" font-size="{$print}">
      <xsl:call-template name="contact.text"/>

      <fo:block space-before="6pt" space-after="4pt">
        <xsl:text>Contact </xsl:text>
        <xsl:call-template name="external-link">
          <xsl:with-param name="url">
            <xsl:value-of select="'support@pragprog.com'"/>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:copy-of select="'support@pragprog.com'"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text> for sales, volume licensing, and support; contact </xsl:text>
        <xsl:call-template name="external-link">
          <xsl:with-param name="url">
            <xsl:value-of select="'rights@pragprog.com'"/>
          </xsl:with-param>
          <xsl:with-param name="text">
            <xsl:copy-of select="'rights@pragprog.com'"/>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:text> for international rights.</xsl:text>
      </fo:block>
    </fo:block>

    <fo:block font-size="{$print}" space-before="0.5in">
      <xsl:choose>
        <xsl:when test="/book/bookinfo/isbn13-hardcover !=''">
          <fo:block>
            <xsl:text>ISBN-13 (Paperback edition): </xsl:text>
            <xsl:value-of select="/book/bookinfo/isbn13"/>
          </fo:block>

          <fo:block>
            <xsl:text>ISBN-13 (Hardcover edition): </xsl:text>
            <xsl:value-of select="/book/bookinfo/isbn13-hardcover"/>
          </fo:block>
        </xsl:when>
        <xsl:otherwise>
          <!-- legacy behavior -->
          <fo:block>
            <xsl:text>ISBN-13: </xsl:text>
            <xsl:value-of select="/book/bookinfo/isbn13"/>
          </fo:block>
        </xsl:otherwise>
      </xsl:choose>

      <!-- info about paper or "finest bits" -->
      <!-- only want this for screen versions. -->
      <xsl:if test="$target.for-screen='yes'">
        <fo:block>
          <xsl:call-template name="pp:paper-content"/>
        </fo:block>
      </xsl:if>

      <fo:block>
        <xsl:text>Book version: </xsl:text>
        <xsl:value-of select="/book/bookinfo/printing/printingnumber"/>
        <xsl:text>—</xsl:text>
        <xsl:value-of select="/book/bookinfo/printing/printingdate"/>
      </fo:block>
    </fo:block>
    
    <fo:block font-size="{$print}" space-before="12pt">
      <xsl:apply-templates select="/book/bookinfo/production-info"/>
    </fo:block>


    <fo:block-container 
    position="absolute"
    top="4in"
    font-family="{$heading.font.family}"
    font-size="6.5pt"
    left="1.1in"
    width="2.15in"
    >

    <fo:block-container hyphenate="false" line-height="110%" text-align="right" font-size="{$small-print}" space-before="0.5in" margin-left="0pt" margin-right="0pt">
      <xsl:call-template name="copyright.text"/>
      <xsl:call-template name="pp:extra-rights"/>
    </fo:block-container>


    <!--	<fo:block>
      All rights reserved.
      </fo:block>
    -->

    <!--	  <fo:block space-before="6pt">
      <xsl:text>Printed in </xsl:text>
      <xsl:call-template name="country-of-manufacture"/>
      <xsl:text>.</xsl:text>
      </fo:block>
    -->

      <!-- support hardcover ISBN -->
    <fo:block space-before="12pt" text-align="end">
      <xsl:text>Copyright © </xsl:text>
      <xsl:apply-templates select="/book/bookinfo/copyright/copyrightdate"/>
      <xsl:text> </xsl:text>
      <xsl:apply-templates select="/book/bookinfo/copyright/copyrightholder"/>
      <xsl:text>.</xsl:text>
    </fo:block>

    <fo:block text-align="end" font-size="{$small-print}" space-before="2pt"  hyphenate="false">
        All rights reserved. No part of this publication may be
        reproduced, stored in a retrieval system, or transmitted, in any form,
        or by any means, electronic, mechanical, photocopying, recording, or
        otherwise, without the prior consent of the publisher.
    </fo:block>
  </fo:block-container>
    <!--
      <fo:block>
      <xsl:text>Formatted: </xsl:text>
      .....
      </fo:block>
    -->

    </fo:block>
  </xsl:template>

</xsl:stylesheet>
