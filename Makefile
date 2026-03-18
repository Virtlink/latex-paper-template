# Make settings
.SHELLFLAGS   := -eu -o pipefail -c
.DEFAULT_GOAL := help
.ONESHELL:
.DELETE_ON_ERROR:
.SILENT:
MAKEFLAGS += --no-print-directory
MAKEFLAGS += --no-builtin-rules
MAKEFLAGS += --warn-undefined-variables
.SUFFIXES: .pdf

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
.PRECIOUS: $(DOCUMENT)


# Colors and formatting
NC     := $(shell printf "\033[0m")
BOLD   := $(shell printf "\033[1m")
DIM    := $(shell printf "\033[2m")
ITALIC := $(shell printf "\033[3m")
ULINE  := $(shell printf "\033[4m")
RED    := $(shell printf "\033[1;31m")
GREEN  := $(shell printf "\033[1;32m")
YELLOW := $(shell printf "\033[1;33m")
BLUE   := $(shell printf "\033[1;34m")
MAGENTA:= $(shell printf "\033[1;35m")
CYAN   := $(shell printf "\033[1;36m")
INFO   := $(shell printf "$(BLUE)ℹ$(NC)")
OK     := $(shell printf "$(GREEN)✓$(NC)")
WARN   := $(shell printf "$(YELLOW)⚠$(NC)")
ERROR  := $(shell printf "$(RED)✖$(NC)")

# Note: targets followed by `##` are documented in the help output
#       lines starting with `##@` are used to group targets in the help output
.PHONY: help
help:                                  ## Display this help text for this Makefile
	awk 'BEGIN {FS = ":.*##";\
 		printf "\nUsage:  make ${CYAN}<target>${NC}\n"}\
 		/^[a-zA-Z0-9_-]+:.*?##/ { printf "  ${CYAN}%-15s${NC} %s\n", $$1, $$2 }\
 		/^##@/ { printf "\n${BOLD}%s${NC}\n", substr($$0, 5) } '\
 		$(MAKEFILE_LIST)



### =============================================================================
##@ Development
### =============================================================================

.PHONY: all
all: $(DOCUMENT)		## Build the PDF

$(DOCUMENT): $(MAINTEX) $(SRCFILES) aux-dirs
	@echo "${WARN} Note: underfull and overfull box warnings are suppressed"
	$(LATEXMK) "$<" -jobname=$(DOCNAME)
	@echo "${OK} Done building $@"


.PHONY: bib
bib: clean-bib $(SRCBIBS)		## Download the latest bibliographies from Researchr and fix them

# Download a bibliography from Researchr and fix it
%.bib:
	curl -s "https://researchr.org/downloadbibtex/bibliography/$(notdir $*)" -o $@
	sed -i '' '1 s/^/% /' $@
	sed -i '' 's/doi = {http.*\/\(10\..*\)}/doi = {\1}/' $@
	sed -i '' '/doi = {http.*}/d' $@
	sed -i '' 's/\&uuml;/ü/' $@
	@echo "Updated $@ from https://researchr.org/downloadbibtex/bibliography/$(notdir $*)"


.PHONY: clean-bib
clean-bib:		## Remove the bibliographies
	-@rm $(SRCBIBS) 2> /dev/null


.PHONY: clean
clean:			## Removes PDF build files
	@echo "${INFO} Cleaning auxiliary files and $(DOCUMENT)..."
	-@$(LATEXMK) -C $(DOCUMENT)
	@echo "${OK} Auxiliary files and $(DOCUMENT) cleaned."


.PHONY: clean-all
clean-all: clean clean-bib		## Removes all build files


.PHONY: clean-force
clean-force:		## Force remove all auxillary files without using latexmk
	@echo "Force-removing auxiliary files and $(DOCUMENT)..."
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
	@echo "All auxiliary files and $(DOCUMENT) have been force-removed."


.PHONY: watch
watch:					## Watch for changes and rebuild
	@echo "Watching for changes..."
	$(LATEXMK) $(LIVE) $(MAINTEX) -jobname=$(DOCNAME)


### =============================================================================
##@ Archiving
### =============================================================================

.PHONY: snapshot
snapshot: $(DOCUMENT)		## Copy the latest built PDF to the snapshots directory
	@echo "${INFO} Creating a snapshot of the PDF..."
	$(eval SNAPSHOTFILE := $(shell date +"%Y%m%dT%H%M%S")-$(SNAPNAME).pdf)
	mkdir -p $(SNAPDIR)
	cp "$<" $(SNAPDIR)/$(SNAPSHOTFILE)
	@echo "${OK} Snapshot created at: $(SNAPDIR)/$(SNAPSHOTFILE)"


.PHONY: archive
archive: $(DOCUMENT)		## Create an archive with the source files
	@echo "${INFO} Archiving source files as ZIP..."
	$(eval ARCHIVEFILE := $(abspath $(ARCHIVEDIR)/$(shell date '+%Y%m%d%H%M')-$(ARCHIVENAME).zip))
	mkdir -p $(ARCHIVEDIR)
	-@rm $(ARCHIVEFILE) 2> /dev/null
	cd $(SRCDIR)     && zip        $(ARCHIVEFILE) $(shell cd $(SRCDIR)     && find . -type f -name '*.tex' -o -name '*.bib' -o -name '*.png' -o -name '*.cls' -o -name '*.bst' -o -name '*.pdf')
	cd $(LIBDIR)     && zip --grow $(ARCHIVEFILE) $(shell cd $(LIBDIR)     && find . -type f)
	cd $(BUILDDIR)   && zip --grow $(ARCHIVEFILE) $(shell cd $(BUILDDIR)   && find . -type f -name '*.bbl')
	cd .                zip --grow $(ARCHIVEFILE) $(shell cd .             && find . -type f -maxdepth 1 -name '*.tex' -o -name 'README.md' -o -name 'Makefile' -o -name 'latexmkrc')
	@echo "${OK} Source files archived at: $(ARCHIVEFILE)"


### =============================================================================
##@ Preparation
### =============================================================================

.PHONY: aux-dirs
aux-dirs:	## Create auxiliary directories for the build process
	@echo "${INFO} Creating auxiliary directories..."
	./create-aux-dirs.sh
	@echo "${OK} Auxiliary directories created."


