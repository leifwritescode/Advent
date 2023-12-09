package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge10nPart01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge10{}, "data/y2021/test/Challenge10.in", "26397")
}

func TestChallenge10Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge10{}, "data/y2021/test/Challenge10.in", "288957")
}

func BenchmarkChallenge10Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge10{}, "data/y2021/Challenge10.in")
}

func BenchmarkChallenge10Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge10{}, "data/y2021/Challenge10.in")
}
