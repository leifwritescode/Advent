.PHONY: all clean

all:
ifndef DAY
	$(error DAY should be set to a non-zero integer between 1 and 25 inclusive (eg: make DAY=1))
endif
ifneq ($(wildcard day$(DAY)/.),)
	kotlinc day$(DAY)/day$(DAY).kt -include-runtime -d bin/day$(DAY).jar
	@java -jar bin/day$(DAY).jar day$(DAY)/day$(DAY).input
else
	@echo "Solution does not exist for day $(DAY) problem."
endif

clean:
	@echo "Cleaning up old JAR files..."
	@find . -type f -name *.jar -exec rm {} \; -print