SV_SYNTAX=--syntax-definition syntax/systemverilog.xml
FILTERS=pandoc-xnos
DOCKER_USER=--user 1000:1000
LATEX_TEMPLATE=templates/eisvogel.tex
PANDOC_FLAGS=--toc --top-level-division=chapter --number-sections

.PHONY: pdf
pdf: book/title.txt $(shell find book/*.md)
	docker run --rm -v `(pwd)`:/systemverilog ${DOCKER_USER} keyiz/pandoc /systemverilog/scripts/build.sh

.PHONY: html
html: book/title.txt $(shell find book/*.md)
	docker run --rm -v `(pwd)`:/systemverilog ${DOCKER_USER} keyiz/pandoc /systemverilog/scripts/build_html.sh

systemverilog.pdf: book/title.txt $(shell find book/*.md)
	pandoc ${SV_SYNTAX}  -o $@ $^ --filter ${FILTERS} ${PANDOC_FLAGS} --template=${LATEX_TEMPLATE}

html/index.html: book/title.txt $(shell find book/*.md) scripts/html_gen.py
	mkdir -p html
	pandoc ${SV_SYNTAX} -s -o html/input.html $^ --highlight-style pygments --mathjax --filter ${FILTERS} ${PANDOC_FLAGS}
	python3 scripts/html_gen.py html/input.html html
	rm -rf html/input.html

clean:
	rm -rf *.pdf
	make -C images clean
	rm -rf html
