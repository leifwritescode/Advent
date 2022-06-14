package challenges

import (
	"fmt"
	"io/ioutil"
	"sort"
	"strings"

	"github.com/ahmetb/go-linq/v3"
	"github.com/championofgoats/advent-of-gode/challenges"
)

type inputOutputPair struct {
	inputs  []string
	outputs []string
}

type Challenge08 struct {
	challenges.BaseChallenge
	input []inputOutputPair
}

type sortableRuneArray []rune

func (s sortableRuneArray) Less(i, j int) bool {
	return s[i] < s[j]
}

func (s sortableRuneArray) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func (s sortableRuneArray) Len() int {
	return len(s)
}

func sortString(s string) string {
	r := []rune(s)
	sort.Sort(sortableRuneArray(r))
	return string(r)
}

func (challenge *Challenge08) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		lines := strings.Split(str, "\n")
		inputs := make([]inputOutputPair, 0)
		for i := 0; i < len(lines); i++ {
			in_out := strings.Split(lines[i], " | ")

			// sort the inputs
			in := strings.Split(in_out[0], " ")
			for j := 0; j < len(in); j++ {
				str := in[j]
				in[j] = sortString(str)
			}

			// sort the outputs
			out := strings.Split(in_out[1], " ")
			for j := 0; j < len(out); j++ {
				str := out[j]
				out[j] = sortString(str)
			}

			// create the input structure
			inputs = append(inputs, inputOutputPair{
				inputs:  in,
				outputs: out,
			})
		}
		challenge.input = inputs
	}
	return err
}

func (challenge *Challenge08) SolvePartOne() string {
	// unique displays are 1 (2 segs), 4 (4 segs), 7 (3 segs) and 8 (7 segs)
	compare_query := linq.From([]int{2, 3, 4, 7})

	// just count instances of these values
	result := linq.From(challenge.input).SelectManyT(func(iop inputOutputPair) linq.Query {
		return linq.From(iop.outputs)
	}).CountWithT(func(str string) bool {
		segs := len(str)
		return compare_query.Contains(segs)
	})

	return fmt.Sprintf("%d", result)
}

// determine if a contains the characters in b
// this does not care about the characters appearing sequentially -- just that they appear at all
func stringContains(a, b string) bool {
	chars := strings.Split(b, "")
	for i := 0; i < len(chars); i++ {
		if !strings.Contains(a, chars[i]) {
			return false
		}
	}
	return true
}

// return the single value in values that matches predicate
// panics if there are multiple matches
func singleWhere(values []string, predicate func(str string) bool) string {
	result := allWhere(values, predicate)
	if len(result) > 1 {
		panic("more than one value matched predicate")
	}
	return result[0]
}

// returns all values in values that match predicate
func allWhere(values []string, predicate func(str string) bool) []string {
	result := make([]string, 0)
	for _, v := range values {
		if predicate(v) {
			result = append(result, v)
		}
	}
	return result
}

// given an input of signal sets, return an array of signal sets indexed by the digit they represent
func deduceEntry(input []string) []string {
	// prepare the output
	output := make([]string, 10)

	// we already know 1, 4, 7 and 8 are length 2, 4, 3 and 7 respectively
	output[1] = singleWhere(input, func(s string) bool { return len(s) == 2 })
	output[4] = singleWhere(input, func(s string) bool { return len(s) == 4 })
	output[7] = singleWhere(input, func(s string) bool { return len(s) == 3 })
	output[8] = singleWhere(input, func(s string) bool { return len(s) == 7 })

	// we know that 0, 6 and 9 are all length 6
	// and that 9 includes 7, 1, 4 and 5
	// and that 0 is not 9, but includes 7 and 1
	// and that six includes neither 7, 1 nor 4
	// therefore 9 includes 4, 0 is not 9 and includes 1, and 6 is neither 9 nor 0.
	length_six := allWhere(input, func(s string) bool { return len(s) == 6 })
	output[9] = singleWhere(length_six, func(s string) bool { return stringContains(s, output[4]) })
	output[0] = singleWhere(length_six, func(s string) bool { return s != output[9] && stringContains(s, output[1]) })
	output[6] = singleWhere(length_six, func(s string) bool { return s != output[9] && s != output[0] })

	// we know that 2, 3 and 5 are all length 5
	// and that 3 includes 7 and 1
	// and that 5 is contained by 9, but includes neither 7 nor 1
	// and that 2 includes no other number
	// therefore 3 includes 7 and 1, 5 is included by 9 but does not contain 1, and 2 is neither 3 nor 5.
	length_five := allWhere(input, func(s string) bool { return len(s) == 5 })
	output[3] = singleWhere(length_five, func(s string) bool { return stringContains(s, output[7]) && stringContains(s, output[1]) })
	output[5] = singleWhere(length_five, func(s string) bool { return stringContains(output[9], s) && !stringContains(s, output[1]) })
	output[2] = singleWhere(length_five, func(s string) bool { return s != output[3] && s != output[5] })

	return output
}

// find the first appearance of str in arr
func indexOf(str string, arr []string) int {
	for k, v := range arr {
		if str == v {
			return k
		}
	}
	return -1
}

func solveEntry(input inputOutputPair) int {
	digits := deduceEntry(input.inputs)

	// find the outputs in the digits
	output := make([]int, 4)
	for i := 0; i < 4; i++ {
		output[i] = indexOf(input.outputs[i], digits)
	}

	// then reconstruct the number
	return (output[0] * 1000) + (output[1] * 100) + (output[2] * 10) + output[3]
}

func (challenge *Challenge08) SolvePartTwo() string {
	sum := 0

	num := len(challenge.input)
	for i := 0; i < num; i++ {
		sum += solveEntry(challenge.input[i])
	}

	return fmt.Sprintf("%d", sum)
}
