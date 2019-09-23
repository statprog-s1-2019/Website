SLIDE_RMD_FILES := $(wildcard static/slides/*.Rmd)
SLIDE_HTML_FILES  := $(subst Rmd,html,$(SLIDE_RMD_FILES))
SLIDE_PDF_FILES  := $(subst Rmd,pdf,$(SLIDE_RMD_FILES))

.PHONY: clean push build all pdf

build: $(SLIDE_HTML_FILES)
	hugo

all: build pdf

pdf: $(SLIDE_PDF_FILES)

open: build
	open docs/index.html

clean:
	rm -rf docs/
	rm -f static/slides/*.html

push: build
	@cd docs/;  \
	 git add .; \
	 git commit -m "Update site content";
	git add docs; \
		git commit -m "Update docs submodule";
		git push;
	

static/slides/%.html: static/slides/%.Rmd
	@Rscript -e "rmarkdown::render('$<')"
	
static/slides/%.pdf: static/slides/%.html
	`npm  bin`/decktape remark $< $@ --chrome-arg=--disable-web-security
