package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge02Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge02{}, "data/y2021/test/challenge02.in", "150")
}

func TestChallenge02Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge02{}, "data/y2021/test/challenge02.in", "900")
}

func BenchmarkChallenge02Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge02{}, "data/y2021/challenge02.in")
}

func BenchmarkChallenge02Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge02{}, "data/y2021/challenge02.in")
}
