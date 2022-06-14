package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge15nPart01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge15{}, "data/y2021/test/Challenge15.in", "40")
}

func TestChallenge15Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge15{}, "data/y2021/test/Challenge15.in", "315")
}

func BenchmarkChallenge15Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge15{}, "data/y2021/Challenge15.in")
}

func BenchmarkChallenge15Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge15{}, "data/y2021/Challenge15.in")
}
