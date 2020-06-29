DIRS=$(shell find *-* -type d)
TEX_FILES=

all:
	$(foreach dir,$(DIRS),make -C $(dir))

clean:
	$(foreach dir,$(DIRS),make -C $(dir) clean)
