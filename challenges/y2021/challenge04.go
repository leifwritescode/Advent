package challenges

import (
	"fmt"
	"io/ioutil"
	"strconv"
	"strings"

	"github.com/championofgoats/advent-of-gode/challenges"
	"github.com/championofgoats/advent-of-gode/utilities"
)

const (
	dim = 5
)

type Challenge04 struct {
	challenges.BaseChallenge
	numbers []int
	boards  [][]int
}

// this particular example initialises a simple integer array
func (challenge *Challenge04) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		lines := strings.Split(str, "\n")

		// first line is the numbers called by the machine
		nums := fmt.Sprintf("[%s]", lines[0])
		challenge.numbers = utilities.MakeArray(nums)

		// discard the empty first line
		lines = lines[1:]

		// now we want to get the boards
		// the procedure for this is to loop for as long as there is content in the array
		for len(lines) > 0 {
			lines = lines[1:]

			// process the y values only (x is implicit)
			board := make([]int, 0)
			for i := 0; i < dim; i++ {
				// need to extract the line however spaces are fuckers
				// lol just try to parse them as integers and it'll error out
				// we can ignore that bc i'm a stinker lmfao
				// what's safety amirite?
				line := strings.Split(lines[i], " ")
				for j := 0; j < len(line); j++ {
					if num, err := strconv.Atoi(line[j]); err == nil {
						board = append(board, num)
					}
				}
			}

			// append to the processed inputs, and chop off it off the raw
			challenge.boards = append(challenge.boards, board)
			lines = lines[5:]
		}
	}
	return err
}

func (challenge *Challenge04) bingo(b *utilities.Set, board_index int) (int, bool) {
	// make the unique set of all values called
	board := challenge.boards[board_index]

	for y := 0; y < dim; y++ {
		// first check the horizontal, since it's easier
		a := utilities.MakeSet()
		o := y * dim
		a.AppendRange(board[o : o+5])

		intersect := a.Intersection(*b)
		if intersect.Equals(*a) {
			return board_index, true
		}

		// then the vertical
		a = utilities.MakeSet()
		o = y
		a.AppendRange([]int{board[o], board[o+dim], board[o+(dim*2)], board[o+(dim*3)], board[o+(dim*4)]})
		intersect = a.Intersection(*b)
		if intersect.Equals(*a) {
			return board_index, true
		}
	}

	return -1, false
}

func contains(arr map[int]struct{}, i int) bool {
	for k := range arr {
		if k == i {
			return true
		}
	}
	return false
}

func contains_i(arr []int, i int) bool {
	for _, v := range arr {
		if v == i {
			return true
		}
	}
	return false
}

func (challenge *Challenge04) SolvePartOne() string {
	// set off a goroutine for each board

	b := utilities.MakeSet()
	for i := 4; i < len(challenge.numbers); i++ {
		// create a set from the total numbers called to date -- start at five since that's the minimum
		b.AppendRange(challenge.numbers[:i])

		for j := 0; j < len(challenge.boards); j++ {
			if bi, ok := challenge.bingo(b, j); ok {

				// we've found the first winner!
				// we know that the number that caused the win was ...
				winning_num := challenge.numbers[i-1]
				sum := 0
				board := challenge.boards[bi]
				for k := 0; k < len(board); k++ {
					if !contains(b.Values, board[k]) {
						sum += board[k]
					}
				}

				return fmt.Sprintf("%d", sum*winning_num)
			}
		}
	}

	return "failed to find solution"
}

func (challenge *Challenge04) SolvePartTwo() string {
	// we need a new map of boards so we can track which ones have one.
	// we'll just track the INDEX though
	indicies := make([]int, 0)
	boards := len(challenge.boards)
	b := utilities.MakeSet()
	var i int
	for i = 4; len(indicies) < boards && i < len(challenge.numbers); i++ {
		// create a set from the total numbers called to date -- start at five since that's the minimum
		b.AppendRange(challenge.numbers[:i])

		for j := 0; j < boards; j++ {
			if bi, ok := challenge.bingo(b, j); ok {
				if !contains_i(indicies, bi) {
					indicies = append(indicies, bi)
				}
			}
		}
	}

	// we've found all of the winners, at this stage
	// todo i'm unclear why i need to go back two indicies here but an investigation for another time
	winning_num := challenge.numbers[i-2]
	sum := 0
	winning_board_id := indicies[len(indicies)-1]
	board := challenge.boards[winning_board_id]
	for k := 0; k < len(board); k++ {
		if !contains(b.Values, board[k]) {
			sum += board[k]
		}
	}

	return fmt.Sprintf("%d", sum*winning_num)
}
