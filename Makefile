# Directory with the source files
SRCDIR      = src
# Directory with the library files
LIBDIR      = lib
# Directory where the build files are located
BUILDDIR    = build
# Directory where the PDF is copied
DOCDIR      = .
DOCNAME     = refsyn
# The path to the main .tex file
MAINTEX     = main.tex
# Directory for the PDF snapshots
SNAPDIR     = snapshots
# Prefix for PDF snapshots
SNAPNAME    = mypaper
# Directory for the source archives
ARCHIVEDIR  = archive
# Name for source archives
ARCHIVENAME = mypaper
# Researchr bibliography file
SRCBIB      = $(SRCDIR)/researchr.bib
# Source files
SRCFILES    = $(MAINTEX) $(SRCBIB) \
	$(wildcard $(SRCDIR)/*.tex) \
	$(wildcard $(SRCDIR)/*.bib) \
	$(wildcard $(SRCDIR)/*.png) \
	$(wildcard $(SRCDIR)/*.cls) \
	$(wildcard $(SRCDIR)/*.bst) \
	$(wildcard $(SRCDIR)/*.pdf) \
	$(wildcard $(LIBDIR)/*) \
	latexmkrc
# Researchr bibliography name
RESEARCHR   = awe-evcs23

LATEXMK     = latexmk
LIVE        = -pvc -view=none -halt-on-error
DOCUMENT    = $(DOCDIR)/$(DOCNAME).pdf

# Build the PDF
all: $(DOCUMENT)

# Build a PDF
$(DOCUMENT): $(MAINTEX) $(SRCFILES)
	@echo "Warning: Underfull and overfull box warnings are suppressed!"
	$(LATEXMK) "$<" -jobname=$(DOCNAME)

# Download the latest bibliography from Researchr and fix it
bib: clean-bib $(SRCBIB)
$(SRCBIB):
	curl -s "https://researchr.org/downloadbibtex/bibliography/$(RESEARCHR)" -o $@
	sed -i '' '1 s/^/% /' $@
	sed -i '' 's/doi = {http.*\/\(10\..*\)}/doi = {\1}/' $@
	sed -i '' '/doi = {http.*}/d' $@
	sed -i '' 's/\&uuml;/ü/' $@
	@echo "Updated $@ from https://researchr.org/downloadbibtex/bibliography/$(RESEARCHR)"

# Remove the bibliography
clean-bib:
	-@rm $(SRCBIB)

# Removes PDF build files
clean:
	-@$(LATEXMK) -C $(DOCUMENT)

# Removes all build files
clean-all: clean clean-bib
	-@rm -r $(BUILDDIR)/

# Watch for changes and rebuild
watch:
	$(LATEXMK) $(LIVE) $(MAINTEX) -jobname=$(DOCNAME)

# Copy the latest built PDF to the snapshots directory
snapshot: $(DOCUMENT)
	mkdir -p $(SNAPDIR)
	cp "$<" $(SNAPDIR)/$(shell date +"%Y%m%dT%H%M%S")-$(SNAPNAME).pdf

# Create an archive with the source files
archive: $(DOCUMENT)
	$(eval ARCHIVEFILE := $(abspath $(ARCHIVEDIR)/$(shell date '+%Y%m%d%H%M')-$(ARCHIVENAME).zip))
	mkdir -p $(ARCHIVEDIR)
	-@rm $(ARCHIVEFILE) 2> /dev/null
	cd $(SRCDIR)     && zip        $(ARCHIVEFILE) $(shell cd $(SRCDIR)     && find . -type f -name '*.tex' -o -name '*.bib' -o -name '*.png' -o -name '*.cls' -o -name '*.bst' -o -name '*.pdf')
	cd $(LIBDIR)     && zip --grow $(ARCHIVEFILE) $(shell cd $(LIBDIR)     && find . -type f)
	cd $(BUILDDIR)   && zip --grow $(ARCHIVEFILE) $(shell cd $(BUILDDIR)   && find . -type f -name '*.bbl')
	cd .                zip --grow $(ARCHIVEFILE) $(shell cd .             && find . -type f -maxdepth 1 -name '*.tex' -o -name 'README.md' -o -name 'Makefile' -o -name 'latexmkrc')

.PHONY: all bib clean-bib clean clean-all watch snapshot archive
.SILENT:
.SUFFIXES: .pdf
.PRECIOUS: $(DOCUMENT)
