package challenges

import (
	"fmt"
	"io/ioutil"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge01 struct {
	challenges.BaseChallenge
	input []int
}

func solveDay1(input []int, offset int) string {
	descents := 0

	for i := offset; i < len(input); i++ {
		prev := input[i-offset]
		next := input[i]
		if next > prev {
			descents++
		}
	}

	return fmt.Sprintf("%d", descents)
}

func (challenge *Challenge01) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		sanitised := strings.ReplaceAll(str, "\n", ",")
		json := fmt.Sprintf("[%s]", sanitised)
		challenge.input = utils.MakeArray(json)
	}
	return err
}

func (challenge *Challenge01) SolvePartOne() string {
	return solveDay1(challenge.input, 1)
}

func (challenge *Challenge01) SolvePartTwo() string {
	return solveDay1(challenge.input, 3)
}
