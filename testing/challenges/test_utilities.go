package challenge_tests

import (
	"testing"

	"github.com/championofgoats/advent-of-gode/challenges"
	"github.com/championofgoats/advent-of-gode/utilities"
)

// Reusable test case code for part one
func ExecuteSolutionPartOneTest(t *testing.T, challenge challenges.BaseChallenge, file_path string, expected string) {
	err := challenge.Initialise(utilities.RootDir(file_path))
	utilities.Guard(err)

	actual := challenge.SolvePartOne()

	if actual != expected {
		t.Fatalf("Expected %s but got %s", expected, actual)
	}
}

// Reusable test case code for part two
func ExecuteSolutionPartTwoTest(t *testing.T, challenge challenges.BaseChallenge, file_path string, expected string) {
	err := challenge.Initialise(utilities.RootDir(file_path))
	utilities.Guard(err)

	actual := challenge.SolvePartTwo()

	if actual != expected {
		t.Fatalf("Expected %s but got %s", expected, actual)
	}
}

// Reusable benchmark code for part one
func ExecuteSolutionPartOneBenchmark(b *testing.B, challenge challenges.BaseChallenge, file_path string) {
	challenge.Initialise(utilities.RootDir(file_path))

	for n := 0; n < b.N; n++ {
		challenge.SolvePartOne()
	}
}

// Reusable benchmark code for part two
func ExecuteSolutionPartTwoBenchmark(b *testing.B, challenge challenges.BaseChallenge, file_path string) {
	challenge.Initialise(utilities.RootDir(file_path))

	for n := 0; n < b.N; n++ {
		challenge.SolvePartTwo()
	}
}
