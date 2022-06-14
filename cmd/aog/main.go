package main

import (
	"fmt"
	"log"

	impl "github.com/championofgoats/advent-of-gode/challenges"
	"github.com/championofgoats/advent-of-gode/challenges/y2021"
	svc "github.com/golobby/container/v3"
	"github.com/pborman/getopt/v2"
)

var (
	showHelp bool
	year     uint = 2021
	day      uint = 1
)

func init() {
	getopt.FlagLong(&showHelp, "help", 'h', "display help")
	getopt.FlagLong(&year, "year", 'y', "the year from which to run challenges")
	getopt.FlagLong(&day, "day", 'd', "the challenge to run")

	svc.NamedTransient("y2021d01", func() impl.BaseChallenge {
		return &y2021.Challenge01{}
	})
	svc.NamedTransient("y2021d02", func() impl.BaseChallenge {
		return &y2021.Challenge02{}
	})
}

func main() {
	getopt.Parse()

	if showHelp {
		getopt.Usage()
		return
	}

	var challenge impl.BaseChallenge
	id := fmt.Sprintf("y%dd%02d", year, day)
	if err := svc.NamedResolve(&challenge, id); err != nil {
		str_err := fmt.Sprintf("no challenge found for day %02d of %d", day, year)
		log.Fatalln(str_err)
	}

	file_path := fmt.Sprintf("data/y%d/challenge%02d.in", year, day)
	if err := challenge.Initialise(file_path); err != nil {
		log.Fatalln(err)
	} else {
		str_inf := fmt.Sprintf("Executing challenge %02d of year %d", day, year)
		log.Println(str_inf)

		str_inf = fmt.Sprintf("part 1 = %s", challenge.SolvePartOne())
		log.Println(str_inf)

		str_inf = fmt.Sprintf("part 2 = %s", challenge.SolvePartTwo())
		log.Println(str_inf)
	}
}
