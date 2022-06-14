package challenge_tests

import (
	"testing"

	challenges "github.com/championofgoats/advent-of-gode/challenges/y2021"
	test "github.com/championofgoats/advent-of-gode/testing/challenges"
)

func TestChallenge12Part01_01(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge12{}, "data/y2021/test/Challenge12_01.in", "10")
}

func TestChallenge12Part01_02(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge12{}, "data/y2021/test/Challenge12_02.in", "19")
}

func TestChallenge12Part01_03(t *testing.T) {
	test.ExecuteSolutionPartOneTest(t, &challenges.Challenge12{}, "data/y2021/test/Challenge12_03.in", "226")
}

func TestChallenge12Part02_01(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge12{}, "data/y2021/test/Challenge12_01.in", "36")
}

func TestChallenge12Part02_02(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge12{}, "data/y2021/test/Challenge12_02.in", "103")
}

func TestChallenge12Part02_03(t *testing.T) {
	test.ExecuteSolutionPartTwoTest(t, &challenges.Challenge12{}, "data/y2021/test/Challenge12_03.in", "3509")
}

func BenchmarkChallenge12Part01(b *testing.B) {
	test.ExecuteSolutionPartOneBenchmark(b, &challenges.Challenge12{}, "data/y2021/Challenge12.in")
}

func BenchmarkChallenge12Part02(b *testing.B) {
	test.ExecuteSolutionPartTwoBenchmark(b, &challenges.Challenge12{}, "data/y2021/Challenge12.in")
}
