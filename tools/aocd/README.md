# Advent of Code Data (AOCD)
 A handy utility for automating fetch and submission of tasks.
## Get Me
`go get github.com/championofgoats/aocd`
## Import Me
`import "github.com/championofgoats/aocd"`
## Use Me
Obtain your session token from `adventofcode.com` and set it on the environment variable `AOC_TOKEN`. Then, the following snippet demonstrates how you can use AOCD.
```
package main

import (
	"fmt"

	"github.com/championofgoats/aocd"
)

func main() {
    // initialise aocd
    // this will fetch the input for 2021 day 1
	data, err := aocd.New(2021, 1)
	if err != nil {
		panic(err)
	}

    // get the current year in use by aocd
    // data.GetYear()

    // get the current day in use by aocd
    // data.GetDay()

    // get the current input in use by aocd
    // data.GetInput()

    // submit an answer
    // use aocd.LEVEL_SECOND if submitting second stage
	response, err := data.Submit(aocd.LEVEL_FIRST, "some_answer_here")
    if err != nil {
		panic(err)
	}

    fmt.Println(response)
}
```
Please be considerate: Don't spam `adventofcode.com` with submit requests. Doing so may get your token permanently barred.