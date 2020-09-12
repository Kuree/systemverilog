DIRS=$(shell find * -type d)
TEX_FILES=

all:
	$(foreach dir,$(DIRS),make -C $(dir))

cover.pdf: cover.svg
	rsvg-convert cover.svg -f pdf > cover.pdf

clean:
	$(foreach dir,$(DIRS),make -C $(dir) clean)
