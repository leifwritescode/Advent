package y2021

import (
	"testing"

	utils "github.com/championofgoats/advent-of-gode/utilities"
)

func TestChallenge02Part01(t *testing.T) {
	c := &Challenge02{}
	err := c.Initialise(utils.RootDir("data/y2021/test/challenge02.in"))
	utils.Guard(err)

	e := "150"
	a := c.SolvePartOne()

	if a != e {
		t.Fatalf("Expected %s but got %s", e, a)
	}
}

func TestChallenge02Part02(t *testing.T) {
	c := &Challenge02{}
	err := c.Initialise(utils.RootDir("data/y2021/test/challenge02.in"))
	utils.Guard(err)

	e := "900"
	a := c.SolvePartTwo()

	if a != e {
		t.Fatalf("Expected %s but got %s", e, a)
	}
}

func BenchmarkChallenge02Part01(b *testing.B) {
	c := &Challenge02{}
	c.Initialise(utils.RootDir("data/y2021/challenge02.in"))

	for n := 0; n < b.N; n++ {
		c.SolvePartOne()
	}
}

func BenchmarkChallenge02Part02(b *testing.B) {
	c := &Challenge02{}
	c.Initialise(utils.RootDir("data/y2021/challenge02.in"))

	for n := 0; n < b.N; n++ {
		c.SolvePartTwo()
	}
}
