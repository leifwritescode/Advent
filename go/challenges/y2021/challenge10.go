package challenges

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
)

var (
	// illegal character score table
	score_table_p1 map[rune]int = map[rune]int{
		')': 3,
		']': 57,
		'}': 1197,
		'>': 25137,
	}

	// autocomplete score table
	score_table_p2 map[rune]int = map[rune]int{
		'(': 1,
		'[': 2,
		'{': 3,
		'<': 4,
	}

	// mapping of closing braces to opening braces
	close_open map[rune]rune = map[rune]rune{
		')': '(',
		']': '[',
		'}': '{',
		'>': '<',
	}
)

type Challenge10 struct {
	challenges.BaseChallenge
	input []string
}

// this particular example initialises a simple integer array
func (challenge *Challenge10) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		challenge.input = strings.Split(str, "\n")
	}
	return err
}

// Checks syntax, returning 0 if incomplete or a score if illegal
// If incomplete, returns the stack as well
func (c *Challenge10) checkSyntax(line string) (int, []rune) {
	stack := make([]rune, 0)
	program := []rune(line)

	for i := 0; i < len(program); i++ {
		// get next brace
		r := program[i]
		// if it's a closing brace
		if v, ok := close_open[r]; ok {
			// get the last opening brace
			o := len(stack) - 1
			r2 := stack[o]
			// correct the stack
			stack = stack[:o]
			// if the last opening brace does not match this one, it's invalid
			if v != r2 {
				return score_table_p1[r], nil
			}
		} else {
			stack = append(stack, r)
		}
	}

	return 0, stack
}

func (c *Challenge10) SolvePartOne() string {
	score := 0
	for i := 0; i < len(c.input); i++ {
		line := c.input[i]
		s, _ := c.checkSyntax(line)
		score += s
	}

	return fmt.Sprintf("%d", score)
}

// uses the syntax checker to identify the incomplete programs, returning their stacks
func (c *Challenge10) findIncomplete() [][]rune {
	incomplete := make([][]rune, 0)
	for i := 0; i < len(c.input); i++ {
		line := c.input[i]
		if s, r := c.checkSyntax(line); s == 0 {
			incomplete = append(incomplete, r)
		}
	}
	return incomplete
}

// given a stack, compute the autocomplete score
func (c *Challenge10) autocomplete(stack []rune) int {
	score := 0

	// now, score the remaining stack in reverse
	for i := len(stack) - 1; i >= 0; i-- {
		r := stack[i]
		score = (score * 5) + score_table_p2[r]
	}

	return score
}

func (c *Challenge10) SolvePartTwo() string {
	score := make([]int, 0)
	incomplete := c.findIncomplete()

	for i := 0; i < len(incomplete); i++ {
		line := incomplete[i]
		score = append(score, c.autocomplete(line))
	}

	sort.Sort(sortableIntArray(score))
	result := score[len(score)/2]

	return fmt.Sprintf("%d", result)
}
