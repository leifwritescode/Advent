.PHONY: run clean

ROOT_DIR=src/championofgoats/advent
ROOT_SRC=$(filter-out %mirror.kt, $(shell find $(ROOT_DIR) -name '*.kt' -maxdepth 1))
UTIL_SRC=$(shell find $(ROOT_DIR)/utils -name '*.kt')
ADVENT_JAR=bin/advent.jar
Y=2019

build:
	$(eval $@_ROOT_DIR := $(ROOT_DIR)/$(Y))
	$(eval $@_YEAR_SRC := $(shell find  $($@_ROOT_DIR) -name '*.kt'))
	kotlinc $(ROOT_SRC) $($@_YEAR_SRC) $(UTIL_SRC) -include-runtime -d $(ADVENT_JAR)

run: build
ifndef D
	$(error D should be set to a non-zero integer between 1 and 25 inclusive (eg: make D=1))
endif
	$(eval $@_ROOT_DIR := $(ROOT_DIR)/$(Y))
	$(eval $@_DATA_DIR := $($@_ROOT_DIR)/data)
	$(eval $@_DAY_DIR := $($@_ROOT_DIR)/day$(D))
	@java -jar $(ADVENT_JAR) -y $(Y) -d $(D) -i $($@_DATA_DIR) -o $($@_DAY_DIR)

clean:
	@echo "Cleaning up old JAR files..."
	@find . -type f -name *.jar -exec rm {} \; -print
