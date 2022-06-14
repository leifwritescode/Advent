package challenges

import (
	"fmt"
	"io/ioutil"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge09 struct {
	challenges.BaseChallenge
	input         []int
	width         int
	height        int
	lava_tube_map map[common_math.Point]common_math.Point
}

// this particular example initialises a simple integer array
func (challenge *Challenge09) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		temp := strings.Split(str, "\n")
		sanitised := strings.ReplaceAll(str, "\n", "")
		sanitised = strings.Join(strings.Split(sanitised, ""), ",")
		json := fmt.Sprintf("[%s]", sanitised)

		challenge.width = len(temp[0])
		challenge.height = len(temp)
		challenge.input = utils.MakeArray(json)
		challenge.lava_tube_map = make(map[common_math.Point]common_math.Point)
	}
	return err
}

// for a give point (x,y) return all adjacent points that are in bounds
// there's a bug in here
func (c *Challenge09) validAdjacents(x, y int) []common_math.Point {
	valid := make([]common_math.Point, 0)
	offsets := []common_math.Point{
		{X: -1, Y: 0},
		{X: 1, Y: 0},
		{X: 0, Y: -1},
		{X: 0, Y: 1},
	}

	for i := 0; i < len(offsets); i++ {
		offset := offsets[i]
		cell := common_math.Point{
			X: offset.X + x,
			Y: offset.Y + y,
		}
		if cell.X == common_math.Clamp(cell.X, 0, c.width-1) && cell.Y == common_math.Clamp(cell.Y, 0, c.height-1) {
			valid = append(valid, cell)
		}
	}

	return valid
}

// for a given x,y coord, gives the path to the basin
func (c *Challenge09) bfsForBasins(x, y int) {
	// the cell we're presently standing in
	this_cell := common_math.Point{X: x, Y: y}

	// if the neighbour is already known, ignore this one
	if _, ok := c.lava_tube_map[this_cell]; ok {
		return
	}

	// the lowest surrounding neighbour -- a value equal to ourselves means we are a basin
	lowest_neighbour := this_cell
	// and it's height, from 0 to 9. starts as the current cell's value
	lowest_neighbour_height := c.input[y*c.width+x]

	// all possible neighbours
	neighbours := c.validAdjacents(x, y)
	//log.Println("neighbours of (", x, ",", y, ") are", neighbours)

	// iterate over the neighbours
	for i := 0; i < len(neighbours); i++ {
		temp := neighbours[i]
		neighbour_height := c.input[temp.Y*c.width+temp.X]
		if neighbour_height <= lowest_neighbour_height {
			lowest_neighbour_height = neighbour_height
			lowest_neighbour = temp
		}
	}

	// update the map
	c.lava_tube_map[this_cell] = lowest_neighbour

	// and continue traversal if we've not found the end
	if this_cell != lowest_neighbour {
		c.bfsForBasins(lowest_neighbour.X, lowest_neighbour.Y)
	}
}

// returns all values in values that match predicate
func (c *Challenge09) allWhere(values map[common_math.Point]common_math.Point, predicate func(p1, p2 common_math.Point) bool) []common_math.Point {
	result := make([]common_math.Point, 0)
	for k, v := range values {
		if predicate(k, v) {
			result = append(result, k)
		}
	}
	return result
}

func (c *Challenge09) SolvePartOne() string {
	// i could totally do this with go routines lmfao
	for y := 0; y < c.height; y++ {
		for x := 0; x < c.width; x++ {
			c.bfsForBasins(x, y)
		}
	}

	// count the basins and compute total risk
	// first answer was 1815 and that was too high
	basins := c.allWhere(c.lava_tube_map, func(p1, p2 common_math.Point) bool { return p1 == p2 })
	total_risk := 0
	for i := 0; i < len(basins); i++ {
		p := basins[i]
		total_risk += 1 + c.input[p.Y*c.width+p.X]
	}
	return fmt.Sprintf("%d", total_risk)
}

func (c *Challenge09) SolvePartTwo() string {
	return "not implemented"
}
