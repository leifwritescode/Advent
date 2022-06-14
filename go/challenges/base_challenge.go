package challenges

type BaseChallenge interface {
	Initialise(string) error
	SolvePartOne() string
	SolvePartTwo() string
}
