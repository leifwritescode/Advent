package aocd

import (
	internal "github.com/championofgoats/aocd/pkg/aocd"
)

// Create a new AdventOfCodeData using the input for challenge year and day
// If the input has previously been fetched then it will be read from file
func New(year int, day int) (*internal.AdventofCodeData, error) {
	return internal.New(year, day)
}
