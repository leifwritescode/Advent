package challenges

import (
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
)

type Challenge14 struct {
	challenges.BaseChallenge
	formula   string
	compounds map[string]string
}

// this particular example initialises a simple integer array
func (c *Challenge14) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		lines := strings.Split(str, "\n")
		c.formula = lines[0]
		lines = lines[2:]
		c.compounds = make(map[string]string)
		for _, line := range lines {
			mapping := strings.Split(line, " -> ")
			c.compounds[mapping[0]] = mapping[1]
		}
	}
	return err
}

func (c *Challenge14) generateNewPolymer(input string) string {
	var output = ""
	runes := []rune(input)
	for i := 0; i < len(runes); i++ {
		if i+1 >= len(runes) {
			output = fmt.Sprintf("%s%c", output, runes[i])
		} else {
			a := runes[i]
			b := runes[i+1]
			d := fmt.Sprintf("%c%c", a, b)
			e := c.compounds[d]
			output = fmt.Sprintf("%s%c%s", output, a, e)
		}
	}
	return output
}

// Because the string grows to len*2-1 each time,
// It is ultimately 2^cycles*(init_len-1)+1 in length
func (c *Challenge14) solve(cycles int) string {
	// compute the polymer
	s := c.formula
	for i := 0; i < cycles; i++ {
		log.Println("Starting cycle", i+1)
		s = c.generateNewPolymer(s)
	}

	// map the compounds to their occurrences
	counts := make(map[rune]int)
	for _, r := range s {
		counts[r]++
	}

	// find the answer
	min := math.MaxUint32
	max := 0
	for _, v := range counts {
		min = common_math.Min32(min, v)
		max = common_math.Max32(max, v)
	}

	return fmt.Sprintf("%d", max-min)
}

func (c *Challenge14) solve2(cycles int) string {
	// compute the initial pairs
	pairs := make(map[string]int64)
	runes := []rune(c.formula)
	for i := 1; i < len(c.formula); i++ {
		a := runes[i-1]
		b := runes[i]
		pairs[fmt.Sprintf("%c%c", a, b)] += 1
	}

	// do the cycles
	for i := 0; i < cycles; i++ {
		temp := make(map[string]int64)
		for k, v := range pairs {
			a := string(k[0])
			b := string(k[1])
			d := c.compounds[k]
			temp[fmt.Sprintf("%s%s", a, d)] += v
			temp[fmt.Sprintf("%s%s", d, b)] += v
		}
		pairs = temp
	}

	// map the compounds to their occurrences
	counts := make(map[string]int64)
	for k, v := range pairs {
		a := string(k[0])
		b := string(k[1])
		counts[a] += v
		counts[b] += v
	}

	// find the answer
	var min int64 = math.MaxInt64
	var max int64 = 0
	for _, v := range counts {
		min = common_math.Min(min, v)
		max = common_math.Max(max, v)
	}

	// correct the values
	max = (max + 1) / 2
	min = (min + 1) / 2
	return fmt.Sprintf("%d", max-min)
}

func (c *Challenge14) SolvePartOne() string {
	return c.solve2(10)
}

func (c *Challenge14) SolvePartTwo() string {
	return c.solve2(40)
}
