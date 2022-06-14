.PHONY: all clean day5 test

ROOT_DIR=src/championofgoats/advent
UTIL_DIR=$(ROOT_DIR)/utils
UTIL_SRC=$(shell find $(UTIL_DIR) -name '*.kt')

y2019:
	$(eval $@_ROOT_DIR := $(ROOT_DIR)/2019)
	$(eval $@_DATA_DIR := $($@_ROOT_DIR)/data)
	$(eval $@_DAY_DIR := $($@_ROOT_DIR)/day$(DAY))
	$(eval $@_UTIL_SRC := $(shell find $($@_ROOT_DIR) -name '*.kt' ! -name 'day*.kt'))

ifndef DAY
	$(error DAY should be set to a non-zero integer between 1 and 25 inclusive (eg: make DAY=1))
endif

ifneq ($(wildcard $($@_DAY_DIR)/*),)
	kotlinc $($@_DAY_DIR)/day$(DAY).kt $($@_UTIL_SRC) $(UTIL_SRC) -include-runtime -d bin/day$(DAY).jar
	@java -jar bin/day$(DAY).jar $($@_DATA_DIR)/day$(DAY).input
else
	@echo "Solution does not exist for day $(DAY) problem."
endif

clean:
	@echo "Cleaning up old JAR files..."
	@find . -type f -name *.jar -exec rm {} \; -print
