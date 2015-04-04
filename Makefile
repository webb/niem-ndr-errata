
.PHONY: all clean

all: errata.html

errata.html: errata.xml errata-to-html.xsl all.css
	saxon --xsl=errata-to-html.xsl --in=$< --out=$@

clean:
	$(RM) errata.html
