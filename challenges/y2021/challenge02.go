package y2021

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
)

type challenge02Input struct {
	direction string
	distance  int
}

type Challenge02 struct {
	challenges.BaseChallenge
	input []challenge02Input
}

func (challenge *Challenge02) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		pairs := strings.Split(str, "\n")
		challenge.input = make([]challenge02Input, len(pairs))
		for i := 0; i < len(pairs); i++ {
			pair := strings.Split(pairs[i], " ")
			dist, _ := strconv.Atoi(pair[1])
			challenge.input = append(challenge.input, challenge02Input{
				direction: pair[0],
				distance:  dist,
			})
		}
	}
	return err
}

func (challenge *Challenge02) SolvePartOne() string {
	depth := 0
	distance := 0

	for i := 0; i < len(challenge.input); i++ {
		action := challenge.input[i]
		switch action.direction {
		case "forward":
			distance += action.distance
		case "down":
			depth += action.distance
		case "up":
			depth -= action.distance
		}
	}

	result := depth * distance
	return fmt.Sprintf("%d", result)
}

func (challenge *Challenge02) SolvePartTwo() string {
	depth := 0
	distance := 0
	aim := 0

	for i := 0; i < len(challenge.input); i++ {
		action := challenge.input[i]
		switch action.direction {
		case "forward":
			distance += action.distance
			depth += action.distance * aim
		case "down":
			aim += action.distance
		case "up":
			aim -= action.distance
		}
	}

	result := depth * distance
	return fmt.Sprintf("%d", result)
}
