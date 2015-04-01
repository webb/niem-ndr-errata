<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
   version="2.0"
   xmlns:e="http://example.org/errata"
   xmlns:this="http://example.org/errata-to-html"
   xmlns:xs="http://www.w3.org/2001/XMLSchema"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
   xmlns="http://www.w3.org/1999/xhtml">

  <xsl:template match="/e:errata">
    <html>
      <head>
        <title>Errata <xsl:value-of select="@date"/></title>
      </head>
      <body>
        <h1>Errata <xsl:value-of select="@date"/></h1>
        <xsl:apply-templates/>
      </body>
    </html>
  </xsl:template>

  <xsl:template match="e:doc">
    <h2>Errata for <a href="{@uri}" target="other"><xsl:value-of select="@name"/>, version <xsl:value-of select="@version"/></a>.</h2>
    <div style="margin-left: 2em;">
      <xsl:apply-templates/>
    </div>
  </xsl:template>
        
  <xsl:template match="e:section | e:rule">
    <xsl:apply-templates/>
  </xsl:template>

  <xsl:template match="e:revision">
    <xsl:variable name="anchor-context" select="ancestor-or-self::*[@anchor
                                                                    or self::e:rule
                                                                    or self::e:section][1]"/>
    <xsl:variable name="anchor" as="xs:string"
                  select="if ($anchor-context/@anchor)
                          then $anchor-context/@anchor
                          else if ($anchor-context/self::e:rule)
                               then concat('rule_', $anchor-context/@number)
                               else if ($anchor-context/self::e:section)
                                    then concat('section_', $anchor-context/@number)
                                    else ()"/>

    <xsl:variable name="contexts" as="element()*"
                  select="ancestor::*[self::e:rule or self::e:section]"/>

    <p>
      <xsl:text>In </xsl:text>
      <a href="{ancestor::e:doc[1]/@uri}#{$anchor}" target="other">
        <xsl:value-of select="string-join(for $context in $contexts return this:get-context-string($context), ', in ')"/>
      </a>
      <xsl:text>, revise:</xsl:text>
    </p>
    <div style="margin-left: 4em;">
      <xsl:copy-of select="e:from/node()"/>
    </div>
    <p style="margin-left: 2em;">to:</p>
    <div style="margin-left: 4em;">
      <xsl:copy-of select="e:to/node()"/>
    </div>
  </xsl:template>
  
  <xsl:template match="text()"/>

  <xsl:function name="this:get-context-string" as="xs:string">
    <xsl:param name="context" as="element()"/>
    <xsl:value-of>
      <xsl:choose>
        <xsl:when test="$context/self::e:section">
          <xsl:text>section </xsl:text>
        </xsl:when>
        <xsl:when test="$context/self::e:rule">
        <xsl:text>rule </xsl:text>
        </xsl:when>
      </xsl:choose>
      <xsl:value-of select="$context/@number"/>
      <xsl:text>, &#8220;</xsl:text>
      <xsl:value-of select="$context/@name"/>
      <xsl:text>&#8221;</xsl:text>
    </xsl:value-of>
  </xsl:function>

</xsl:stylesheet>
<!--
Local Variables:
mode: sgml
indent-tabs-mode: nil
fill-column: 9999
End:
-->
