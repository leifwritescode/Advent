package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge05Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge05{}, "data/y2021/test/challenge05.in", "5")
}

func TestChallenge05Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge05{}, "data/y2021/test/challenge05.in", "12")
}

func BenchmarkChallenge05Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge05{}, "data/y2021/challenge05.in")
}

func BenchmarkChallenge05Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge05{}, "data/y2021/challenge05.in")
}
