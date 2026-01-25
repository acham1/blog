.PHONY: help
help:
	@echo "make serve  - Serve locally with live reload"
	@echo "make build  - Build static site to docs/"

.PHONY: build
build:
	bundle exec jekyll build -d docs

.PHONY: serve
serve:
	bundle exec jekyll serve