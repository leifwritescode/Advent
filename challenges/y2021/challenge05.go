package challenges

import (
	"errors"
	"fmt"
	"io/ioutil"
	"log"
	"math"
	"strconv"
	"strings"

	"github.com/ahmetb/go-linq/v3"
	"github.com/championofgoats/advent-of-gode/challenges"
	cmath "github.com/championofgoats/advent-of-gode/common/math"
)

type lineSegment struct {
	p1 cmath.Point
	p2 cmath.Point
}

type Challenge05 struct {
	challenges.BaseChallenge
	input []lineSegment
}

// this particular example initialises a simple integer array
func (challenge *Challenge05) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		sanitised := strings.Split(str, "\n")

		input := make([]lineSegment, 0)
		for _, line := range sanitised {
			// each line is in format point -> point
			points := strings.Split(line, " -> ")

			// each point in standard notation
			p1 := strings.Split(points[0], ",")
			p2 := strings.Split(points[1], ",")

			// extract the values
			p1x, _ := strconv.Atoi(p1[0])
			p1y, _ := strconv.Atoi(p1[1])
			p2x, _ := strconv.Atoi(p2[0])
			p2y, _ := strconv.Atoi(p2[1])

			// construct line segment and append
			segment := lineSegment{
				p1: cmath.Point{
					X: p1x,
					Y: p1y,
				},
				p2: cmath.Point{
					X: p2x,
					Y: p2y,
				},
			}
			input = append(input, segment)
		}
		challenge.input = input
	}
	return err
}

// Returns all points on an edge
// If the line segment isn't hor/ver then ignore
func edge(line lineSegment) ([]cmath.Point, error) {
	points := make([]cmath.Point, 0)

	// bail if not horizontal or vertical
	if line.p1.X != line.p2.X && line.p1.Y != line.p2.Y {
		return points, errors.New("Segment is not a horizontal or vertical line.")
	}

	// make sure p1 is less than p2
	if line.p1.X > line.p2.X {
		line.p1.X, line.p2.X = line.p2.X, line.p1.X
	}

	// make sure p1 is less than p2
	if line.p1.Y > line.p2.Y {
		line.p1.Y, line.p2.Y = line.p2.Y, line.p1.Y
	}

	for y := line.p1.Y; y <= line.p2.Y; y++ {
		for x := line.p1.X; x <= line.p2.X; x++ {
			points = append(points, cmath.Point{X: x, Y: y})
		}
	}

	return points, nil
}

// Determines if a point exists on the line
func pointOnLine(line lineSegment, p cmath.Point) bool {
	x := (float32(p.X) - float32(line.p1.X)) / (float32(line.p1.X) - float32(line.p2.X))
	y := (float32(p.Y) - float32(line.p1.Y)) / (float32(line.p1.Y) - float32(line.p2.Y))
	return x == y
}

// Returns all points on an edge
// If the line segment isn't hor/ver then ignore
func edge_diag(line lineSegment) ([]cmath.Point, error) {
	points := make([]cmath.Point, 0)

	// find distance on each axis
	abs_px := int(math.Abs(float64(line.p1.X - line.p2.X)))
	abs_py := int(math.Abs(float64(line.p1.Y - line.p2.Y)))

	// don't process a line that isn't diagonal
	if abs_px != abs_py {
		return points, errors.New("Segment is not a diagonal line")
	}

	// we know here that abs_px and abs_py are the same, so they both represent the max
	// find the minimum point on each axis
	min_x := int(math.Min(float64(line.p1.X), float64(line.p2.X)))
	min_y := int(math.Min(float64(line.p1.Y), float64(line.p2.Y)))

	// iterate from those minimums by the distance
	for x := min_x; x <= min_x+abs_px; x++ {
		for y := min_y; y <= min_y+abs_py; y++ {
			p := cmath.Point{X: x, Y: y}
			if pointOnLine(line, p) {
				points = append(points, p)
			}
		}
	}

	return points, nil
}

// Finds the extents of a set of coordinates, assuming the origin is at (0,0)
func extents(p map[cmath.Point]int) cmath.Point {
	e := cmath.Point{}
	for i := range p {
		t := i
		if t.X > e.X {
			e.X = t.X
		}
		if t.Y > e.Y {
			e.Y = t.Y
		}
	}
	return e
}

// Prints a visualisation of a map
func print_vis(occupancy map[cmath.Point]int) {
	e := extents(occupancy)
	for y := 0; y <= e.Y; y++ {
		str := ""
		for x := 0; x <= e.X; x++ {
			p := cmath.Point{Y: y, X: x}
			if v, ok := occupancy[p]; ok {
				str = fmt.Sprintf("%s%d", str, v)
			} else {
				str = fmt.Sprintf("%s.", str)
			}
		}
		log.Println(str)
	}
}

func (challenge *Challenge05) SolvePartOne() string {
	occupancy := linq.From(challenge.input).SelectManyT(func(ls lineSegment) linq.Query {
		points, _ := edge(ls)
		return linq.From(points)
	}).GroupByT(func(p cmath.Point) cmath.Point { return p },
		func(p cmath.Point) cmath.Point { return p },
	).SelectT(func(g linq.Group) int {
		return linq.From(g.Group).Count()
	}).CountWithT(func(i int) bool {
		return i > 1
	})

	return fmt.Sprintf("%d", occupancy)
}

func (challenge *Challenge05) SolvePartTwo() string {
	occupancy := linq.From(challenge.input).SelectManyT(func(ls lineSegment) linq.Query {
		points, _ := edge(ls)
		points2, _ := edge_diag(ls)
		return linq.From(append(points2, points...))
	}).GroupByT(func(p cmath.Point) cmath.Point { return p },
		func(p cmath.Point) cmath.Point { return p },
	).SelectT(func(g linq.Group) int {
		return linq.From(g.Group).Count()
	}).CountWithT(func(i int) bool {
		return i > 1
	})

	return fmt.Sprintf("%d", occupancy)
}
