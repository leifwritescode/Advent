package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge01Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge01{}, "data/y2021/test/challenge01.in", "7")
}

func TestChallenge01Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge01{}, "data/y2021/test/challenge01.in", "5")
}

func BenchmarkChallenge01Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge01{}, "data/y2021/challenge01.in")
}

func BenchmarkChallenge01Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge01{}, "data/y2021/challenge01.in")
}
