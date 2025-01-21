<xsl:stylesheet version="1.0"
                xmlns:rsml="https://kekkan.org/RsML"
                xmlns:mml="http://www.w3.org/1998/Math/MathML"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                exclude-result-prefixes="rsml mml">

  <!--

    Copyright Jing Huang 2024, 2025.

    Use and distribution of this code are permitted under the terms of the
    MIT License, compatible with Apache 2, GNU Generic Public License, etc.

    2024-2025        RsML1 for WEB

  -->

  <xsl:output method="xml" encoding="utf-8" indent="no"
              omit-xml-declaration="yes"/>

  <xsl:template name="space">
    <xsl:param name="width"/>
    <xsl:if test="$width>0">
      <xsl:text> </xsl:text>
      <xsl:call-template name="space">
        <xsl:with-param name="width" select="-1+$width"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="listing">
    <xsl:param name="previous"/>
    <xsl:param name="current"/>
    <xsl:param name="capacity"/>
    <xsl:param name="pointer"/>
    <xsl:if test="string-length($current)>0">
      <xsl:variable name="before" select="substring-before($current,'&#10;')"/>
      <xsl:variable name="after" select="substring-after($current,'&#10;')"/>
      <xsl:variable name="offset">
        <xsl:choose>
          <xsl:when test="string-length(normalize-space($before))>0 or
                          string-length(normalize-space($after))>0 and
                          string-length(normalize-space($previous))>0">
            <xsl:value-of select="number(1)"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="number(0)"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:variable>
      <xsl:if test="$offset=1">
        <span class="line">
          <span class="ln">
            <xsl:choose>
              <xsl:when test="($pointer mod 5)=0">
                <xsl:call-template name="space">
                  <xsl:with-param name="width" select="-(string-length($pointer))+$capacity"/>
                </xsl:call-template>
                <xsl:value-of select="$pointer"/>
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="space">
                  <xsl:with-param name="width" select="$capacity+1"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
            <span class="nsep">|</span>
          </span>
          <span class="ld"><code>
            <xsl:choose>
              <xsl:when test="normalize-space($before)=''">
                <xsl:text> </xsl:text>
              </xsl:when>
              <xsl:otherwise>
                <xsl:value-of select="$before"/>
              </xsl:otherwise>
            </xsl:choose>
          </code></span>
        </span>
        <xsl:if test="string-length(normalize-space($after))>0">
          <xsl:text>&#10;</xsl:text>
        </xsl:if>
      </xsl:if>
      <xsl:call-template name="listing">
        <xsl:with-param name="previous" select="$before"/>
        <xsl:with-param name="current" select="$after"/>
        <xsl:with-param name="capacity" select="$capacity"/>
        <xsl:with-param name="pointer" select="$pointer+$offset"/>
      </xsl:call-template>
    </xsl:if>
  </xsl:template>

  <xsl:template name="basename">
    <xsl:param name="uri"/>
    <xsl:choose>
      <xsl:when test="contains($uri,'/')">
        <xsl:call-template name="basename">
          <xsl:with-param name="uri" select="substring-after($uri,'/')"/>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="$uri"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template match="/">
    <xsl:if test="rsml:rsml/@version>1.0">
      <xsl:message terminate="yes">This stylesheet supports only RsML1, terminating...</xsl:message>
    </xsl:if>
    <xsl:apply-templates mode="virgin"/>
  </xsl:template>

  <xsl:template mode="virgin" match="*">
    <xsl:copy>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="virgin"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template mode="virgin" match="rsml:rsml">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>
    <html>
      <xsl:if test="@language">
        <xsl:attribute name="lang">
          <xsl:value-of select="string(@language)"/>
        </xsl:attribute>
      </xsl:if>
      <head><xsl:apply-templates mode="preface" select="rsml:meta"/></head>
      <body>
        <xsl:apply-templates mode="initial"/>
        <footer><xsl:apply-templates mode="appendix" select="."/></footer>
      </body>
    </html>
  </xsl:template>

  <xsl:template mode="preface" match="rsml:meta">
    <meta charset="utf-8"/>
    <meta name="creator" content="RsML1"/>
    <xsl:if test="rsml:author">
      <xsl:element name="meta">
        <xsl:attribute name="name">
          <xsl:value-of select="string('author')"/>
        </xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="rsml:author"/>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
    <xsl:if test="rsml:date">
      <xsl:element name="meta">
        <xsl:attribute name="name">
          <xsl:value-of select="string('pubdate')"/>
        </xsl:attribute>
        <xsl:attribute name="content">
          <xsl:value-of select="descendant::rsml:year"/>
          <xsl:if test="descendant::rsml:month and descendant::rsml:day">
            <xsl:value-of select="substring-after(descendant::rsml:month,'-')"/>
            <xsl:value-of select="substring-after(descendant::rsml:day,'--')"/>
          </xsl:if>
        </xsl:attribute>
      </xsl:element>
    </xsl:if>
    <title>
      <xsl:value-of select="rsml:title"/>
      <xsl:if test="rsml:subtitle">
        <xsl:text> -- </xsl:text>
        <xsl:value-of select="rsml:subtitle"/>
      </xsl:if>
    </title>
    <link href="/style/art.css" rel="stylesheet"/>
  </xsl:template>

  <xsl:template mode="initial" match="rsml:meta">
    <div class="header">
      <h1 class="title"><xsl:apply-templates mode="horizontal" select="rsml:title"/></h1>
      <xsl:if test="rsml:subtitle">
        <h2 class="subtitle"><xsl:apply-templates mode="horizontal" select="rsml:subtitle"/></h2>
      </xsl:if>
      <xsl:if test="rsml:author or rsml:date">
        <div class="status"><p>
          <xsl:text>Published</xsl:text>
          <xsl:if test="rsml:date">
            <xsl:text> on </xsl:text>
            <xsl:if test="descendant::rsml:month and descendant::rsml:day">
              <xsl:value-of select="translate(descendant::rsml:day,'-','')"/>
              <xsl:text> </xsl:text>
              <xsl:variable name="month" select="translate(descendant::rsml:month,'-','')"/>
              <xsl:choose>
                <xsl:when test="$month=1">January</xsl:when>
                <xsl:when test="$month=2">February</xsl:when>
                <xsl:when test="$month=3">March</xsl:when>
                <xsl:when test="$month=4">April</xsl:when>
                <xsl:when test="$month=5">May</xsl:when>
                <xsl:when test="$month=6">June</xsl:when>
                <xsl:when test="$month=7">July</xsl:when>
                <xsl:when test="$month=8">August</xsl:when>
                <xsl:when test="$month=9">September</xsl:when>
                <xsl:when test="$month=10">October</xsl:when>
                <xsl:when test="$month=11">November</xsl:when>
                <xsl:when test="$month=12">December</xsl:when>
              </xsl:choose>
              <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:value-of select="descendant::rsml:year"/>
          </xsl:if>
          <xsl:if test="rsml:author">
            <xsl:text> by </xsl:text>
            <xsl:value-of select="rsml:author"/>
            <xsl:if test="rsml:affiliate">
              <xsl:text> </xsl:text>
              <xsl:value-of select="concat('(',rsml:affiliate,')')"/>
            </xsl:if>
          </xsl:if>
          <xsl:text>.</xsl:text>
        </p></div>
      </xsl:if>
      <xsl:if test="rsml:abstract">
        <div class="abstract"><p>
          <xsl:apply-templates mode="horizontal" select="rsml:abstract"/>
        </p></div>
      </xsl:if>
      <nav id="lot">
        <h2>Table of Contents</h2>
        <div class="toc"><ul>
          <xsl:for-each select="//rsml:unit[@role='chapter']"><li>
            <xsl:variable name="chapter">
              <xsl:number count="rsml:unit[@role='chapter']" format="1"/>
            </xsl:variable>
            <a href="#c{$chapter}">
              <span class="chapno"><xsl:value-of select="$chapter"/></span>
              <xsl:text> </xsl:text>
              <span class="content"><xsl:value-of select="rsml:heading"/></span>
            </a>
            <xsl:if test="rsml:unit[@role='section']">
              <ul class="toc"><xsl:for-each select="rsml:unit[@role='section']">
                <xsl:variable name="section">
                  <xsl:number count="rsml:unit[@role='section']" from="rsml:unit[@role='chapter' and position()=$chapter]" format="1"/>
                </xsl:variable>
                <li><a href="#s{$chapter}-{$section}">
                  <span class="secno"><xsl:value-of select="concat($chapter,'.',$section)"/></span>
                  <xsl:text> </xsl:text>
                  <span class="content"><xsl:value-of select="rsml:heading"/></span>
                </a></li>
              </xsl:for-each></ul>
            </xsl:if>
          </li></xsl:for-each>
        </ul></div>
      </nav>
    </div>
  </xsl:template>

  <xsl:template mode="initial" match="rsml:unit">
    <xsl:apply-templates mode="vertical"/>
  </xsl:template>

  <xsl:template mode="initial" match="rsml:bibliography">
    <h2>Bibliography</h2>
    <xsl:for-each select="rsml:entry">
      <p class="bibentry">
        <cite class="title"><xsl:apply-templates mode="horizontal" select="rsml:title"/></cite>
        <xsl:text>. </xsl:text>
        <cite class="author"><xsl:value-of select="rsml:author"/></cite>
        <xsl:text>. </xsl:text>
        <cite class="year"><xsl:value-of select="rsml:year"/></cite>
        <xsl:text>.</xsl:text>
      </p>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="appendix" match="rsml:rsml">
    <xsl:if test="//rsml:footnote">
      <div class="footnotes">
        <hr/>
        <xsl:for-each select="//rsml:footnote">
          <div class="footnote">
            <xsl:variable name="symbol" select="@symbol"/>
            <xsl:variable name="label">
              <xsl:number level="any" count="rsml:footnote" format="1"/>
            </xsl:variable>
            <div class="footno"><sup><a id="f{$label}">
              <xsl:choose>
                <xsl:when test="$symbol">
                  <xsl:value-of select="$symbol"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:value-of select="$label"/>
                </xsl:otherwise>
              </xsl:choose>
            </a></sup></div>
            <div class="footbody">
              <xsl:apply-templates mode="horizontal"/>
            </div>
          </div>
        </xsl:for-each>
      </div>
    </xsl:if>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:quotation|rsml:apostrophe|rsml:ampersand|
                                         rsml:langle|rsml:rangle|rsml:space">
    <xsl:variable name="type">
      <xsl:value-of select="local-name()"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$type='quotation'">
        <xsl:text>&quot;</xsl:text>
      </xsl:when>
      <xsl:when test="$type='apostrophe'">
        <xsl:text>&apos;</xsl:text>
      </xsl:when>
      <xsl:when test="$type='ampersand'">
        <xsl:text>&amp;</xsl:text>
      </xsl:when>
      <xsl:when test="$type='langle'">
        <xsl:text>&lt;</xsl:text>
      </xsl:when>
      <xsl:when test="$type='rangle'">
        <xsl:text>&gt;</xsl:text>
      </xsl:when>
      <xsl:when test="$type='space'">
        <xsl:text>&#160;</xsl:text>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:emphasize">
    <em><xsl:apply-templates mode="horizontal"/></em>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:highlight">
    <mark><xsl:apply-templates mode="horizontal"/></mark>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:math">
    <math display="inline"><xsl:apply-templates mode="restricted"/></math>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:verbatim">
    <code><xsl:apply-templates mode="horizontal"/></code>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:term">
    <span class="term"><xsl:apply-templates mode="horizontal"/></span>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:abbreviation">
    <abbr><xsl:apply-templates mode="horizontal"/></abbr>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:keyword">
    <span class="keyword"><xsl:apply-templates mode="horizontal"/></span>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:quote">
    <q><xsl:apply-templates mode="horizontal"/></q>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:link">
    <a href="{text()}"><xsl:choose>
      <xsl:when test="@literal">
        <xsl:value-of select="string(@literal)"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="text()"/>
      </xsl:otherwise>
    </xsl:choose></a>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:label">
    <xsl:variable name="xref">
      <xsl:number count="rsml:label" format="1"/>
    </xsl:variable>
    <xsl:value-of select="text()"/>
    <a id="l{$xref}"/>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:refer">
    <xsl:variable name="type" select="@type"/>
    <xsl:variable name="label" select="@label"/>
    <xsl:choose>
      <xsl:when test="$type='chapter'">
        <a href="#c{$label}">
          <xsl:text>Chapter </xsl:text>
          <xsl:value-of select="$label"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='section'">
        <a href="#s{translate($label,'.','-')}">
          <xsl:text>Section </xsl:text>
          <xsl:value-of select="$label"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='subsection'">
        <a href="#z{translate($label,'.','-')}">
          <xsl:text>Subsection </xsl:text>
          <xsl:value-of select="$label"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='label'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:label[@label=$label]"/>
        </xsl:variable>
        <a href="#l{$xref}">
          <xsl:text>Label </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='figure'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:figure[@label=$label]"/>
        </xsl:variable>
        <a href="#f{translate($xref,'.','-')}">
          <xsl:text>Figure </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='table'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:table[@label=$label]"/>
        </xsl:variable>
        <a href="#t{translate($xref,'.','-')}">
          <xsl:text>Table </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='math'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:math[@label=$label]"/>
        </xsl:variable>
        <a href="#m{translate($xref,'.','-')}">
          <xsl:text>Math </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
      <xsl:when test="$type='verbatim'">
        <xsl:variable name="xref">
          <xsl:apply-templates mode="crossref" select="//rsml:verbatim[@label=$label]"/>
        </xsl:variable>
        <a href="#v{translate($xref,'.','-')}">
          <xsl:text>Verbatim </xsl:text>
          <xsl:value-of select="$xref"/>
        </a>
      </xsl:when>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="horizontal" match="rsml:footnote">
    <xsl:variable name="symbol" select="@symbol"/>
    <xsl:variable name="label">
      <xsl:number level="any" count="rsml:footnote" format="1"/>
    </xsl:variable>
    <sup><a href="#f{$label}">
      <xsl:choose>
        <xsl:when test="$symbol">
          <xsl:value-of select="$symbol"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$label"/>
        </xsl:otherwise>
      </xsl:choose>
    </a></sup>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:heading">
    <xsl:variable name="type" select="parent::rsml:unit/@role"/>
    <xsl:choose>
      <xsl:when test="$type='chapter'">
        <xsl:variable name="xref">
          <xsl:number count="rsml:unit[@role='chapter']" format="1"/>
        </xsl:variable>
        <h2 id="c{$xref}">
          <xsl:value-of select="$xref"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates mode="horizontal"/>
        </h2>
      </xsl:when>
      <xsl:when test="$type='section'">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter' or @role='section']" format="1-1"/>
        </xsl:variable>
        <h3 id="s{$xref}">
          <xsl:value-of select="translate($xref,'-','.')"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates mode="horizontal"/>
        </h3>
      </xsl:when>
      <xsl:otherwise>
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter' or @role='section' or @role='subsection']" format="1-1-1"/>
        </xsl:variable>
        <h4 id="z{$xref}">
          <xsl:value-of select="translate($xref,'-','.')"/>
          <xsl:text>. </xsl:text>
          <xsl:apply-templates mode="horizontal"/>
        </h4>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:paragraph">
    <p><xsl:apply-templates mode="horizontal"/></p>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:list">
    <xsl:variable name="type" select="@type"/>
    <xsl:choose>
      <xsl:when test="$type='enumerate'">
        <ol><xsl:apply-templates mode="restricted" select=".">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates></ol>
      </xsl:when>
      <xsl:when test="$type='itemize'">
        <ul><xsl:apply-templates mode="restricted" select=".">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates></ul>
      </xsl:when>
      <xsl:otherwise>
        <dl><xsl:apply-templates mode="restricted" select=".">
          <xsl:with-param name="type" select="$type"/>
        </xsl:apply-templates></dl>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:figure">
    <figure>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string('center')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="@size">
        <xsl:attribute name="style">
          <xsl:value-of select="concat('width:',substring-after(@size,'r'),'%;')"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:figure" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('f',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:variable name="image">
        <xsl:call-template name="basename">
          <xsl:with-param name="uri" select="rsml:image"/>
        </xsl:call-template>
      </xsl:variable>
      <img src="{rsml:image}" alt="{$image}"/>
      <xsl:if test="rsml:caption">
        <figcaption><xsl:apply-templates mode="horizontal" select="rsml:caption"/></figcaption>
      </xsl:if>
    </figure>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:table">
    <table>
      <xsl:attribute name="class">
        <xsl:choose>
          <xsl:when test="@align"><xsl:value-of select="@align"/></xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="string('center')"/>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:attribute>
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:table" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('t',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:if test="rsml:caption">
        <caption><xsl:apply-templates mode="horizontal" select="rsml:caption"/></caption>
      </xsl:if>
      <xsl:if test="rsml:head">
        <thead><xsl:apply-templates mode="restricted" select=".">
          <xsl:with-param name="type" select="rsml:head"/>
        </xsl:apply-templates></thead>
      </xsl:if>
      <tbody><xsl:apply-templates mode="restricted" select=".">
        <xsl:with-param name="type" select="rsml:body"/>
      </xsl:apply-templates></tbody>
      <xsl:if test="rsml:foot">
        <tfoot><xsl:apply-templates mode="restricted" select=".">
          <xsl:with-param name="type" select="rsml:foot"/>
        </xsl:apply-templates></tfoot>
      </xsl:if>
    </table>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:math">
    <math display="block">
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:math" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('m',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="restricted"/>
    </math>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:verbatim">
    <pre>
      <xsl:if test="@label">
        <xsl:variable name="xref">
          <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:verbatim" format="1-1"/>
        </xsl:variable>
        <xsl:attribute name="id">
          <xsl:value-of select="concat('v',$xref)"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:call-template name="listing">
        <xsl:with-param name="current" select="text()"/>
        <xsl:with-param name="capacity" select="string-length(@line)"/>
        <xsl:with-param name="pointer" select="1"/>
      </xsl:call-template>
    </pre>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:quote">
    <blockquote>
      <xsl:if test="@cite">
        <xsl:attribute name="cite">
          <xsl:value-of select="@cite"/>
        </xsl:attribute>
      </xsl:if>
      <xsl:apply-templates mode="horizontal"/>
    </blockquote>
  </xsl:template>

  <xsl:template mode="vertical" match="rsml:message">
    <div class="{@type}"><p>
      <xsl:apply-templates mode="horizontal"/>
    </p></div>
  </xsl:template>

  <xsl:template mode="restricted" match="*">
    <xsl:element name="{local-name()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="restricted"/>
    </xsl:element>
  </xsl:template>

  <xsl:template mode="restricted" match="rsml:list">
    <xsl:param name="type"/>
    <xsl:choose>
      <xsl:when test="$type='description'">
        <xsl:for-each select="rsml:item">
          <dt><xsl:value-of select="@name"/></dt>
          <dd><xsl:apply-templates mode="horizontal"/></dd>
        </xsl:for-each>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select="rsml:item"><li>
          <xsl:apply-templates mode="unbound"/>
        </li></xsl:for-each>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="restricted" match="rsml:table">
    <xsl:param name="type"/>
    <xsl:for-each select="$type/rsml:column">
      <tr>
        <xsl:for-each select="rsml:cell">
          <th>
            <xsl:if test="@rowspan">
              <xsl:attribute name="rowspan">
                <xsl:value-of select="@rowspan"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:if test="@colspan">
              <xsl:attribute name="colspan">
                <xsl:value-of select="@colspan"/>
              </xsl:attribute>
            </xsl:if>
            <xsl:apply-templates mode="horizontal"/>
          </th>
        </xsl:for-each>
      </tr>
    </xsl:for-each>
  </xsl:template>

  <xsl:template mode="unbound" match="*">
    <xsl:variable name="type">
      <xsl:value-of select="local-name()"/>
    </xsl:variable>
    <xsl:choose>
      <xsl:when test="$type='list'">
        <xsl:apply-templates mode="vertical" select="."/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:apply-templates mode="horizontal" select="."/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:label">
    <xsl:number count="rsml:label" format="1"/>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:figure">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:figure" format="1.1"/>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:table">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:table" format="1.1"/>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:math">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:math" format="1.1"/>
  </xsl:template>

  <xsl:template mode="crossref" match="rsml:verbatim">
    <xsl:number level="multiple" count="rsml:unit[@role='chapter']|rsml:verbatim" format="1.1"/>
  </xsl:template>

</xsl:stylesheet>
