SHELL := /bin/bash
PROJ_DIR = # to complete
LATEXMK = latexmk -quiet
CLEAN_LVL = -c
BIB_FILES = *.bbl,*.run.xml,*.fls
SYNCTEX_FILES = main.synctex.gz
OTHERS = *.swp

.PHONY: clean

clean:
	@echo "* Clean regeneratable files"
	@cd $(PROJ_DIR); $(LATEXMK) $(CLEAN_LVL)
	@echo "* Clean bib files"
	@rm -f $(PROJ_DIR)/{$(BIB_FILES)}
	@echo "* Clean synctex files"
	@rm -f $(PROJ_DIR)/$(SYNCTEX_FILES)
	@echo "* Clean other files"
	@rm -f $(PROJ_DIR)/{$(OTHERS)}
