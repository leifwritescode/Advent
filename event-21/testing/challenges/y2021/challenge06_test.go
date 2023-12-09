package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge06Part01_18days(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge06{Lifetime: 18}, "data/y2021/test/challenge06.in", "26")
}

func TestChallenge06Part01_80days(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge06{}, "data/y2021/test/challenge06.in", "5934")
}

func TestChallenge06Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge06{}, "data/y2021/test/challenge06.in", "26984457539")
}

func BenchmarkChallenge06Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge06{}, "data/y2021/challenge06.in")
}

func BenchmarkChallenge06Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge06{}, "data/y2021/challenge06.in")
}
