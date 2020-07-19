SHELL := /bin/bash
PROJ_DIR = .
LATEXMK = latexmk
BUILD_OPTIONS = -pdf
CLEAN_OPTIONS = -quiet -c
BIB_FILES = *.bbl,*.run.xml,*.fls
SYNCTEX_FILES = main.synctex.gz
MISC_FILES = *.swp,*.tdo

.PHONY: build clean

build:
	@cd $(PROJ_DIR); $(LATEXMK) $(BUILD_OPTIONS)

clean:
	@echo "* Clean regeneratable files"
	@cd $(PROJ_DIR); $(LATEXMK) $(CLEAN_OPTIONS)
	@echo "* Clean bib files"
	@rm -f $(PROJ_DIR)/{$(BIB_FILES)}
	@echo "* Clean synctex files"
	@rm -f $(PROJ_DIR)/$(SYNCTEX_FILES)
	@echo "* Clean misc files"
	@rm -f $(PROJ_DIR)/{$(MISC_FILES)}
