package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge09OpenCLPart01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge09_OpenCL{}, "data/y2021/test/challenge09.in", "15")
}

func TestChallenge09OpenCLPart02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge09_OpenCL{}, "data/y2021/test/challenge09.in", "I'm not implemented for this special version of challenge 09.")
}

func BenchmarkChallenge09OpenCLPart01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge09_OpenCL{}, "data/y2021/challenge09.in")
}

func BenchmarkChallenge09OpenCLPart02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge09_OpenCL{}, "data/y2021/challenge09.in")
}
