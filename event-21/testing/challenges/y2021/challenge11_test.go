package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge11Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge11{}, "data/y2021/test/Challenge11.in", "1656")
}

func TestChallenge11Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge11{}, "data/y2021/test/Challenge11.in", "195")
}

func BenchmarkChallenge11Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge11{}, "data/y2021/Challenge11.in")
}

func BenchmarkChallenge11Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge11{}, "data/y2021/Challenge11.in")
}
