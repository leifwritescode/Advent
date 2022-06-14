package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge09nPart01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge09{}, "data/y2021/test/challenge09.in", "15")
}

func TestChallenge09Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge09{}, "data/y2021/test/challenge09.in", "not implemented")
}

func BenchmarkChallenge09Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge09{}, "data/y2021/challenge09.in")
}

func BenchmarkChallenge09Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge09{}, "data/y2021/challenge09.in")
}
