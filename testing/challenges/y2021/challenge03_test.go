package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge03Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge03{}, "data/y2021/test/challenge03.in", "198")
}

func TestChallenge03Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge03{}, "data/y2021/test/challenge03.in", "230")
}

func BenchmarkChallenge03Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge03{}, "data/y2021/challenge03.in")
}

func BenchmarkChallenge03Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge03{}, "data/y2021/challenge03.in")
}
