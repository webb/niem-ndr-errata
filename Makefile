
.PHONY: all clean

dest = niem-ndr-errata-artifacts/errata.html

all: $(dest)

$(dest): errata.xml errata-to-html.xsl all.css
	saxon --xsl=errata-to-html.xsl --in=$< --out=$@

clean:
	$(RM) $(dest)
