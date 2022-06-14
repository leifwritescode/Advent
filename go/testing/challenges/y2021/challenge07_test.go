package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge07Part01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge07{}, "data/y2021/test/Challenge07.in", "37")
}

func TestChallenge07Part02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge07{}, "data/y2021/test/Challenge07.in", "168")
}

func BenchmarkChallenge07Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge07{}, "data/y2021/Challenge07.in")
}

func BenchmarkChallenge07Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge07{}, "data/y2021/Challenge07.in")
}
