SV_SYNTAX=--syntax-definition syntax/systemverilog.xml
FILTERS=pandoc-xnos
DOCKER_USER=--user 1000:1000
LATEX_TEMPLATE=templates/eisvogel.tex
PANDOC_FLAGS=--toc --top-level-division=chapter --number-sections

docker: book/title.txt $(shell find book/*.md)
	docker run --rm -v `(pwd)`:/systemverilog ${DOCKER_USER} keyiz/pandoc /systemverilog/scripts/build.sh


systemverilog.pdf: book/title.txt $(shell find book/*.md)
	pandoc ${SV_SYNTAX}  -o $@ $^ --filter ${FILTERS} ${PANDOC_FLAGS} --template=${LATEX_TEMPLATE}

html/index.html:
	pandoc ${SV_SYNTAX} -s -o index.html --highlight-style pygments --filter ${FILTERS} ${PANDOC_FLAGS}

clean:
	rm -rf *.pdf
	make -C images clean
