# Directory with the source files (optionally add extra LaTeX source folders, must end with a colon!)
SRCDIR      = .
# Directory where the PDF is copied
TARGETDIR   = .
# Directory where the output files are located
BUILDDIR    = build
# Directory for the PDF snapshots
SNAPDIR     = snapshots
# Directory for the source archives
ARCHIVEDIR  = archive
# Name for PDF snapshots and source archives
SHORTNAME   = mypaper
# Main LaTeX file
MAINTEX     = $(SRCDIR)/main.tex
# Output PDF
PDF         = $(TARGETDIR)/main.pdf
# Researchr bibliography name
RESEARCHR   = awe-evcs23
# Researchr bibliography file
SRCBIB      = $(SRCDIR)/researchr.bib

LATEXMK     = latexmk
LIVE        = -pvc -view=none -halt-on-error

all: $(PDF)

# Builds a PDF
$(BUILDDIR)/%.pdf: $(SRCDIR)/%.tex $(SRCDIR)/%.bib $(SRCDIR)/latexmkrc
	@echo "Warning: Underfull and overfull box warnings are suppressed!"
	$(LATEXMK) "$<"

# Copies a PDF
$(TARGETDIR)/%.pdf: $(BUILDDIR)/%.pdf
	cp "$<" "$@"

# Watches for changes and rebuilds
watch: $(MAINTEX)
	$(LATEXMK) $(LIVE) $(MAINTEX)

# Removes PDF build files
clean:
	$(LATEXMK) -C $(BUILDDIR)/main.pdf
	rm -f $(TARGETDIR)/main.pdf

# Removes all build files
clean-all:
	rm -rf $(BUILDDIR)/
	rm -f $(TARGETDIR)/main.pdf

# Downloads the latest bibliography from Researchr and fixes it
bib: clean-bib $(SRCBIB)
$(SRCBIB):
	curl -s "https://researchr.org/downloadbibtex/bibliography/$(RESEARCHR)/compact" -o $@
	sed -i '' '1 s/^/% /' $@
	sed -i '' 's/doi = {http.*\/\(10\..*\)}/doi = {\1}/' $@
	sed -i '' '/doi = {http.*}/d' $@
	sed -i '' 's/\&uuml;/ü/' $@
	@echo "Updated $@ from https://researchr.org/downloadbibtex/bibliography/$(RESEARCHR)/compact"

# Removes the bibliography
clean-bib:
	rm -f $(SRCBIB)

# Copies the latest built PDF to
snapshot: $(PDF)
	mkdir -p $(SNAPDIR)
	cp $(PDF) $(SNAPDIR)/$(shell date '+%Y%m%d%H%M')-$(SHORTNAME).pdf

# Creates an archive with the source files
archive: $(PDF)
	$(eval TMP := $(shell mktemp -d))
	mkdir -p $(TMP)/$(SHORTNAME)/
	cp -r $(SRCDIR)/ $(TMP)/$(SHORTNAME)/$(SRCDIR)/
	rm -rf $(TMP)/$(SHORTNAME)/$(BUILDDIR)
	rm -rf $(TMP)/$(SHORTNAME)/.[!.]*
	rm -rf $(TMP)/$(SHORTNAME)/$(SNAPDIR)
	rm -rf $(TMP)/$(SHORTNAME)/$(ARCHIVEDIR)
	cp Makefile $(TMP)/$(SHORTNAME)/.
	cp README.md $(TMP)/$(SHORTNAME)/.
	cp $(BUILDDIR)/*.bbl $(TMP)/$(SHORTNAME)/$(SRCDIR)/.
	cd $(TMP)/ && zip $(SHORTNAME).zip -r $(SHORTNAME)/
	mkdir -p $(ARCHIVEDIR)/
	cp $(TMP)/$(SHORTNAME).zip $(ARCHIVEDIR)/$(shell date '+%Y%m%d%H%M')-$(SHORTNAME).zip
	rm -rf $(TMP)

.PHONY: all watch clean bib clean-bib snapshot archive snapshot-with-sources
.SILENT:
.SUFFIXES: .pdf
.PRECIOUS: $(PDF) $(BUILDDIR)/main.pdf
