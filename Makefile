SLIDE_RMD_FILES := $(wildcard static/slides/*.Rmd)
SLIDE_HTML_FILES  := $(subst Rmd,html,$(SLIDE_RMD_FILES))

.PHONY: clean push

build: $(SLIDE_HTML_FILES)
	hugo

open: build
	open docs/index.html

clean:
	rm -rf docs/
	rm -f static/slides/*.html

push: build
	@cd docs/;  \
	 git add .; \
	 git commit -m "Update site content"; \
	 git push
	

static/slides/%.html: static/slides/%.Rmd
	@echo "Rendering post: $(@F)"
	@Rscript -e "rmarkdown::render('$<')"
