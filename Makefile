
errata.html: errata.xml errata-to-html.xsl
	saxon --xsl=errata-to-html.xsl --in=$< --out=$@

