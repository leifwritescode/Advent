package challenges

import (
	"fmt"
	"io/ioutil"
	"math"

	"github.com/ahmetb/go-linq/v3"
	"github.com/championofgoats/advent-of-gode/challenges"
	common_math "github.com/championofgoats/advent-of-gode/common/math"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge07 struct {
	challenges.BaseChallenge
	input []int
}

// this particular example initialises a simple integer array
func (challenge *Challenge07) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		json := fmt.Sprintf("[%s]", str)
		challenge.input = utils.MakeArray(json)
	}
	return err
}

func (challenge *Challenge07) SolvePartOne() string {
	median := common_math.Median(challenge.input)

	// then the answer is the sum(abs(i - median(input)))
	fuel := linq.From(challenge.input).SelectT(func(v int) int {
		return int(math.Abs(float64(v - median)))
	}).SumInts()

	return fmt.Sprintf("%d", fuel)
}

func (challenge *Challenge07) SolvePartTwo() string {
	mean := common_math.Mean(challenge.input)
	upper := math.Ceil(mean)
	lower := math.Floor(mean)

	a := linq.From(challenge.input).SelectT(func(v int) int {
		f_v := float64(v)
		abs := math.Abs(upper - f_v)
		return common_math.GauseSum(int(abs))
	}).SumInts()
	b := linq.From(challenge.input).SelectT(func(v int) int {
		f_v := float64(v)
		abs := math.Abs(lower - f_v)
		return common_math.GauseSum(int(abs))
	}).SumInts()

	return fmt.Sprintf("%d", common_math.Min(a, b))
}
