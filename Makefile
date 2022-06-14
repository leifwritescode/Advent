.PHONY: all clean day5 test

SOLUTION_DIR = goats/aoc/day
PACKAGE_SRCS = $(wildcard goats/aoc/[!day]*/*.kt)

all:
ifndef DAY
	$(error DAY should be set to a non-zero integer between 1 and 25 inclusive (eg: make DAY=1))
endif
ifneq ($(wildcard $(SOLUTION_DIR)$(DAY)/.),)
	kotlinc $(SOLUTION_DIR)$(DAY)/day$(DAY).kt $(PACKAGE_SRCS) -include-runtime -d bin/day$(DAY).jar
	@java -jar bin/day$(DAY).jar $(SOLUTION_DIR)$(DAY)/day$(DAY).input
else
	@echo "Solution does not exist for day $(DAY) problem."
endif

clean:
	@echo "Cleaning up old JAR files..."
	@find . -type f -name *.jar -exec rm {} \; -print
