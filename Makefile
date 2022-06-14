.PHONY: day1 day2

day1:
	kotlinc $@/$@.kt -include-runtime -d bin/$@.jar
	java -jar bin/$@.jar $@/$@.input

day2:
	kotlinc $@/$@.kt -include-runtime -d bin/$@.jar
	java -jar bin/$@.jar $@/$@.input
