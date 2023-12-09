package challenges

import (
	"fmt"
	"io/ioutil"
	"math/big"

	"github.com/ahmetb/go-linq/v3"
	"github.com/championofgoats/advent-of-gode/challenges"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge06 struct {
	challenges.BaseChallenge
	input []int

	// number of cycles
	// useful to allow tests to change run length
	Lifetime int
}

// the input is a comma separate list of integers so there's no need to sanitised
func (challenge *Challenge06) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		json := fmt.Sprintf("[%s]", str)
		challenge.input = utils.MakeArray(json)
	}
	return err
}

func solve(challenge Challenge06, generations int) string {
	// if lifetime wasn't set, then we're running for real.
	total_generations := utils.Ctoi(challenge.Lifetime != 0, challenge.Lifetime, generations)

	// we'll construct an array of generational counts, indexed by age
	// then, for each generation, we'll shift that array down
	// the number of fishies in g[0] is the number of new babies each generation
	// the number of fishies in g[7], plus the number of new babies, is the rate of change
	// g[8] is always the last number of babies that were born.
	// this is, in simpler terms, an implementation of barrel shifting.

	g := make([]big.Int, 9)
	linq.From(challenge.input).ForEachT(func(age int) {
		n := g[age]
		g[age] = *n.Add(&n, big.NewInt(1))
	})

	for i := 0; i < total_generations; i++ {
		// g[0] is the number of new babies this gen
		babies := g[0]

		// shift the map left through babies
		// the count of g[7] is the exponential increase
		g[0], g[1], g[2], g[3], g[4], g[5], g[6], g[7], g[8] = g[1], g[2], g[3], g[4], g[5], g[6], *g[7].Add(&g[7], &babies), g[8], babies

	}

	total_fishies := new(big.Int)
	for i := 0; i < len(g); i++ {
		total_fishies.Add(total_fishies, &g[i])
	}

	return fmt.Sprintf("%d", total_fishies)
}

func (challenge *Challenge06) SolvePartOne() string {
	return solve(*challenge, 80)
}

func (challenge *Challenge06) SolvePartTwo() string {
	return solve(*challenge, 256)
}
