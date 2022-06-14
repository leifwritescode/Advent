package y2021

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
)

type Challenge03 struct {
	challenges.BaseChallenge
	input []int
	width int
}

// this particular example initialises a simple integer array
func (challenge *Challenge03) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		lines := strings.Split(str, "\n")
		challenge.input = make([]int, len(lines))
		challenge.width = len(lines[0])
		for i := 0; i < len(lines); i++ {
			b, _ := strconv.ParseInt(lines[i], 2, 32)
			challenge.input[i] = int(b)
		}
	}
	return err
}

// determine which bits are most common
// sort-of: common_bits contains the number of ones.
// the "common bit" is then determined by bit > len(input) / 2
func computeOnes(s []int, w int) []int {
	c := make([]int, w)
	o := w - 1
	for i := 0; i < len(s); i++ {
		d := s[i]
		for j := o; j >= 0; j-- {
			b := (d >> j) & 0x1
			c[(j*-1)+o] += b
		}
	}
	return c
}

func (challenge *Challenge03) SolvePartOne() string {
	gamma := 0
	epsilon := 0
	offset := challenge.width - 1
	ones := computeOnes(challenge.input, challenge.width)
	half := int(len(challenge.input) / 2)

	for i := 0; i < challenge.width; i++ {
		// high low is 1 (high) if 1 was common or 0 (low) if it was not
		high_low := ones[i] > half
		if high_low {
			gamma |= 1 << (offset - i)
		} else {
			epsilon |= 1 << (offset - i)
		}
	}

	return fmt.Sprintf("%d", gamma*epsilon)
}

// clumsy repical of ?: operator
func ternary(c bool, t int, f int) int {
	var r = f
	if c {
		r = t
	}
	return r
}

func (challenge *Challenge03) SolvePartTwo() string {
	offset := challenge.width - 1
	t_oxy := challenge.input
	t_cbn := challenge.input

	// compute oxy rating
	for i := offset; i >= 0 && len(t_oxy) > 1; i-- {
		ones := computeOnes(t_oxy, challenge.width)
		half := (len(t_oxy) + 1) / 2
		commonBit := ternary(ones[(i*-1)+offset] >= half, 1, 0)

		temp := make([]int, 0)

		for j := 0; j < len(t_oxy); j++ {
			if commonBit == (t_oxy[j]>>i)&0x1 {
				temp = append(temp, t_oxy[j])
			}
		}

		t_oxy = temp
	}

	// then do carbon
	for i := offset; i >= 0 && len(t_cbn) > 1; i-- {
		ones := computeOnes(t_cbn, challenge.width)
		half := (len(t_cbn) + 1) / 2
		leastCommonBit := ternary(ones[(i*-1)+offset] >= half, 0, 1)
		temp := make([]int, 0)

		for j := 0; j < len(t_cbn); j++ {
			if leastCommonBit == (t_cbn[j]>>i)&0x1 {
				temp = append(temp, t_cbn[j])
			}
		}

		t_cbn = temp
	}

	return fmt.Sprintf("%d", t_oxy[0]*t_cbn[0])
}
