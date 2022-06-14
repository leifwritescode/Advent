package challenges

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type sortableIntArray []int

func (s sortableIntArray) Less(i, j int) bool {
	return s[i] > s[j]
}

func (s sortableIntArray) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s sortableIntArray) Len() int {
	return len(s)
}

func sortIntsDescending(s []int) []int {
	r := s
	sort.Sort(sortableIntArray(r))
	return r
}

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
func (c *Challenge09) dfsMapBasins(x, y int) {
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
		c.dfsMapBasins(lowest_neighbour.X, lowest_neighbour.Y)
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
			c.dfsMapBasins(x, y)
		}
	}

	// count the basins and compute total risk
	basins := c.allWhere(c.lava_tube_map, func(p1, p2 common_math.Point) bool { return p1 == p2 })
	total_risk := 0
	for i := 0; i < len(basins); i++ {
		p := basins[i]
		total_risk += 1 + c.input[p.Y*c.width+p.X]
	}
	return fmt.Sprintf("%d", total_risk)
}

// given the location of a basin, find total length of all
// called recursively
func (c *Challenge09) dfsTracePath(p common_math.Point) []common_math.Point {
	// for a given point, p,  we need to find all points that lead to this point (except ourselves if we're a basin)
	// given a map [a] => b where b is the destination and a is the origin
	// if a == p then b is a basin
	// if [a] == p then a is its ancestor
	// if height at a == 9 then it's not actually part of the basin

	result := []common_math.Point{p}

	for a, b := range c.lava_tube_map {
		height := c.input[a.Y*c.width+a.X]
		if b == p && a != p && height != 9 {
			result = append(result, c.dfsTracePath(a)...)
		}
	}

	return result
}

func (c *Challenge09) SolvePartTwo() string {
	// if in test, create the map first
	if len(c.lava_tube_map) == 0 {
		c.SolvePartOne()
	}

	basin_sizes := make([]int, 0)
	for k, v := range c.lava_tube_map {
		// basins lead to themselves
		if k == v {
			path := c.dfsTracePath(k)

			// uncomment me to visualise the basin
			// c.visualiseBasin(path)

			// append the length of that set
			basin_sizes = append(basin_sizes, len(path))
		}
	}

	// 2046720 was too high
	basin_sizes = sortIntsDescending(basin_sizes)
	result := basin_sizes[0] * basin_sizes[1] * basin_sizes[2]
	return fmt.Sprintf("%d", result)
}
