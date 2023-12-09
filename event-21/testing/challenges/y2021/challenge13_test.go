package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge13nPart01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge13{}, "data/y2021/test/Challenge13.in", "17")
}

func TestChallenge13Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge13{}, "data/y2021/test/Challenge13.in", "part two is a visual solution")
}

func BenchmarkChallenge13Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge13{}, "data/y2021/Challenge13.in")
}

func BenchmarkChallenge13Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge13{}, "data/y2021/Challenge13.in")
}
