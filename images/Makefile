DIRS=$(shell find * -type d)
DIRS_TARGET=$(foreach dir,$(DIRS), $(dir)-make)
DIRS_CLEAN=$(foreach dir, $(DIRS), $(dir)-clean)

define make_image
$1-make:
	make -C $1
endef

define make_clean
$1-clean:
	make -C $1 clean
endef

all: $(DIRS_TARGET)

$(foreach dir,$(DIRS),$(eval $(call make_image,$(dir))))
$(foreach dir,$(DIRS),$(eval $(call make_clean,$(dir))))


cover.pdf: cover.svg
	rsvg-convert cover.svg -f pdf > cover.pdf

clean: $(DIRS_CLEAN)
