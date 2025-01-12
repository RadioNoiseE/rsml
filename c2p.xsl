<xsl:stylesheet version="1.0"
                xmlns="file://fake.path/2025/Markup/RsML"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="mml">

  <!--

    Copyright David Carlisle 2001, 2002, 2008, 2009, 2013.
    Modified  Jing Huang     2025.

    Use and distribution of this code are permitted under the terms of the
    W3C Software Notice and License or Apache 2, MIT or MPL 1.1 or MPL 2.0.

    2001-2002        MathML2
    2008-2009        Updates for MathML3
    2025             Cleanup

  -->

  <xsl:output method="xml" encoding="utf-8" indent="no"
              omit-xml-declaration="yes"/>

  <xsl:template match="/">
    <xsl:apply-templates mode="c2p"/>
  </xsl:template>

  <xsl:template mode="c2p" match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="c2p"/>
    </xsl:element>
  </xsl:template>

  <!-- 4.4.1.1 cn -->

  <xsl:template mode="c2p" match="mml:cn">
    <mn><xsl:apply-templates mode="c2p"/></mn>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cn[@type='complex-cartesian']">
    <mrow>
      <mn><xsl:apply-templates mode="c2p" select="text()[1]"/></mn>
      <mo>+</mo>
      <mn><xsl:apply-templates mode="c2p" select="text()[2]"/></mn>
      <mo>&#8290;</mo>
      <mi>i</mi>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='complex_cartesian']]">
    <mrow>
      <mn><xsl:apply-templates mode="c2p" select="*[2]"/></mn>
      <mo>+</mo>
      <mn><xsl:apply-templates mode="c2p" select="*[3]"/></mn>
      <mo>&#8290;</mo>
      <mi>i</mi>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cn[@type='rational']">
    <mrow>
      <mn><xsl:apply-templates mode="c2p" select="text()[1]"/></mn>
      <mo>/</mo>
      <mn><xsl:apply-templates mode="c2p" select="text()[2]"/></mn>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='rational']]">
    <mrow>
      <mn><xsl:apply-templates mode="c2p" select="*[2]"/></mn>
      <mo>/</mo>
      <mn><xsl:apply-templates mode="c2p" select="*[3]"/></mn>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cn[not(@type) or @type='integer']">
    <xsl:choose>
      <xsl:when test="not(@base) or @base=10">
        <mn><xsl:apply-templates mode="c2p"/></mn>
      </xsl:when>
      <xsl:otherwise>
        <msub>
          <mn><xsl:apply-templates mode="c2p"/></mn>
          <mn><xsl:value-of select="@base"/></mn>
        </msub>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cn[@type='complex-polar']">
    <mrow>
      <mn><xsl:apply-templates mode="c2p" select="text()[1]"/></mn>
      <mo>&#8290;</mo>
      <msup>
        <mi>e</mi>
        <mrow>
          <mi>i</mi>
          <mo>&#8290;</mo>
          <mn><xsl:apply-templates mode="c2p" select="text()[2]"/></mn>
        </mrow>
      </msup>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='complex_polar']]">
    <mrow>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>&#8290;</mo>
      <msup>
        <mi>e</mi>
        <mrow>
          <mi>i</mi>
          <mo>&#8290;</mo>
          <xsl:apply-templates mode="c2p" select="*[3]"/>
        </mrow>
      </msup>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cn[@type='e-notation']">
    <mn>
      <xsl:apply-templates mode="c2p" select="mml:sep/preceding-sibling::node()"/>
      <xsl:text>E</xsl:text>
      <xsl:apply-templates mode="c2p" select="mml:sep/following-sibling::node()"/>
    </mn>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cn[@type='hexdouble']">
    <mn>
      <xsl:text>0x</xsl:text>
      <xsl:apply-templates mode="c2p"/>
    </mn>
  </xsl:template>

  <!-- 4.4.1.1 ci -->

  <xsl:template mode="c2p" match="mml:ci/text()">
    <mi><xsl:value-of select="."/></mi>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:ci">
    <mrow><xsl:apply-templates mode="c2p"/></mrow>
  </xsl:template>

  <!-- 4.4.1.2 csymbol -->

  <xsl:template mode="c2p" match="mml:csymbol/text()">
    <mi><xsl:value-of select="."/></mi>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:csymbol">
    <mrow><xsl:apply-templates mode="c2p"/></mrow>
  </xsl:template>

  <!-- 4.4.2.1 apply & 4.4.2.2 reln -->

  <xsl:template mode="c2p" match="mml:apply|mml:reln">
    <mrow>
      <xsl:choose>
        <xsl:when test="*[1]/*/*">
          <mfenced separators="">
            <xsl:apply-templates mode="c2p" select="*[1]">
              <xsl:with-param name="p" select="10"/>
            </xsl:apply-templates>
          </mfenced>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="c2p" select="*[1]">
            <xsl:with-param name="p" select="10"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
      <mo>&#8289;</mo>
      <mfenced open="(" close=")" separators=",">
        <xsl:apply-templates mode="c2p" select="*[position()>1]"/>
      </mfenced>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:bind">
    <mrow>
      <xsl:choose>
        <xsl:when test="*[1]/*/*">
          <mfenced separators="">
            <xsl:apply-templates mode="c2p" select="*[1]">
              <xsl:with-param name="p" select="10"/>
            </xsl:apply-templates>
          </mfenced>
        </xsl:when>
        <xsl:otherwise>
          <xsl:apply-templates mode="c2p" select="*[1]">
            <xsl:with-param name="p" select="10"/>
          </xsl:apply-templates>
        </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="mml:bvar/*"/>
      <mo>.</mo>
      <xsl:apply-templates mode="c2p" select="*[position()>1][not(self::mml:bvar)]"/>
    </mrow>
  </xsl:template>

  <!-- 4.4.2.3 fn -->

  <xsl:template mode="c2p" match="mml:fn">
    <mrow><xsl:apply-templates mode="c2p"/></mrow>
  </xsl:template>

  <!-- 4.4.2.4 interval -->

  <xsl:template mode="c2p" match="mml:interval[*[2]]">
    <mfenced open="[" close="]">
      <xsl:apply-templates mode="c2p"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:interval[*[2]][@closure='open']" priority="2">
    <mfenced open="(" close=")">
      <xsl:apply-templates mode="c2p"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:interval[*[2]][@closure='open-closed']" priority="2">
    <mfenced open="(" close="]">
      <xsl:apply-templates mode="c2p"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:interval[*[2]][@closure='closed-open']" priority="2">
    <mfenced open="[" close=")">
      <xsl:apply-templates mode="c2p"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:interval">
    <mfenced open="{{" close="}}">
      <xsl:apply-templates mode="c2p"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='integer_interval']]">
    <mfenced open="[" close="]">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='interval']]">
    <mfenced open="[" close="]">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='interval-cc']]">
    <mfenced open="[" close="]">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='interval-oo']]">
    <mfenced open="(" close=")">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='oriented_interval']]">
    <mfenced open="(" close=")">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <!-- 4.4.2.5 inverse -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:inverse]]|
                                  mml:apply[*[1][self::mml:csymbol='inverse']]">
    <msup>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mrow><mo>(</mo><mn>-1</mn><mo>)</mo></mrow>
    </msup>
  </xsl:template>

  <!-- 4.4.2.6 sep -->

  <!-- 4.4.2.7 condition -->

  <xsl:template mode="c2p" match="mml:condition">
    <mrow><xsl:apply-templates mode="c2p"/></mrow>
  </xsl:template>

  <!-- 4.4.2.8 declare -->

  <xsl:template mode="c2p" match="mml:declare"/>

  <!-- 4.4.2.9 lambda -->

  <xsl:template mode="c2p" match="mml:lambda|
                                  mml:apply[*[1][self::mml:csymbol='lambda']]|
                                  mml:bind[*[1][self::mml:csymbol='lambda']]">
    <mrow>
      <mi>&#955;</mi>
      <mrow>
        <xsl:choose>
          <xsl:when test="mml:condition">
            <xsl:apply-templates mode="c2p" select="mml:condition/*"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="c2p" select="mml:bvar/*"/>
          </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="mml:domainofapplication">
          <mo>&#x2208;</mo>
          <xsl:apply-templates mode="c2p" select="mml:domainofapplication/*"/>
        </xsl:if>
      </mrow>
      <mo>.</mo>
      <mfenced><xsl:apply-templates mode="c2p" select="*[last()]"/></mfenced>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:lambda[not(mml:bvar)]" priority="2">
    <mrow>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
      <msub>
        <mo>|</mo>
        <mrow><xsl:apply-templates mode="c2p" select="mml:condition|mml:interval|mml:domainofapplication/*"/></mrow>
      </msub>
    </mrow>
  </xsl:template>

  <!-- 4.4.2.10 compose -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:compose]]|
                                  mml:apply[*[1][self::mml:csymbol='left_compose']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8728;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.2.11 ident -->

  <xsl:template mode="c2p" match="mml:ident">
    <mi>id</mi>
  </xsl:template>

  <!-- 4.4.2.12 domain -->

  <xsl:template mode="c2p" match="mml:domain">
    <mi>domain</mi>
  </xsl:template>

  <!-- 4.4.2.13 codomain -->

  <xsl:template mode="c2p" match="mml:codomain">
    <mi>codomain</mi>
  </xsl:template>

  <!-- 4.4.2.14 image -->

  <xsl:template mode="c2p" match="mml:image">
    <mi>image</mi>
  </xsl:template>

  <!-- 4.4.2.15 domain of application -->

  <xsl:template mode="c2p" match="mml:domainofapplication">
    <merror><mtext>unexpected domainofapplication</mtext></merror>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[2][self::mml:bvar]][mml:domainofapplication]" priority="0.4">
    <mrow>
      <munder>
        <xsl:apply-templates mode="c2p" select="*[1]"/>
        <mrow>
          <xsl:apply-templates mode="c2p" select="mml:bvar/*"/>
          <mo>&#8712;</mo>
          <xsl:apply-templates mode="c2p" select="mml:domainofapplication/*"/>
        </mrow>
      </munder>
      <mfenced><xsl:apply-templates mode="c2p" select="mml:domainofapplication/following-sibling::*"/></mfenced>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[mml:domainofapplication]" priority="0.3">
    <mrow>
      <mrow><mi>restriction</mi>
      <mfenced>
        <xsl:apply-templates mode="c2p" select="*[1]"/>
        <xsl:apply-templates mode="c2p" select="mml:domainofapplication/*"/>
      </mfenced>
      </mrow>
      <mfenced><xsl:apply-templates mode="c2p" select="mml:domainofapplication/following-sibling::*"/></mfenced>
    </mrow>
  </xsl:template>

  <!-- 4.4.2.16 piecewise -->

  <xsl:template mode="c2p" match="mml:piecewise">
    <mrow>
      <mo>{</mo>
      <mtable>
        <xsl:for-each select="mml:piece|mml:otherwise">
          <mtr>
            <mtd><xsl:apply-templates mode="c2p" select="*[1]"/></mtd>
            <xsl:choose>
              <xsl:when test="self::mml:piece">
                <mtd columnalign="left"><mtext>&#160; if &#160;</mtext></mtd>
                <mtd><xsl:apply-templates mode="c2p" select="*[2]"/></mtd>
              </xsl:when>
              <xsl:otherwise>
                <mtd columnspan="2" columnalign="left"><mtext>&#160; otherwise</mtext></mtd>
              </xsl:otherwise>
            </xsl:choose>
          </mtr>
        </xsl:for-each>
      </mtable>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.1 quotient -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:quotient]]|
                                  mml:apply[*[1][self::mml:csymbol='quotient']]">
    <mrow>
      <mo>&#8970;</mo>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>/</mo>
      <xsl:apply-templates mode="c2p" select="*[3]"/>
      <mo>&#8971;</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.2 factorial -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:factorial]]|
                                  mml:apply[*[1][self::mml:csymbol='factorial']]">
    <mrow>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="7"/>
      </xsl:apply-templates>
      <mo>!</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.3 divide -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:divide]]|
                                  mml:apply[*[1][self::mml:csymbol='divide']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>/</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="3"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.4 max min -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:max]]|
                                  mml:apply[*[1][self::mml:csymbol='max']]">
    <mrow>
      <mi>max</mi>
      <xsl:call-template name="set"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:min]]|
                                  mml:reln[*[1][self::mml:min]]">
    <mrow>
      <mi>min</mi>
      <xsl:call-template name="set"/>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.5 minus -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:minus] and count(*)=2]|
                                  mml:apply[*[1][self::mml:csymbol='unary_minus']]">
    <mrow>
      <mo>&#8722;</mo>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="5"/>
      </xsl:apply-templates>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:minus] and count(*)>2]|
                                  mml:apply[*[1][self::mml:csymbol='minus']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>&#8722;</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="2"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.6 plus -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:plus]]|
                                  mml:apply[*[1][self::mml:csymbol='plus']]">
    <xsl:param name="p" select="0"/>
    <mrow>
      <xsl:if test="$p>2"><mo>(</mo></xsl:if>
      <xsl:for-each select="*[position()>1]">
        <xsl:choose>
          <xsl:when test="self::mml:apply[*[1][self::mml:times] and *[2][self::mml:apply/*[1][self::mml:minus] or
                          self::mml:cn[not(mml:sep) and (number(.)&lt;0)]]] or
                          self::mml:apply[count(*)=2 and *[1][self::mml:minus]] or
                          self::mml:cn[not(mml:sep) and (number(.)&lt;0)]">
            <mo>&#8722;</mo>
          </xsl:when>
          <xsl:when test="position()!=1"><mo>+</mo></xsl:when>
        </xsl:choose>
        <xsl:choose>
          <xsl:when test="self::mml:cn[not(mml:sep) and (number(.)&lt;0)]">
            <mn><xsl:value-of select="-(.)"/></mn>
          </xsl:when>
          <xsl:when test="self::mml:apply[count(*)=2 and *[1][self::mml:minus]]">
            <xsl:apply-templates mode="c2p" select="*[2]">
              <xsl:with-param name="first" select="2"/>
              <xsl:with-param name="p" select="2"/>
            </xsl:apply-templates>
          </xsl:when>
          <xsl:when test="self::mml:apply[*[1][self::mml:times] and
                          *[2][self::mml:cn[not(mml:sep) and (number(.)&lt;0)]]]">
            <mrow>
              <mn><xsl:value-of select="-(*[2])"/></mn>
              <mo>&#8290;</mo>
              <xsl:apply-templates mode="c2p" select=".">
                <xsl:with-param name="first" select="2"/>
                <xsl:with-param name="p" select="2"/>
              </xsl:apply-templates>
            </mrow>
          </xsl:when>
          <xsl:when test="self::mml:apply[*[1][self::mml:times] and
                          *[2][self::mml:apply/*[1][self::mml:minus]]]">
            <mrow>
              <xsl:apply-templates mode="c2p" select="./*[2]/*[2]"/>
              <xsl:apply-templates mode="c2p" select=".">
                <xsl:with-param name="first" select="2"/>
                <xsl:with-param name="p" select="2"/>
              </xsl:apply-templates>
            </mrow>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="c2p" select=".">
              <xsl:with-param name="p" select="2"/>
            </xsl:apply-templates>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:for-each>
      <xsl:if test="$p>2"><mo>)</mo></xsl:if>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.7 power -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:power]]|
                                  mml:apply[*[1][self::mml:csymbol='power']]">
    <xsl:param name="p" select="0"/>
    <xsl:choose>
      <xsl:when test="$p>=5">
        <mrow>
          <mo>(</mo>
          <msup>
            <xsl:apply-templates mode="c2p" select="*[2]">
              <xsl:with-param name="p" select="5"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="c2p" select="*[3]">
              <xsl:with-param name="p" select="5"/>
            </xsl:apply-templates>
          </msup>
          <mo>)</mo>
        </mrow>
      </xsl:when>
      <xsl:otherwise>
        <msup>
          <xsl:apply-templates mode="c2p" select="*[2]">
            <xsl:with-param name="p" select="5"/>
          </xsl:apply-templates>
          <xsl:apply-templates mode="c2p" select="*[3]">
            <xsl:with-param name="p" select="5"/>
          </xsl:apply-templates>
        </msup>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- 4.4.3.8 remainder -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:rem]]|
                                  mml:apply[*[1][self::mml:csymbol='rem']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>mod</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="3"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.9 times -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:times]]|
                                  mml:apply[*[1][self::mml:csymbol='times']]" name="times">
    <xsl:param name="p" select="0"/>
    <xsl:param name="first" select="1"/>
    <mrow>
      <xsl:if test="$p>3"><mo>(</mo></xsl:if>
      <xsl:for-each select="*[position()>1]">
        <xsl:if test="position()>1">
          <mo><xsl:choose>
            <xsl:when test="self::mml:cn">&#215;</xsl:when>
            <xsl:otherwise>&#8290;</xsl:otherwise>
          </xsl:choose></mo>
        </xsl:if>
        <xsl:if test="position()>=$first">
          <xsl:apply-templates mode="c2p" select=".">
            <xsl:with-param name="p" select="3"/>
          </xsl:apply-templates>
        </xsl:if>
      </xsl:for-each>
      <xsl:if test="$p>3"><mo>)</mo></xsl:if>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.10 root -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:root] and
                                  not(mml:degree) or mml:degree=2]" priority="4">
    <msqrt><xsl:apply-templates mode="c2p" select="*[position()>1]"/></msqrt>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:root]]">
    <mroot>
      <xsl:apply-templates mode="c2p" select="*[position()>1 and not(self::mml:degree)]"/>
      <mrow><xsl:apply-templates mode="c2p" select="mml:degree/*"/></mrow>
    </mroot>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='root']]">
    <mroot><xsl:apply-templates mode="c2p" select="*[position()!=1]"/></mroot>
  </xsl:template>

  <!-- 4.4.3.11 gcd -->

  <xsl:template mode="c2p" match="mml:gcd">
    <mi>gcd</mi>
  </xsl:template>

  <!-- 4.4.3.12 and -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:and]]|
                                  mml:reln[*[1][self::mml:and]]|
                                  mml:apply[*[1][self::mml:csymbol='and']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8743;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.13 or -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:or]]|
                                  mml:apply[*[1][self::mml:csymbol='or']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="3"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8744;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.14 xor -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:xor]]|
                                  mml:apply[*[1][self::mml:csymbol='xor']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="3"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>xor</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.15 not -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:not]]|
                                  mml:apply[*[1][self::mml:csymbol='not']]">
    <mrow>
      <mo>&#172;</mo>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="7"/>
      </xsl:apply-templates>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.16 implies -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:implies]]|
                                  mml:reln[*[1][self::mml:implies]]|
                                  mml:apply[*[1][self::mml:csymbol='implies']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>&#8658;</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="3"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.3.17 forall -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:forall]]|
                                  mml:apply[*[1][self::mml:csymbol='forall']]|
                                  mml:bind[*[1][self::mml:forall]]|
                                  mml:bind[*[1][self::mml:csymbol='forall']]">
    <mrow>
      <mo>&#8704;</mo>
      <mrow><xsl:apply-templates mode="c2p" select="mml:bvar[not(current()/mml:condition)]/*|mml:condition/*"/></mrow>
      <mo>.</mo>
      <mfenced><xsl:apply-templates mode="c2p" select="*[last()]"/></mfenced>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.18 exists -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:exists]]|
                                  mml:apply[*[1][self::mml:csymbol='exists']]|
                                  mml:bind[*[1][self::mml:exists]]|
                                  mml:bind[*[1][self::mml:csymbol='exists']]">
    <mrow>
      <mo>&#8707;</mo>
      <mrow><xsl:apply-templates mode="c2p" select="mml:bvar[not(current()/mml:condition)]/*|mml:condition/*"/></mrow>
      <mo>.</mo>
      <mfenced separators="">
        <xsl:choose>
          <xsl:when test="mml:condition">
            <xsl:apply-templates mode="c2p" select="mml:condition/*"/>
            <mo>&#8743;</mo>
          </xsl:when>
          <xsl:when test="mml:domainofapplication">
            <mrow>
              <mrow>
                <xsl:for-each select="mml:bvar">
                  <xsl:apply-templates mode="c2p"/>
                  <xsl:if test="position()!=last()"><mo>,</mo></xsl:if>
                </xsl:for-each>
              </mrow>
              <mo>&#8712;</mo>
              <xsl:apply-templates mode="c2p" select="mml:domainofapplication/*"/>
            </mrow>
            <mo>&#8743;</mo>
          </xsl:when>
        </xsl:choose>
        <xsl:apply-templates mode="c2p" select="*[last()]"/>
      </mfenced>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.19 abs -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:abs]]|
                                  mml:apply[*[1][self::mml:csymbol='abs']]">
    <mrow>
      <mo>|</mo>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>|</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.20 conjugate -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:conjugate]]|
                                  mml:apply[*[1][self::mml:csymbol='conjugate']]">
    <mover>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>&#175;</mo>
    </mover>
  </xsl:template>

  <!-- 4.4.3.21 arg -->

  <xsl:template mode="c2p" match="mml:arg">
    <mi>arg</mi>
  </xsl:template>

  <!-- 4.4.3.22 real -->

  <xsl:template mode="c2p" match="mml:real|mml:csymbol[.='real']">
    <mo>&#8475;</mo>
  </xsl:template>

  <!-- 4.4.3.23 imaginary -->

  <xsl:template mode="c2p" match="mml:imaginary|mml:csymbol[.='imaginary']">
    <mo>&#8465;</mo>
  </xsl:template>

  <!-- 4.4.3.24 lcm -->

  <xsl:template mode="c2p" match="mml:lcm">
    <mi>lcm</mi>
  </xsl:template>

  <!-- 4.4.3.25 floor -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:floor]]|
                                  mml:apply[*[1][self::mml:csymbol='floor']]">
    <mrow>
      <mo>&#8970;</mo>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>&#8971;</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.3.25 ceiling -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:ceiling]]|
                                  mml:apply[*[1][self::mml:csymbol='ceiling']]">
    <mrow>
      <mo>&#8968;</mo>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>&#8969;</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.4.1 eq -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:eq]]|
                                  mml:reln[*[1][self::mml:eq]]|
                                  mml:apply[*[1][self::mml:csymbol='eq']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>=</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.2 neq -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:neq]]|
                                  mml:apply[*[1][self::mml:csymbol='neq']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8800;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.3 gt -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:gt]]|
                                  mml:reln[*[1][self::mml:gt]]|
                                  mml:apply[*[1][self::mml:csymbol='gt']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&gt;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.4 lt -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:lt]]|
                                  mml:reln[*[1][self::mml:lt]]|
                                  mml:apply[*[1][self::mml:csymbol='lt']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&lt;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.5 geq -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:geq]]|
                                  mml:apply[*[1][self::mml:csymbol='geq']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8805;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.6 leq -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:leq]]|
                                  mml:apply[*[1][self::mml:csymbol='leq']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8804;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.7 equivalent -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:equivalent]]|
                                  mml:apply[*[1][self::mml:csymbol='equivalent']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8801;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.8 approx -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:approx]]|
                                  mml:apply[*[1][self::mml:csymbol='approx']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="1"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8771;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.4.9 factor of -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:factorof]]|
                                  mml:apply[*[1][self::mml:csymbol='factorof']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>|</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="3"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.5.1 int -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:int]]|
                                  mml:apply[*[1][self::mml:csymbol='int']]|
                                  mml:bind[*[1][self::mml:int]]|
                                  mml:bind[*[1][self::mml:csymbol='int']]">
    <mrow>
      <msubsup>
        <mi>&#8747;</mi>
        <mrow><xsl:apply-templates mode="c2p" select="mml:lowlimit/*|mml:interval/*[1]|mml:condition/*|mml:domainofapplication/*"/></mrow>
        <mrow><xsl:apply-templates mode="c2p" select="mml:uplimit/*|mml:interval/*[2]"/></mrow>
      </msubsup>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
      <xsl:if test="mml:bvar">
        <mi>d</mi>
        <xsl:apply-templates mode="c2p" select="mml:bvar"/>
      </xsl:if>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='defint']]">
    <mrow>
      <munder>
        <mi>&#8747;</mi>
        <xsl:apply-templates mode="c2p" select="*[2]"/>
      </munder>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
    </mrow>
  </xsl:template>

  <!-- 4.4.5.2 diff -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:diff] and not(mml:bvar)]|
                                  mml:apply[*[1][self::mml:csymbol='diff']]" priority="2">
    <msup>
      <mrow><xsl:apply-templates mode="c2p" select="*[2]"/></mrow>
      <mo>&#8242;</mo>
    </msup>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:diff]]" priority="1">
    <mfrac>
      <xsl:choose>
        <xsl:when test="mml:bvar/mml:degree">
          <mrow>
            <msup>
              <mi>d</mi>
              <xsl:apply-templates mode="c2p" select="mml:bvar/mml:degree/node()"/>
            </msup>
            <xsl:apply-templates mode="c2p" select="*[last()]"/>
          </mrow>
          <mrow>
            <mi>d</mi>
            <msup>
              <xsl:apply-templates mode="c2p" select="mml:bvar/node()"/>
              <xsl:apply-templates mode="c2p" select="mml:bvar/mml:degree/node()"/>
            </msup>
          </mrow>
        </xsl:when>
        <xsl:otherwise>
          <mrow><mi>d</mi><xsl:apply-templates mode="c2p" select="*[last()]"/></mrow>
          <mrow><mi>d</mi><xsl:apply-templates mode="c2p" select="mml:bvar"/></mrow>
        </xsl:otherwise>
      </xsl:choose>
    </mfrac>
  </xsl:template>

  <!-- 4.4.5.3 partial diff -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:partialdiff] and
                                  mml:list and not(mml:bvar) and count(*)=3]" priority="2">
    <mrow>
      <msub>
        <mi>D</mi>
        <mrow>
          <xsl:for-each select="mml:list[1]/*">
            <xsl:apply-templates mode="c2p" select="."/>
            <xsl:if test="position()&lt;last()"><mo>,</mo></xsl:if>
          </xsl:for-each>
        </mrow>
      </msub>
      <mrow><xsl:apply-templates mode="c2p" select="*[3]"/></mrow>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:partialdiff] and
                                  mml:list and mml:lambda]" priority="3">
    <mfrac>
      <mrow>
        <xsl:choose>
          <xsl:when test="count(mml:list/*)=1">
            <mo>&#8706;</mo>
          </xsl:when>
          <xsl:otherwise>
            <msup>
              <mo>&#8706;</mo>
              <mrow>
                <xsl:choose>
                  <xsl:when test="mml:degree">
                    <xsl:apply-templates mode="c2p" select="mml:degree/node()"/>
                  </xsl:when>
                  <xsl:otherwise>
                    <mn><xsl:value-of select="count(mml:list/*)"/></mn>
                  </xsl:otherwise>
                </xsl:choose>
              </mrow>
            </msup>
          </xsl:otherwise>
        </xsl:choose>
      <xsl:apply-templates mode="c2p" select="mml:lambda/*[last()]"/></mrow>
      <mrow><xsl:call-template name="pddx"/></mrow>
    </mfrac>
  </xsl:template>

  <xsl:template name="pddx">
    <xsl:param name="n" select="1"/>
    <xsl:param name="b" select="mml:lambda/mml:bvar"/>
    <xsl:param name="l" select="mml:list/*"/>
    <xsl:choose>
      <xsl:when test="number($l[1])=number($l[2])">
        <xsl:call-template name="pddx">
          <xsl:with-param name="n" select="$n+1"/>
          <xsl:with-param name="b" select="$b"/>
          <xsl:with-param name="l" select="$l[position()!=1]"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <mrow>
          <mo>&#8706;</mo>
          <xsl:choose>
            <xsl:when test="$n=1">
              <xsl:apply-templates select="$b[position()=$l[1]]/*"/>
            </xsl:when>
            <xsl:otherwise><msup>
              <xsl:apply-templates select="$b[position()=$l[1]]/*"/>
              <mn><xsl:value-of select="$n"/></mn>
            </msup></xsl:otherwise>
          </xsl:choose>
        </mrow>
        <xsl:if test="$l[2]">
          <xsl:call-template name="pddx">
            <xsl:with-param name="b" select="$b"/>
            <xsl:with-param name="l" select="$l[position()!=1]"/>
          </xsl:call-template>
        </xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:partialdiff]]" priority="1">
    <mfrac>
      <mrow>
        <xsl:choose>
          <xsl:when test="not(mml:bvar/mml:degree) and not(mml:bvar[2])">
            <mo>&#8706;</mo>
          </xsl:when>
          <xsl:otherwise>
            <msup>
              <mo>&#8706;</mo>
              <mrow>
                <xsl:choose>
                  <xsl:when test="mml:degree">
                    <xsl:apply-templates mode="c2p" select="mml:degree/node()"/>
                  </xsl:when>
                  <xsl:when test="mml:bvar/mml:degree[string(number(.))='NaN']">
                    <xsl:for-each select="mml:bvar/mml:degree">
                      <xsl:apply-templates mode="c2p" select="node()"/>
                      <xsl:if test="position()&lt;last()"><mo>+</mo></xsl:if>
                    </xsl:for-each>
                    <xsl:if test="count(mml:bvar[not(mml:degree)])>0">
                      <mo>+</mo>
                      <mn><xsl:value-of select="count(mml:bvar[not(mml:degree)])"/></mn>
                    </xsl:if>
                  </xsl:when>
                  <xsl:otherwise><mn>
                    <xsl:value-of select="number(sum(mml:bvar/mml:degree))+count(mml:bvar[not(mml:degree)])"/>
                  </mn></xsl:otherwise>
                </xsl:choose>
              </mrow>
            </msup>
          </xsl:otherwise>
        </xsl:choose>
      <xsl:apply-templates mode="c2p" select="*[last()]"/></mrow>
      <mrow>
        <xsl:for-each select="mml:bvar">
          <mrow>
            <mo>&#8706;</mo>
            <msup>
              <xsl:apply-templates mode="c2p" select="node()"/>
              <mrow><xsl:apply-templates mode="c2p" select="mml:degree/node()"/></mrow>
            </msup>
          </mrow>
        </xsl:for-each>
      </mrow>
    </mfrac>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='partialdiffdegree']]">
    <mrow>
      <msub>
        <mo>&#8706;</mo>
        <mrow><xsl:apply-templates mode="c2p" select="*[2]"/></mrow>
      </msub>
      <mfenced><xsl:apply-templates mode="c2p" select="*[4]"/></mfenced>
    </mrow>
  </xsl:template>

  <!-- 4.4.5.4 low limit -->

  <xsl:template mode="c2p" match="mml:lowlimit"/>

  <!-- 4.4.5.5 up limit -->

  <xsl:template mode="c2p" match="mml:uplimit"/>

  <!-- 4.4.5.6 bvar -->

  <xsl:template mode="c2p" match="mml:bvar">
    <mi><xsl:apply-templates mode="c2p"/></mi>
    <xsl:if test="following-sibling::mml:bvar"><mo>,</mo></xsl:if>
  </xsl:template>

  <!-- 4.4.5.7 degree -->

  <xsl:template mode="c2p" match="mml:degree"/>

  <!-- 4.4.5.8 divergence -->

  <xsl:template mode="c2p" match="mml:divergence">
    <mi>div</mi>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:divergence] and mml:bvar and mml:vector]">
    <xsl:variable name="v" select="mml:bvar"/>
    <mrow>
      <mi>div</mi>
      <mo>&#8289;</mo>
      <mo>(</mo>
      <mtable>
        <xsl:for-each select="mml:vector/*">
          <xsl:variable name="p" select="position()"/>
          <mtr><mtd>
            <xsl:apply-templates mode="c2p" select="$v[$p]/*"/>
            <mo>&#x21a6;</mo>
            <xsl:apply-templates mode="c2p" select="."/>
          </mtd></mtr>
        </xsl:for-each>
      </mtable>
      <mo>)</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.5.9 grad -->

  <xsl:template mode="c2p" match="mml:grad">
    <mi>grad</mi>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:grad] and mml:bvar]">
    <mrow>
      <mi>grad</mi>
      <mo>&#8289;</mo>
      <mrow>
        <mo>(</mo>
        <mfenced><xsl:apply-templates mode="c2p" select="mml:bvar/*"/></mfenced>
        <mo>&#x21a6;</mo>
        <xsl:apply-templates mode="c2p" select="*[position()!=1][not(self::mml:bvar)]"/>
        <mo>)</mo>
      </mrow>
    </mrow>
  </xsl:template>

  <!-- 4.4.5.10 curl -->

  <xsl:template mode="c2p" match="mml:curl">
    <mi>curl</mi>
  </xsl:template>

  <!-- 4.4.5.11 laplacian -->

  <xsl:template mode="c2p" match="mml:laplacian">
    <msup><mo>&#8711;</mo><mn>2</mn></msup>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:laplacian] and mml:bvar]">
    <mrow>
      <xsl:apply-templates mode="c2p" select="*[1]"/>
      <mo>&#8289;</mo>
      <mrow>
        <mo>(</mo>
        <mfenced><xsl:apply-templates mode="c2p" select="mml:bvar/*"/></mfenced>
        <mo>&#x21a6;</mo>
        <xsl:apply-templates mode="c2p" select="*[position()!=1][not(self::mml:bvar)]"/>
        <mo>)</mo>
      </mrow>
    </mrow>
  </xsl:template>

  <!-- 4.4.6.1 set -->

  <xsl:template mode="c2p" match="mml:set">
    <xsl:call-template name="set"/>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='set']]">
    <mfenced open="{{" close="}}" separators=",">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <!-- 4.4.6.2 list -->

  <xsl:template mode="c2p" match="mml:list">
    <xsl:call-template name="set">
      <xsl:with-param name="o" select="'('"/>
      <xsl:with-param name="c" select="')'"/>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='list']]">
    <mfenced open="(" close=")" separators=",">
      <xsl:apply-templates mode="c2p" select="*[position()!=1]"/>
    </mfenced>
  </xsl:template>

  <!-- 4.4.6.3 union -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:union]]|
                                  mml:apply[*[1][self::mml:csymbol='union']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8746;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:union]][mml:bvar]|
                                  mml:apply[*[1][self::mml:csymbol='union']][mml:bvar]" priority="2">
    <xsl:call-template name="sum">
      <xsl:with-param name="mo"><mo>&#x22C3;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.4 intersect -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:intersect]]|
                                  mml:apply[*[1][self::mml:csymbol='intersect']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="3"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8745;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:intersect]][mml:bvar]|
                                  mml:apply[*[1][self::mml:csymbol='intersect']][mml:bvar]" priority="2">
    <xsl:call-template name="sum">
      <xsl:with-param name="mo"><mo>&#x22C2;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.5 in -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:in]]|
                                  mml:apply[*[1][self::mml:csymbol='in']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>&#8712;</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="3"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.5 not in -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:notin]]|mml:reln[*[1][self::mml:notin]]|
                                  mml:apply[*[1][self::mml:csymbol='notin']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="mo"><mo>&#8713;</mo></xsl:with-param>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="this-p" select="3"/>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.7 subset -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:subset]]|
                                  mml:apply[*[1][self::mml:csymbol='subset']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8838;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.8 prsubset -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:prsubset]]|
                                  mml:apply[*[1][self::mml:csymbol='prsubset']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8834;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.9 not subset -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:notsubset]]|
                                  mml:apply[*[1][self::mml:csymbol='notsubset']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8840;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.10 not prsubset -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:notprsubset]]|
                                  mml:apply[*[1][self::mml:csymbol='notprsubset']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8836;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.11 set diff -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:setdiff]]|
                                  mml:apply[*[1][self::mml:csymbol='setdiff']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#8726;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.6.12 card -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:card]]|
                                  mml:apply[*[1][self::mml:csymbol='card']]">
    <mrow>
      <mo>|</mo>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>|</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.6.13 cartesian product -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:cartesianproduct or self::mml:vectorproduct]]|
                                  mml:apply[*[1][self::mml:csymbol[.='cartesian_product' or .='vectorproduct']]]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#215;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template
      match="apply[*[1][self::mml:cartesianproduct][count(following-sibling::mml:reals)=count(following-sibling::*)]]" priority="2">
    <msup>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="5"/>
      </xsl:apply-templates>
      <mn><xsl:value-of select="count(*)-1"/></mn>
    </msup>
  </xsl:template>

  <!-- 4.4.7.1 sum -->

  <xsl:template name="sum" mode="c2p" match="mml:apply[*[1][self::mml:sum]]">
    <xsl:param name="mo"><mo>&#8721;</mo></xsl:param>
    <mrow>
      <munderover>
        <xsl:copy-of select="$mo"/>
        <mrow><xsl:apply-templates mode="c2p" select="mml:lowlimit|mml:interval/*[1]|mml:condition/*|mml:domainofapplication/*"/></mrow>
        <mrow><xsl:apply-templates mode="c2p" select="mml:uplimit/*|mml:interval/*[2]"/></mrow>
      </munderover>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='sum']]">
    <mrow>
      <munder>
        <mo>&#8721;</mo>
        <xsl:apply-templates mode="c2p" select="*[2]"/>
      </munder>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply/mml:lowlimit" priority="3">
    <mrow>
      <xsl:if test="../mml:bvar">
        <xsl:apply-templates mode="c2p" select="../mml:bvar/node()"/>
        <mo>=</mo>
      </xsl:if>
      <xsl:apply-templates mode="c2p"/>
    </mrow>
  </xsl:template>

  <!-- 4.4.7.2 product -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:product]]">
    <xsl:call-template name="sum">
      <xsl:with-param name="mo"><mo>&#8719;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='product']]">
    <mrow>
      <munder>
        <mo>&#8719;</mo>
        <xsl:apply-templates mode="c2p" select="*[2]"/>
      </munder>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
    </mrow>
  </xsl:template>

  <!-- 4.4.7.3 limit -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:limit]]">
    <mrow>
      <munder>
        <mi>lim</mi>
        <mrow><xsl:apply-templates mode="c2p" select="mml:lowlimit|mml:condition/*"/></mrow>
      </munder>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='limit']][mml:bind]">
    <mrow>
      <munder>
        <mi>lim</mi>
        <mrow>
          <xsl:apply-templates mode="c2p" select="mml:bind/mml:bvar/*"/>
          <mo>
            <xsl:choose>
              <xsl:when test="*[3]='above'">&#8600;</xsl:when>
              <xsl:when test="*[3]='below'">&#8599;</xsl:when>
              <xsl:otherwise>&#8594;</xsl:otherwise>
            </xsl:choose>
          </mo>
          <xsl:apply-templates mode="c2p" select="*[2]"/>
        </mrow>
      </munder>
      <xsl:apply-templates mode="c2p" select="mml:bind/*[last()]"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[mml:limit]/mml:lowlimit" priority="4">
    <mrow>
      <xsl:apply-templates mode="c2p" select="../mml:bvar/node()"/>
      <mo>&#8594;</mo>
      <xsl:apply-templates mode="c2p"/>
    </mrow>
  </xsl:template>

  <!-- 4.4.7.4 tends to -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:tendsto]]|
                                  mml:reln[*[1][self::mml:tendsto]]">
    <xsl:param name="p"/>
    <xsl:call-template name="binary">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>
        <xsl:choose>
          <xsl:when test="@type='above'">&#8600;</xsl:when>
          <xsl:when test="@type='below'">&#8599;</xsl:when>
          <xsl:when test="@type='two-sided'">&#8594;</xsl:when>
          <xsl:otherwise>&#8594;</xsl:otherwise>
        </xsl:choose>
      </mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='tendsto']]">
    <mrow>
      <xsl:apply-templates mode="c2p" select="*[3]"/>
      <mo><xsl:choose>
        <xsl:when test="*[1][self::above]">&#8600;</xsl:when>
        <xsl:when test="*[1][self::below]">&#8599;</xsl:when>
        <xsl:when test="*[1][self::two-sided]">&#8594;</xsl:when>
        <xsl:otherwise>&#8594;</xsl:otherwise>
      </xsl:choose></mo>
      <xsl:apply-templates mode="c2p" select="*[4]"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:semantics/mml:ci='tendsto']]">
    <mrow>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <mo>&#8594;</mo>
      <xsl:apply-templates mode="c2p" select="*[3]"/>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:tendsto">
    <mi>tendsto</mi>
  </xsl:template>

  <!-- 4.4.8.1 trig -->

  <xsl:template mode="c2p" match="apply[*[1][
                                  self::mml:sin or self::mml:cos or self::mml:tan or
                                  self::mml:sec or self::mml:csc or self::mml:cot or
                                  self::mml:sinh or self::mml:cosh or self::mml:tanh or
                                  self::mml:sech or self::mml:csch or self::mml:coth or
                                  self::mml:arcsin or self::mml:arccos or self::mml:arctan or
                                  self::mml:arcsec or self::mml:arccsc or self::mml:arccot or
                                  self::mml:arcsinh or self::mml:arccosh or self::mml:arctanh or
                                  self::mml:arcsech or self::mml:arccsch or self::mml:arccoth or
                                  self::mml:ln]]">
    <mrow>
      <mi><xsl:value-of select="local-name(*[1])"/></mi>
      <mo>&#8289;</mo>
      <xsl:if test="mml:apply"><mo>(</mo></xsl:if>
      <xsl:apply-templates mode="c2p" select="*[2]"/>
      <xsl:if test="mml:apply"><mo>)</mo></xsl:if>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:sin|mml:cos|mml:tan|mml:sec|mml:csc|mml:cot|
                                  mml:sinh|mml:cosh|mml:tanh|mml:sech|mml:csch|mml:coth|
                                  mml:arcsin|mml:arccos|mml:arctan|mml:arcsec|mml:arccsc|mml:arccot|
                                  mml:arcsinh|mml:arccosh|mml:arctanh|mml:arcsech|mml:arccsch|mml:arccoth|
                                  mml:ln|mml:mean|mml:plus|mml:minus">
    <mi><xsl:value-of select="local-name()"/></mi>
  </xsl:template>

  <!-- 4.4.8.2 exp -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:exp]]|
                                  mml:apply[*[1][self::mml:csymbol='exp']]">
    <msup>
      <mi>e</mi>
      <mrow><xsl:apply-templates mode="c2p" select="*[2]"/></mrow>
    </msup>
  </xsl:template>

  <!-- 4.4.8.3 ln with trig -->

  <!-- 4.4.8.4 log -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:log]]|
                                  mml:apply[*[1][self::mml:csymbol='log']]">
    <mrow>
      <xsl:choose>
        <xsl:when test="not(mml:logbase) or mml:logbase=10">
          <mi>log</mi>
        </xsl:when>
        <xsl:otherwise>
          <msub>
            <mi>log</mi>
            <mrow><xsl:apply-templates mode="c2p" select="mml:logbase/node()"/></mrow>
          </msub>
        </xsl:otherwise>
      </xsl:choose>
      <mo>&#8289;</mo>
      <xsl:apply-templates mode="c2p" select="*[last()]">
        <xsl:with-param name="p" select="7"/>
      </xsl:apply-templates>
    </mrow>
  </xsl:template>

  <!-- 4.4.9.1 mean -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:mean]]|
                                  mml:apply[*[1][self::mml:csymbol='mean']]">
    <mrow>
      <mo>&#9001;</mo>
      <xsl:for-each select="*[position()&gt;1]">
        <xsl:apply-templates mode="c2p" select="."/>
        <xsl:if test="position()!=last()"><mo>,</mo></xsl:if>
      </xsl:for-each>
      <mo>&#9002;</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.9.2 sdef -->

  <xsl:template mode="c2p" match="mml:sdev|mml:csymbol[.='sdev']">
    <mo>&#963;</mo>
  </xsl:template>

  <!-- 4.4.9.3 variance -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:variance]]|
                                  mml:apply[*[1][self::mml:csymbol='variance']]">
    <msup>
      <mrow>
        <mo>&#963;</mo>
        <mo>&#8289;</mo>
        <mfenced><xsl:apply-templates mode="c2p" select="*[position()!=1]"/></mfenced>
      </mrow>
      <mn>2</mn>
    </msup>
  </xsl:template>

  <!-- 4.4.9.4 median -->

  <xsl:template mode="c2p" match="mml:median">
    <mi>median</mi>
  </xsl:template>

  <!-- 4.4.9.5 mode -->

  <xsl:template mode="c2p" match="mml:mode">
    <mi>mode</mi>
  </xsl:template>

  <!-- 4.4.9.5 moment -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:moment]]">
    <mrow>
      <mo>&#9001;</mo>
      <msup>
        <xsl:variable name="data" select="*[not(position()=1)][not(self::mml:degree or self::mml:momentabout)]"/>
        <xsl:choose>
          <xsl:when test="$data[2]">
            <mfenced><xsl:apply-templates mode="c2p" select="$data"/></mfenced>
          </xsl:when>
          <xsl:otherwise>
            <xsl:apply-templates mode="c2p" select="$data"/>
          </xsl:otherwise>
        </xsl:choose>
        <mrow><xsl:apply-templates mode="c2p" select="mml:degree/node()"/></mrow>
      </msup>
      <mo>&#9002;</mo>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='moment']]">
    <msub>
      <mrow>
        <mo>&#9001;</mo>
        <msup>
          <xsl:apply-templates mode="c2p" select="*[4]"/>
          <xsl:apply-templates mode="c2p" select="*[2]"/>
        </msup>
        <mo>&#9002;</mo>
      </mrow>
      <xsl:apply-templates mode="c2p" select="*[3]"/>
    </msub>
  </xsl:template>

  <!-- 4.4.9.5 moment about -->

  <xsl:template mode="c2p" match="mml:momentabout"/>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:moment]][mml:momentabout]" priority="2">
    <msub>
      <mrow>
        <mo>&#9001;</mo>
        <msup>
          <xsl:variable name="data" select="*[not(position()=1)][not(self::mml:degree or self::mml:momentabout)]"/>
          <xsl:choose>
            <xsl:when test="$data[2]">
              <mfenced><xsl:apply-templates mode="c2p" select="$data"/></mfenced>
            </xsl:when>
            <xsl:otherwise>
              <xsl:apply-templates mode="c2p" select="$data"/>
            </xsl:otherwise>
          </xsl:choose>
          <mrow><xsl:apply-templates mode="c2p" select="mml:degree/node()"/></mrow>
        </msup>
        <mo>&#9002;</mo>
      </mrow>
      <mrow><xsl:apply-templates mode="c2p" select="mml:momentabout/*"/></mrow>
    </msub>
  </xsl:template>

  <!-- 4.4.10.1 vector -->

  <xsl:template mode="c2p" match="mml:vector">
    <mrow>
      <mo>(</mo>
      <mtable>
        <xsl:for-each select="*">
          <mtr><mtd><xsl:apply-templates mode="c2p" select="."/></mtd></mtr>
        </xsl:for-each>
      </mtable>
      <mo>)</mo>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:vector[mml:condition]">
    <mrow>
      <mo>[</mo>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
      <mo>|</mo>
      <xsl:apply-templates mode="c2p" select="mml:condition"/>
      <mo>]</mo>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:vector[mml:domainofapplication]">
    <mrow>
      <mo>[</mo>
      <xsl:apply-templates mode="c2p" select="*[last()]"/>
      <mo>|</mo>
      <xsl:apply-templates mode="c2p" select="mml:bvar/*"/>
      <mo>&#x2208;</mo>
      <xsl:apply-templates mode="c2p" select="mml:domainofapplication/*"/>
      <mo>]</mo>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='vector']]">
    <mrow>
      <mo>(</mo>
      <mtable>
        <xsl:for-each select="*[position()!=1]">
          <mtr><mtd><xsl:apply-templates mode="c2p" select="."/></mtd></mtr>
        </xsl:for-each>
      </mtable>
      <mo>)</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.10.2 matrix -->

  <xsl:template mode="c2p" match="mml:matrix">
    <mrow>
      <mo>(</mo>
      <mtable><xsl:apply-templates mode="c2p"/></mtable>
      <mo>)</mo>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:matrix[mml:condition]">
    <mrow>
      <mo>[</mo>
      <msub>
        <mi>m</mi>
        <mrow>
          <xsl:for-each select="mml:bvar">
            <xsl:apply-templates mode="c2p"/>
            <xsl:if test="position()!=last()"><mo>,</mo></xsl:if>
          </xsl:for-each>
        </mrow>
      </msub>
      <mo>|</mo>
      <mrow>
        <msub>
          <mi>m</mi>
          <mrow>
            <xsl:for-each select="mml:bvar">
              <xsl:apply-templates mode="c2p"/>
              <xsl:if test="position()!=last()"><mo>,</mo></xsl:if>
            </xsl:for-each>
          </mrow>
        </msub>
        <mo>=</mo>
        <xsl:apply-templates mode="c2p" select="*[last()]"/>
      </mrow>
      <mo>;</mo>
      <xsl:apply-templates mode="c2p" select="mml:condition"/>
      <mo>]</mo>
    </mrow>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol='matrix']]">
    <mrow>
      <mo>(</mo>
      <mtable><xsl:apply-templates mode="c2p" select="*[position()!=1]"/></mtable>
      <mo>)</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.10.3 matrix row -->

  <xsl:template mode="c2p" match="mml:matrix/mml:matrixrow">
    <mtr>
      <xsl:for-each select="*">
        <mtd><xsl:apply-templates mode="c2p" select="."/></mtd>
      </xsl:for-each>
    </mtr>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:matrixrow">
    <mtable><mtr>
      <xsl:for-each select="*">
        <mtd><xsl:apply-templates mode="c2p" select="."/></mtd>
      </xsl:for-each>
    </mtr></mtable>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:csymbol.='matrixrow']]">
    <mtr>
      <xsl:for-each select="*[position()!=1]">
        <mtd><xsl:apply-templates mode="c2p" select="."/></mtd>
      </xsl:for-each>
    </mtr>
  </xsl:template>

  <!-- 4.4.10.4 determinant -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:determinant]]|
                                  mml:apply[*[1][self::mml:csymbol='determinant']]">
    <mrow>
      <mi>det</mi>
      <mo>&#8289;</mo>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="7"/>
      </xsl:apply-templates>
    </mrow>
  </xsl:template>

  <xsl:template
      match="mml:apply[*[1][self::mml:determinant]][*[2][self::mml:matrix]]" priority="2">
    <mrow>
      <mo>|</mo>
      <mtable><xsl:apply-templates mode="c2p" select="mml:matrix/*"/></mtable>
      <mo>|</mo>
    </mrow>
  </xsl:template>

  <!-- 4.4.10.5 transpose -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:transpose]]|
                                  mml:apply[*[1][self::mml:csymbol='transpose']]">
    <msup>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="7"/>
      </xsl:apply-templates>
      <mi>T</mi>
    </msup>
  </xsl:template>

  <!-- 4.4.10.5 selector -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:selector]]|
                                  mml:apply[*[1][self::mml:csymbol='selector']]">
    <msub>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="7"/>
      </xsl:apply-templates>
      <mrow>
        <xsl:for-each select="*[position()>2]">
          <xsl:apply-templates mode="c2p" select="."/>
          <xsl:if test="position()!=last()"><mo>,</mo></xsl:if>
        </xsl:for-each>
      </mrow>
    </msub>
  </xsl:template>

  <!-- 4.4.10.6 vector product -->

  <!-- 4.4.10.7 scalar product -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:scalarproduct]]|
                                  mml:apply[*[1][self::csymbol='mml:scalarproduct']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>.</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.10.8 outer product -->

  <xsl:template mode="c2p" match="mml:apply[*[1][self::mml:outerproduct]]|
                                  mml:apply[*[1][self::mml:csymbol='outerproduct']]">
    <xsl:param name="p" select="0"/>
    <xsl:call-template name="infix">
      <xsl:with-param name="this-p" select="2"/>
      <xsl:with-param name="p" select="$p"/>
      <xsl:with-param name="mo"><mo>&#x2297;</mo></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <!-- 4.4.11.2 semantics -->

  <xsl:template mode="c2p" match="mml:semantics">
    <xsl:apply-templates mode="c2p" select="*[1]"/>
  </xsl:template>
  <xsl:template mode="c2p" match="mml:semantics[mml:annotation-xml/@encoding='MathML-Presentation']">
    <xsl:apply-templates mode="c2p" select="mml:annotation-xml[@encoding='MathML-Presentation']/node()"/>
  </xsl:template>

  <!-- 4.4.12.1 integers -->

  <xsl:template mode="c2p" match="mml:integers">
    <mi mathvariant="double-struck">Z</mi>
  </xsl:template>

  <!-- 4.4.12.2 reals -->

  <xsl:template mode="c2p" match="mml:reals">
    <mi mathvariant="double-struck">R</mi>
  </xsl:template>

  <!-- 4.4.12.3 rationals -->

  <xsl:template mode="c2p" match="mml:rationals">
    <mi mathvariant="double-struck">Q</mi>
  </xsl:template>

  <!-- 4.4.12.4 natural numbers -->

  <xsl:template mode="c2p" match="mml:naturalnumbers">
    <mi mathvariant="double-struck">N</mi>
  </xsl:template>

  <!-- 4.4.12.5 complexes -->

  <xsl:template mode="c2p" match="mml:complexes">
    <mi mathvariant="double-struck">C</mi>
  </xsl:template>

  <!-- 4.4.12.6 primes -->

  <xsl:template mode="c2p" match="mml:primes">
    <mi mathvariant="double-struck">P</mi>
  </xsl:template>

  <!-- 4.4.12.7 exponential e -->

  <xsl:template mode="c2p" match="mml:exponentiale">
    <mi>e</mi>
  </xsl:template>

  <!-- 4.4.12.8 imaginary i -->

  <xsl:template mode="c2p" match="mml:imaginaryi">
    <mi>i</mi>
  </xsl:template>

  <!-- 4.4.12.9 not a number -->

  <xsl:template mode="c2p" match="mml:notanumber">
    <mi>NaN</mi>
  </xsl:template>

  <!-- 4.4.12.10 true -->

  <xsl:template mode="c2p" match="mml:true">
    <mi>true</mi>
  </xsl:template>

  <!-- 4.4.12.11 false -->

  <xsl:template mode="c2p" match="mml:false">
    <mi>false</mi>
  </xsl:template>

  <!-- 4.4.12.12 empty set -->

  <xsl:template mode="c2p" match="mml:emptyset|mml:csymbol[.='emptyset']">
    <mi>&#8709;</mi>
  </xsl:template>

  <!-- 4.4.12.13 pi -->

  <xsl:template mode="c2p" match="mml:pi|mml:csymbol[.='pi']">
    <mi>&#960;</mi>
  </xsl:template>

  <!-- 4.4.12.14 euler gamma -->

  <xsl:template mode="c2p" match="mml:eulergamma|mml:csymbol[.='gamma']">
    <mi>&#947;</mi>
  </xsl:template>

  <!-- 4.4.12.15 infinity -->

  <xsl:template mode="c2p" match="mml:infinity|mml:csymbol[.='infinity']">
    <mi>&#8734;</mi>
  </xsl:template>

  <!-- *** -->

  <xsl:template name="infix">
    <xsl:param name="mo"/>
    <xsl:param name="p" select="0"/>
    <xsl:param name="this-p" select="0"/>
    <xsl:variable name="dmo">
      <xsl:choose>
        <xsl:when test="mml:domainofapplication">
          <munder>
            <xsl:copy-of select="$mo"/>
            <mrow><xsl:apply-templates mode="c2p" select="mml:domainofapplication/*"/></mrow>
          </munder>
        </xsl:when>
        <xsl:otherwise>
          <xsl:copy-of select="$mo"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>
    <mrow>
      <xsl:if test="$this-p&lt;$p"><mo>(</mo></xsl:if>
      <xsl:for-each select="*[not(self::mml:domainofapplication)][position()>1]">
        <xsl:if test="position()>1">
          <xsl:copy-of select="$dmo"/>
        </xsl:if>
        <xsl:apply-templates mode="c2p" select=".">
          <xsl:with-param name="p" select="$this-p"/>
        </xsl:apply-templates>
      </xsl:for-each>
      <xsl:if test="$this-p&lt;$p"><mo>)</mo></xsl:if>
    </mrow>
  </xsl:template>

  <xsl:template name="binary" >
    <xsl:param name="mo"/>
    <xsl:param name="p" select="0"/>
    <xsl:param name="this-p" select="0"/>
    <mrow>
      <xsl:if test="($this-p&lt;$p) or ($this-p=$p and $mo='&#8722;')">
        <mo>(</mo>
      </xsl:if>
      <xsl:apply-templates mode="c2p" select="*[2]">
        <xsl:with-param name="p" select="$this-p"/>
      </xsl:apply-templates>
      <xsl:copy-of select="$mo"/>
      <xsl:apply-templates mode="c2p" select="*[3]">
        <xsl:with-param name="p" select="$this-p"/>
      </xsl:apply-templates>
      <xsl:if test="($this-p&lt;$p) or ($this-p=$p and $mo='&#8722;')">
        <mo>)</mo>
      </xsl:if>
    </mrow>
  </xsl:template>

  <xsl:template name="set" >
    <xsl:param name="o" select="'{'"/>
    <xsl:param name="c" select="'}'"/>
    <mrow>
      <mo><xsl:value-of select="$o"/></mo>
      <xsl:choose>
        <xsl:when test="mml:condition">
          <mrow><xsl:apply-templates mode="c2p" select="mml:condition/following-sibling::*"/></mrow>
          <mo>|</mo>
          <mrow><xsl:apply-templates mode="c2p" select="mml:condition/node()"/></mrow>
        </xsl:when>
        <xsl:when test="mml:domainofapplication">
          <mrow><xsl:apply-templates mode="c2p" select="mml:domainofapplication/following-sibling::*"/></mrow>
          <mo>|</mo>
          <mrow><xsl:apply-templates mode="c2p" select="mml:bvar/node()"/></mrow>
          <mo>&#8712;</mo>
          <mrow><xsl:apply-templates mode="c2p" select="mml:domainofapplication/node()"/></mrow>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="*[not(position()=1 and parent::mml:apply)]">
            <xsl:apply-templates mode="c2p" select="."/>
            <xsl:if test="position()!=last()">
              <mo>,</mo>
            </xsl:if>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>
      <mo><xsl:value-of select="$c"/></mo>
    </mrow>
  </xsl:template>

  <!-- mathml 3 addtitions -->

  <xsl:template mode="c2p" match="mml:cs">
    <ms>
      <xsl:value-of select="translate(.,'&#9;&#10;&#13;&#32;','&#160;&#160;&#160;&#160;')"/>
    </ms>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cbytes">
    <mrow/>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:cerror">
    <merror>
      <xsl:apply-templates mode="c2p"/>
    </merror>
  </xsl:template>

  <xsl:template mode="c2p" match="mml:share" priority="4">
    <mi href="{@href}">share<xsl:value-of select="substring-after(@href,'#')"/></mi>
  </xsl:template>

</xsl:stylesheet>
