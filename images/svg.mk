TEX=pdflatex
TEX_FILES=$(shell find *.tex)
DOT_FILES=$(shell find *.dot)
SVG_FILES=$(TEX_FILES:.tex=.svg) $(DOT_FILES:.dot=.svg)

.PRECIOUS: %.pdf

all: $(SVG_FILES)

%.pdf: %.tex
	$(TEX) $<

%.pdf: %.dot
	dot -Tpdf $< > $@

%.svg: %.pdf
	pdf2svg $< $@

%.svg: %.dot
	dot -Tsvg $< > $@

clean:
	rm -rf *.pdf *.aux *.log
