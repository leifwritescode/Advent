package challenges

import (
	"fmt"
	"io/ioutil"
	"math"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge15 struct {
	challenges.BaseChallenge
	input  []int
	width  int
	height int
}

// this particular example initialises a simple integer array
func (c *Challenge15) Initialise(file_path string) error {
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

// for a give point (x,y) return all adjacent points that are in bounds
// there's a bug in here
func (c *Challenge15) validAdjacents(val, width, height int) []int {
	x := val % width
	y := val / width
	valid := make([]int, 0)
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

		if cell.X == common_math.Clamp(cell.X, 0, width-1) && cell.Y == common_math.Clamp(cell.Y, 0, height-1) {
			valid = append(valid, cell.Y*width+cell.X)
		}
	}

	return valid
}

// function h(n), manhattan distance
// remember - the risk levels can be thought of as a distance
func (c *Challenge15) heuristic(from, from_value, to, w int) int {
	x1, y1 := from%w, from/w
	x2, y2 := to%w, to/w

	return common_math.Abs(x1-x2) + common_math.Abs(y1-y2) + from_value
}

// given an open set of indices, finds the index with the lowest associated risk in grid
func (c *Challenge15) aStar_Lowest(open_set []int, f_scores map[int]int) int {
	if len(open_set) < 1 {
		panic("empty open set")
	}

	lowest_index := open_set[0]
	for _, v := range open_set {
		if f_scores[v] < f_scores[lowest_index] {
			lowest_index = v
		}
	}
	return lowest_index
}

func (c *Challenge15) aStar_Reconstruct(came_from map[int]int, current int) []int {
	path := []int{}
	for {
		next, ok := came_from[current]
		if !ok {
			return path
		}
		path = append(path, current)
		current = next
	}
}

func (c *Challenge15) remove(value int, from []int) []int {
	for i, v := range from {
		if v == value {
			from[0], from[i] = from[i], from[0]
			from = from[1:]
			return from
		}
	}
	panic("can't remove that which does not exist")
}

// computes a path from the given array
func (c *Challenge15) aStar(risk []int, width, height int) []int {
	// The start node is the top left.
	start := 0

	// The end node is the bottom right.
	end := len(risk) - 1

	// The set of discovered nodes that may need to be (re-)expanded.
	// Initially, only the start node is known.
	// This is usually implemented as a min-heap or priority queue rather than a hash-set.
	open_set := []int{start}

	// For node n, cameFrom[n] is the node immediately preceding it on the cheapest path from start
	// to n currently known.
	came_from := map[int]int{}

	// For node n, gScore[n] is the cost of the cheapest path from start to n currently known.
	g_score := map[int]int{}
	g_score[start] = 0

	// For node n, fScore[n] := gScore[n] + h(n). fScore[n] represents our current best guess as to
	// how short a path from start to finish can be if it goes through n.
	f_score := map[int]int{}
	f_score[start] = c.heuristic(start, 0, end, width)

	for len(open_set) > 0 {
		// This operation can occur in O(1) time if openSet is a min-heap or a priority queue
		current := c.aStar_Lowest(open_set, f_score)

		if current == end {
			return c.aStar_Reconstruct(came_from, current)
		}

		open_set = c.remove(current, open_set)
		neighbours := c.validAdjacents(current, width, height)
		for _, neighbour := range neighbours {
			// d(current,neighbor) is the weight of the edge from current to neighbor
			// tentative_gScore is the distance from start to the neighbor through current
			tentative_g_score := g_score[current] + risk[neighbour]

			// ensure g_score is infinity at first use
			if _, ok := g_score[neighbour]; !ok {
				g_score[neighbour] = math.MaxInt
			}

			// ensure f_score is infinity at first use
			if _, ok := f_score[neighbour]; !ok {
				f_score[neighbour] = math.MaxInt
			}

			if tentative_g_score < g_score[neighbour] {
				came_from[neighbour] = current
				g_score[neighbour] = tentative_g_score
				f_score[neighbour] = tentative_g_score + c.heuristic(neighbour, risk[neighbour], end, width)

				if !contains_i(open_set, neighbour) {
					open_set = append(open_set, neighbour)
				}
			}
		}
	}

	// Open set is empty but goal was never reached
	panic("didn't reach goal")
}

func (c *Challenge15) SolvePartOne() string {
	grid := make([]int, len(c.input))
	copy(grid, c.input)

	sum := 0
	path := c.aStar(grid, c.width, c.height)
	for _, e := range path {
		sum += grid[e]
	}
	return fmt.Sprintf("%d", sum)
}

func (c *Challenge15) createLargeMap() []int {
	// the new map is five times larger in both dimensions
	tiles_w := 5
	tiles_h := 5
	newWidth := c.width * tiles_w
	newHeight := c.height * tiles_h
	newMap := make([]int, newWidth*newHeight)

	// first, let's insert the original map
	for y := 0; y < c.height; y++ {
		for x := 0; x < c.width; x++ {
			i_old := y*c.width + x
			i_new := y*newWidth + x
			newMap[i_new] = c.input[i_old]
		}
	}

	// then, we can construct the first row -- the width is conveniently the number of tiles
	for t := 1; t < tiles_w; t++ { // for each tile in the horizontal plane

		for y := 0; y < c.height; y++ {
			for x := 0; x < c.width; x++ {
				off := (t - 1) * c.width

				// get the old value and incremement
				i_old := y*newWidth + x + off
				value := newMap[i_old] + 1
				if value > 9 {
					value = 1
				}

				// get the new index and insert
				i_new := y*newWidth + x + (t * c.width)
				newMap[i_new] = value
			}
		}
	}

	// then, we can construct the remaining rows
	for t_y := 1; t_y < tiles_h; t_y++ {
		for t_x := 0; t_x < tiles_w; t_x++ {

			// construct the tile using offsets
			for y := 0; y < c.height; y++ {
				for x := 0; x < c.width; x++ {

					// the y line to read is a tile above so
					// t_y - 1 is the title, then add y for the row we need, then multiply by new width
					old_row := ((t_y-1)*c.height + y) * newWidth
					col := t_x*c.width + x

					// get the old value is c.height rows above
					i_old := old_row + col
					value := newMap[i_old] + 1
					if value > 9 {
						value = 1
					}

					// get the new index and insert
					// the actual row is then t_y * c.height + y
					new_row := (t_y*c.height + y) * newWidth
					i_new := new_row + col
					newMap[i_new] = value
				}
			}

		}
	}

	return newMap
}

func (c *Challenge15) SolvePartTwo() string {
	grid := c.createLargeMap()

	sum := 0
	path := c.aStar(grid, c.width*5, c.height*5)
	for _, e := range path {
		sum += grid[e]
	}

	return fmt.Sprintf("%d", sum)
}
