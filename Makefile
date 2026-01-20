# --- Config ---
PLATFORMDIR   ?= $(HOME)/logue-sdk/platform
INSTALLDIR    ?= ..
PD_DIR        ?= ./pd
HEAVYLIBDIR   ?= ./heavylib
PDLIBDIR      ?= ./extra

INSTALL := INSTALLDIR=$(INSTALLDIR) install

CATS := osc synth modfx delfx revfx masterfx

SCRIPTS := \
  osc:drumlogue_osc \
  synth:drumlogue_synth \
  modfx:drumlogue_modfx \
  delfx:drumlogue_delfx \
  revfx:drumlogue_revfx \
  masterfx:drumlogue_masterfx

up = $(shell echo $(1) | tr '[:lower:]' '[:upper:]')

define DEF_PATCHES_UP
$(call up,$(1))_PATCHES := \
  $(notdir $(basename $(wildcard $(PD_DIR)/$(1)/*.pd)))
endef

$(foreach c,$(CATS),$(eval $(call DEF_PATCHES_UP,$(c))))

PATCHES := $(OSC_PATCHES) $(SYNTH_PATCHES) $(MODFX_PATCHES) $(DELFX_PATCHES) $(REVFX_PATCHES) $(MASTERFX_PATCHES)

ALL_PATCH_DIRS := \
  $(OSC_PATCHES:%=osc/%) \
  $(SYNTH_PATCHES:%=synth/%) \
  $(MODFX_PATCHES:%=modfx/%) \
  $(DELFX_PATCHES:%=delfx/%) \
  $(REVFX_PATCHES:%=revfx/%) \
  $(MASTERFX_PATCHES:%=masterfx/%)


# build rule generator
# usage: $(eval $(call GEN_RULE,<cat>,<hvcc -G>))
define GEN_RULE
$(1)/%: $(PD_DIR)/$(1)/%.pd
	@echo "Processing $$(@F) in $(1)..."
	@mkdir -p $$@
	hvcc $$< -G $(2) -o $$@ -n $$(@F) -p $(PDLIBDIR) $(HEAVYLIBDIR)
	$$(MAKE) -C $$@/logue_unit PLATFORMDIR=$$(PLATFORMDIR)/drumlogue $(INSTALL)

# define target for each unit
%: $(1)/%
	@:
endef

# Generate rules for all categories
$(foreach kv,$(SCRIPTS), \
  $(eval CAT := $(word 1,$(subst :, ,$(kv)))) \
  $(eval GEN := $(word 2,$(subst :, ,$(kv)))) \
  $(eval $(call GEN_RULE,$(CAT),$(GEN))) \
)

# Targets

.PHONY: all
all: $(ALL_PATCH_DIRS)

.SECONDARY: $(ALL_PATCH_DIRS)

%.zip: %
	@echo "Archiving $@..."
	$(MAKE) -C $</logue_unit clean
	cd $< && \
	  ln -s logue_unit src && \
	  zip -r $(@F) src $(@F:.zip=.drmlgunit) ; \
	  rm -f src

.PHONY: zip
zip: $(ALL_PATCH_DIRS:%=%.zip)
	@echo "All patch archives have been created."

.PHONY: clean
clean:
	@set -e; for d in $(ALL_PATCH_DIRS); do \
	  if [ -d $$d/logue_unit ]; then \
	    $(MAKE) -C $$d/logue_unit clean; \
	  fi; \
	done

.PHONY: clean-all
clean-all:
	@set -e; \
	for d in $(ALL_PATCH_DIRS); do \
		rm -rf -- "$$d"; \
	done
