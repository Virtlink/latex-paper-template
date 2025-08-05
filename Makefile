# Directory with the source files
SRCDIR      = src
# Directory with the library files
LIBDIR      = lib
# Directory where the build files are located
BUILDDIR    = build
# Directory where the PDF is copied
DOCDIR      = .
DOCNAME     = main
# The path to the main .tex file
MAINTEX     = $(DOCNAME).tex
# Directory for the PDF snapshots
SNAPDIR     = snapshots
# Prefix for PDF snapshots
SNAPNAME    = $(DOCNAME)
# Directory for the source archives
ARCHIVEDIR  = archive
# Name for source archives
ARCHIVENAME = $(DOCNAME)
# Researchr bibliography files
SRCBIBS     = \
	$(SRCDIR)/awe-evcs23.bib
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

LATEXMK     = latexmk
LIVE        = -pvc -view=none -halt-on-error
DOCUMENT    = $(DOCDIR)/$(DOCNAME).pdf

# Build the PDF
all: $(DOCUMENT)

# Build a PDF
$(DOCUMENT): $(MAINTEX) $(SRCFILES) aux-dirs
	@echo "Warning: Underfull and overfull box warnings are suppressed!"
	$(LATEXMK) "$<" -jobname=$(DOCNAME)
	@echo "Done building $@"

# Download the latest bibliographies from Researchr and fix them
bib: clean-bib $(SRCBIBS)

# Download a bibliography from Researchr and fix it
%.bib:
	curl -s "https://researchr.org/downloadbibtex/bibliography/$(notdir $*)" -o $@
	sed -i '' '1 s/^/% /' $@
	sed -i '' 's/doi = {http.*\/\(10\..*\)}/doi = {\1}/' $@
	sed -i '' '/doi = {http.*}/d' $@
	sed -i '' 's/\&uuml;/ü/' $@
	@echo "Updated $@ from https://researchr.org/downloadbibtex/bibliography/$(notdir $*)"

# Remove the bibliographies
clean-bib:
	-@rm $(SRCBIBS) 2> /dev/null

# Removes PDF build files
clean:
	-@$(LATEXMK) -C $(DOCUMENT)

# Removes all build files
clean-all: clean clean-bib

# Force remove all auxillary files without using latexmk
clean-force:
	-@rm $(DOCUMENT)
	-@find . -name "_minted*" -type f -delete
	-@find . -name ".*.lb" -type f -delete
	-@find . -name "*-blx.aux" -type f -delete
	-@find . -name "*-blx.bib" -type f -delete
	-@find . -name "*-converted-to.*" -type f -delete
	-@find . -name "*-gnuplottex-*" -type f -delete
	-@find . -name "*.*-SAVE-ERROR" -type f -delete
	-@find . -name "*.*-SAVE-ERROR" -type f -delete
	-@find . -name "*.acn" -type f -delete
	-@find . -name "*.acr" -type f -delete
	-@find . -name "*.alg" -type f -delete
	-@find . -name "*.aux" -type f -delete
	-@find . -name "*.auxlock" -type f -delete
	-@find . -name "*.bbl" -type f -delete
	-@find . -name "*.bcf" -type f -delete
	-@find . -name "*.bit" -type f -delete
	-@find . -name "*.blg" -type f -delete
	-@find . -name "*.brf" -type f -delete
	-@find . -name "*.bst" -type f -delete
	-@find . -name "*.cb" -type f -delete
	-@find . -name "*.cb2" -type f -delete
	-@find . -name "*.cpt" -type f -delete
	-@find . -name "*.cut" -type f -delete
	-@find . -name "*.dpth" -type f -delete
	-@find . -name "*.dvi" -type f -delete
	-@find . -name "*.ent" -type f -delete
	-@find . -name "*.fdb_latexmk" -type f -delete
	-@find . -name "*.fls" -type f -delete
	-@find . -name "*.fmt" -type f -delete
	-@find . -name "*.fot" -type f -delete
	-@find . -name "*.glg-*" -type f -delete
	-@find . -name "*.glg" -type f -delete
	-@find . -name "*.glo-*" -type f -delete
	-@find . -name "*.glo" -type f -delete
	-@find . -name "*.glo" -type f -delete
	-@find . -name "*.gls-*" -type f -delete
	-@find . -name "*.gls" -type f -delete
	-@find . -name "*.glsdefs" -type f -delete
	-@find . -name "*.glx" -type f -delete
	-@find . -name "*.gnuplot" -type f -delete
	-@find . -name "*.gxg" -type f -delete
	-@find . -name "*.gxs" -type f -delete
	-@find . -name "*.gz" -type f -delete
	-@find . -name "*.hst" -type f -delete
	-@find . -name "*.idx" -type f -delete
	-@find . -name "*.ilg" -type f -delete
	-@find . -name "*.ind" -type f -delete
	-@find . -name "*.ist" -type f -delete
	-@find . -name "*.loa" -type f -delete
	-@find . -name "*.lod" -type f -delete
	-@find . -name "*.lof" -type f -delete
	-@find . -name "*.log" -type f -delete
	-@find . -name "*.lol" -type f -delete
	-@find . -name "*.lot" -type f -delete
	-@find . -name "*.lox" -type f -delete
	-@find . -name "*.lzo" -type f -delete
	-@find . -name "*.lzs" -type f -delete
	-@find . -name "*.md5" -type f -delete
	-@find . -name "*.nav" -type f -delete
	-@find . -name "*.out" -type f -delete
	-@find . -name "*.pdfsync" -type f -delete
	-@find . -name "*.pre" -type f -delete
	-@find . -name "*.pyg" -type f -delete
	-@find . -name "*.run.xml" -type f -delete
	-@find . -name "*.slg" -type f -delete
	-@find . -name "*.slo" -type f -delete
	-@find . -name "*.sls" -type f -delete
	-@find . -name "*.snm" -type f -delete
	-@find . -name "*.soc" -type f -delete
	-@find . -name "*.synctex.gz" -type f -delete
	-@find . -name "*.synctex.gz(busy)" -type f -delete
	-@find . -name "*.synctex" -type f -delete
	-@find . -name "*.synctex(busy)" -type f -delete
	-@find . -name "*.table" -type f -delete
	-@find . -name "*.tdo" -type f -delete
	-@find . -name "*.thm" -type f -delete
	-@find . -name "*.toc" -type f -delete
	-@find . -name "*.upa" -type f -delete
	-@find . -name "*.upb" -type f -delete
	-@find . -name "*.url" -type f -delete
	-@find . -name "*.ver" -type f -delete
	-@find . -name "*.vrb" -type f -delete
	-@find . -name "*.vtc" -type f -delete
	-@find . -name "*.xcp" -type f -delete
	-@find . -name "*.xdv" -type f -delete
	-@find . -name "acs-*.bib" -type f -delete

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

# Create auxiliary directories
aux-dirs:
	@echo "Creating auxiliary directories..."
	./create-aux-dirs.sh

.PHONY: all bib clean-bib clean clean-all clean-force watch snapshot archive aux-dirs
.SILENT:
.SUFFIXES: .pdf
.PRECIOUS: $(DOCUMENT)
