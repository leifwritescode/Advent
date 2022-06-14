package challenges

import (
	"fmt"
	"io/ioutil"
	"strings"
	"unicode"

	"github.com/championofgoats/advent-of-gode/challenges"
)

type Challenge12 struct {
	challenges.BaseChallenge
	input map[string][]string
}

// this particular example initialises a simple integer array
func (c *Challenge12) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		lines := strings.Split(str, "\n")
		input := make(map[string][]string)
		for _, line := range lines {
			pair := strings.Split(line, "-")
			a := pair[0]
			b := pair[1]

			// append bidirectionally
			input[a] = append(input[a], b)
			input[b] = append(input[b], a)
		}
		c.input = input
	}
	return err
}

// returns true if a string is all lowercase
func (c *Challenge12) isLower(str string) bool {
	for _, r := range str {
		if unicode.IsLetter(r) && !unicode.IsLower(r) {
			return false
		}
	}
	return true
}

func (c *Challenge12) arrayContains(arr []string, val string) bool {
	for _, v := range arr {
		if v == val {
			return true
		}
	}
	return false
}

func (c *Challenge12) dfsFindValidPathCountV2(path []string, next_node string, small_cave_flag bool, small_cave_master_flag bool) int {
	// we found a valid win condition
	if next_node == "start" {
		return 1
	}

	// new rule!
	// a single small cave can be visited twice
	// if a small cave appears twice, pass a flag through the stack to let it know

	isSmallCave := c.isLower(next_node)
	alreadyVisited := c.arrayContains(path, next_node)
	if isSmallCave && alreadyVisited {
		if small_cave_flag || !small_cave_master_flag {
			// we've visited this node twice before
			return 0
		} else {
			// if we've not visited a small cave twice yet then we have now
			small_cave_flag = true
		}
	}

	// otherwise, lets pull its list of adjacents to iterate
	adjacents := c.input[next_node]

	// if we've just been called, need to make something to append to
	if path == nil {
		path = make([]string, 0)
	}

	// and add 1 for any valid path found from this node
	sum := 0
	for _, adjacent := range adjacents {
		if adjacent != "end" {
			sum += c.dfsFindValidPathCountV2(append(path, next_node), adjacent, small_cave_flag, small_cave_master_flag)
		}
	}

	// return the sum of paths found from this node
	return sum
}

func (c *Challenge12) SolvePartOne() string {
	result := c.dfsFindValidPathCountV2(nil, "end", false, false)
	return fmt.Sprintf("%d", result)
}

func (c *Challenge12) SolvePartTwo() string {
	result := c.dfsFindValidPathCountV2(nil, "end", false, true)
	return fmt.Sprintf("%d", result)
}
