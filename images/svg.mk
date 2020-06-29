TEX=pdflatex
TEX_FILES=$(shell find *.tex)
SVG_FILES=$(TEX_FILES:.tex=.svg)

.PRECIOUS: %.pdf

all: $(SVG_FILES)

%.pdf: %.tex
	$(TEX) $<

%.svg: %.pdf
	pdf2svg $< $@

clean:
	rm -rf *.svg *.pdf *.aux *.log
