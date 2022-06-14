package y2021

import (
	"testing"

	utils "github.com/championofgoats/advent-of-gode/utilities"
)

func TestChallenge01Part01(t *testing.T) {
	c := &Challenge01{}
	err := c.Initialise(utils.RootDir("data/test/challenge01.in"))
	utils.Guard(err)

	e := "7"
	a := c.SolvePartOne()

	if a != e {
		t.Fatalf("Expected %s but got %s", e, a)
	}
}

func TestChallenge01Part02(t *testing.T) {
	c := &Challenge01{}
	err := c.Initialise(utils.RootDir("data/test/challenge01.in"))
	utils.Guard(err)

	e := "5"
	a := c.SolvePartTwo()

	if a != e {
		t.Fatalf("Expected %s but got %s", e, a)
	}
}

func BenchmarkChallenge01Part01(b *testing.B) {
	c := &Challenge01{}
	c.Initialise(utils.RootDir("data/challenge01.in"))

	for n := 0; n < b.N; n++ {
		c.SolvePartOne()
	}
}

func BenchmarkChallenge01Part02(b *testing.B) {
	c := &Challenge01{}
	c.Initialise(utils.RootDir("data/challenge01.in"))

	for n := 0; n < b.N; n++ {
		c.SolvePartTwo()
	}
}
