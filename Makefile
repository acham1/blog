.PHONY: build
build:
	bundle exec jekyll build -d docs

.PHONY: serve
serve:
	bundle exec jekyll serve