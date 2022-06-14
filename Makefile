.PHONY: day1

day1:
	kotlinc $@/$@.kt -include-runtime -d bin/$@.jar
	java -jar bin/$@.jar $@/$@.input
