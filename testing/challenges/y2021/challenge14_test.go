package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge14nPart01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge14{}, "data/y2021/test/Challenge14.in", "1588")
}

func TestChallenge14Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge14{}, "data/y2021/test/Challenge14.in", "2188189693529")
}

func BenchmarkChallenge14Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge14{}, "data/y2021/Challenge14.in")
}

func BenchmarkChallenge14Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge14{}, "data/y2021/Challenge14.in")
}
