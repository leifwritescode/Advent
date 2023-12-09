package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge04Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge04{}, "data/y2021/test/challenge04.in", "4512")
}

func TestChallenge04Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge04{}, "data/y2021/test/challenge04.in", "1924")
}

func BenchmarkChallenge04Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge04{}, "data/y2021/challenge04.in")
}

func BenchmarkChallenge04Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge04{}, "data/y2021/challenge04.in")
}
