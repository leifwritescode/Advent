package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge08Part01_01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge08{}, "data/y2021/test/Challenge08_01.in", "0")
}

func TestChallenge08Part01_02(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge08{}, "data/y2021/test/Challenge08_02.in", "26")
}

func TestChallenge08Part02_01(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge08{}, "data/y2021/test/Challenge08_01.in", "5353")
}

func TestChallenge08Part02_02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge08{}, "data/y2021/test/Challenge08_02.in", "61229")
}

func BenchmarkChallenge08Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge08{}, "data/y2021/Challenge08.in")
}

func BenchmarkChallenge08Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge08{}, "data/y2021/Challenge08.in")
}
