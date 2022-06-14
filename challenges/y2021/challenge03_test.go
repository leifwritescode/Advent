package y2021

import (
	"testing"

	utils "github.com/championofgoats/advent-of-gode/utilities"
)

func TestChallenge03Part01(t *testing.T) {
	c := &Challenge03{}
	err := c.Initialise(utils.RootDir("data/y2021/test/challenge03.in"))
	utils.Guard(err)

	e := "198"
	a := c.SolvePartOne()

	if a != e {
		t.Fatalf("Expected %s but got %s", e, a)
	}
}

func TestChallenge03Part02(t *testing.T) {
	c := &Challenge03{}
	err := c.Initialise(utils.RootDir("data/y2021/test/challenge03.in"))
	utils.Guard(err)

	e := "230"
	a := c.SolvePartTwo()

	if a != e {
		t.Fatalf("Expected %s but got %s", e, a)
	}
}

func BenchmarkChallenge03Part01(b *testing.B) {
	c := &Challenge03{}
	c.Initialise(utils.RootDir("data/y2021/challenge03.in"))

	for n := 0; n < b.N; n++ {
		c.SolvePartOne()
	}
}

func BenchmarkChallenge03Part02(b *testing.B) {
	c := &Challenge03{}
	c.Initialise(utils.RootDir("data/y2021/challenge03.in"))

	for n := 0; n < b.N; n++ {
		c.SolvePartTwo()
	}
}
