package challenges

import (
	"fmt"
	"image"
	"image/color"
	"image/png"
	"io/ioutil"
	"os"
	"strconv"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
)

type Challenge13 struct {
	challenges.BaseChallenge
	input_dots  []common_math.Point
	input_folds []common_math.Point
}

// this particular example initialises a simple integer array
func (c *Challenge13) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		lines := strings.Split(str, "\n")

		// prep the input arrays
		c.input_dots = make([]common_math.Point, 0)
		c.input_folds = make([]common_math.Point, 0)

		// increment until we hit the blank
		line := lines[0]
		for line != "" {
			p := strings.Split(line, ",")
			x, _ := strconv.Atoi(p[0])
			y, _ := strconv.Atoi(p[1])
			c.input_dots = append(c.input_dots, common_math.Point{X: x, Y: y})

			lines = lines[1:]
			line = lines[0]
		}

		// then just go till we're empty!
		lines = lines[1:]
		for len(lines) > 0 {
			line = lines[0]

			// get the x y
			words := strings.Split(line, " ")
			change := strings.Split(words[2], "=")
			value, _ := strconv.Atoi(change[1])
			if change[0] == "x" {
				c.input_folds = append(c.input_folds, common_math.Point{X: value, Y: 0})
			} else {
				c.input_folds = append(c.input_folds, common_math.Point{X: 0, Y: value})
			}

			// then just go till we're empty!
			lines = lines[1:]
		}
	}
	return err
}

func (c *Challenge13) abs(a int) int {
	r := a
	if a < 0 {
		r *= -1
	}
	return r
}

func (c *Challenge13) foldLeft(grid []common_math.Point, x int) []common_math.Point {
	for i, p := range grid {
		// if pX exceeds x, then fold
		if p.X >= x {
			// each fold is p.x - abs(p.x - x)
			grid[i].X = x - c.abs(p.X-x)
		}
	}
	return grid
}

func (c *Challenge13) foldUp(grid []common_math.Point, y int) []common_math.Point {
	for i, p := range grid {
		// if pY exceeds Y, then fold
		if p.Y >= y {
			// each fold is p.x - abs(p.x - x)
			grid[i].Y = y - c.abs(p.Y-y)
		}
	}
	return grid
}

func (c *Challenge13) fold(grid []common_math.Point, fold common_math.Point) []common_math.Point {
	if fold.X == 0 {
		return c.foldUp(grid, fold.Y)
	} else {
		return c.foldLeft(grid, fold.X)
	}
}

func (c *Challenge13) extents(grid []common_math.Point) common_math.Point {
	point := common_math.Point{X: 0, Y: 0}
	for _, v := range grid {
		point.X = common_math.Max(point.X, v.X)
		point.Y = common_math.Max(point.Y, v.Y)
	}
	return point
}

func (c *Challenge13) counts(points []common_math.Point) map[common_math.Point]int {
	r := make(map[common_math.Point]int)
	for _, v := range points {
		if _, ok := r[v]; !ok {
			r[v] = 1
		} else {
			r[v] += 1
		}
	}
	return r
}

func (c *Challenge13) contains(grid []common_math.Point, x int, y int) bool {
	p := common_math.Point{X: x, Y: y}
	for _, v := range grid {
		if v.X == p.X && v.Y == p.Y {
			return true
		}
	}
	return false
}

func (c *Challenge13) SolvePartOne() string {
	fold := c.input_folds[0]
	grid := c.fold(c.input_dots, fold)
	count := c.counts(grid)
	return fmt.Sprintf("%d", len(count))
}

func (c *Challenge13) SolvePartTwo() string {
	grid := c.input_dots
	for _, fold := range c.input_folds {
		grid = c.fold(grid, fold)
	}

	// now it's done we need to do the real vis
	extents := c.extents(grid)
	extents.X += 1
	extents.Y += 1
	tl := image.Point{0, 0}
	br := image.Point{extents.X, extents.Y}
	img := image.NewRGBA(image.Rectangle{tl, br})
	for y := 0; y < extents.Y; y++ {
		for x := 0; x < extents.X; x++ {
			if c.contains(grid, x, y) {
				img.Set(x, y, color.Black)
			} else {
				img.Set(x, y, color.White)
			}
		}
	}

	// write the image
	f, _ := os.Create("EFJKZLBL.png")
	png.Encode(f, img)

	return "EFJKZLBL"
}
