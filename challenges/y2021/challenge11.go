package challenges

import (
	"fmt"
	"io/ioutil"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge11 struct {
	challenges.BaseChallenge
	input  []int
	width  int
	height int
}

// this particular example initialises a simple integer array
func (c *Challenge11) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		temp := strings.Split(str, "\n")
		sanitised := strings.ReplaceAll(str, "\n", "")
		sanitised = strings.Join(strings.Split(sanitised, ""), ",")
		json := fmt.Sprintf("[%s]", sanitised)

		c.width = len(temp[0])
		c.height = len(temp)
		c.input = utils.MakeArray(json)
	}
	return err
}

func (c *Challenge11) contains(arr []int, val int) bool {
	for _, v := range arr {
		if v == val {
			return true
		}
	}
	return false
}

// for a give point (x,y) return all adjacent points that are in bounds
// there's a bug in here
func (c *Challenge11) validAdjacents(val int) []int {
	x := val % c.width
	y := val / c.width
	valid := make([]int, 0)
	offsets := []common_math.Point{
		{X: -1, Y: 0},
		{X: 1, Y: 0},
		{X: 0, Y: -1},
		{X: 0, Y: 1},
		{X: -1, Y: -1},
		{X: -1, Y: 1},
		{X: 1, Y: -1},
		{X: 1, Y: 1},
	}

	for i := 0; i < len(offsets); i++ {
		offset := offsets[i]
		cell := common_math.Point{
			X: offset.X + x,
			Y: offset.Y + y,
		}

		if cell.X == common_math.Clamp(cell.X, 0, c.width-1) && cell.Y == common_math.Clamp(cell.Y, 0, c.height-1) {
			valid = append(valid, cell.Y*c.width+cell.X)
		}
	}

	return valid
}

func (c *Challenge11) doStep(jellies []int) (int, []int) {
	// 1) every jelliboi has its energy increased by 1
	for i := range jellies {
		jellies[i] += 1
	}

	last_flashes := -1
	flashed := make([]int, 0)
	// 2c) repeat ad nauseum until no further flashes occur
	for last_flashes != len(flashed) {
		last_flashes = len(flashed)
		for i, v := range jellies {
			// 2a) then, any with an energy greater than 9 flashes
			// 	   if the jelly has already flashed, it does not flash again
			if v > 9 && !c.contains(flashed, i) {
				flashed = append(flashed, i)

				// 2b) this increases the energy of the 8 adjacent jellies
				indices := c.validAdjacents(i)
				for _, v := range indices {
					jellies[v] += 1
				}
			}
		}
	}

	// 3) all octupuses that flashes are set to 0
	for _, v := range flashed {
		jellies[v] = 0
	}

	// return the new state of play
	return len(flashed), jellies
}

func (c *Challenge11) SolvePartOne() string {
	flashes := 0
	jellies := c.input
	for i := 0; i < 100; i++ {
		t, j := c.doStep(jellies)
		flashes += t
		jellies = j

	}
	return fmt.Sprintf("%d", flashes)
}

func (c *Challenge11) SolvePartTwo() string {
	jellies := c.input
	steps := 0
	flashes := 0
	for flashes != len(jellies) {
		flashes, jellies = c.doStep(jellies)
		steps++
	}
	return fmt.Sprintf("%d", steps)
}
