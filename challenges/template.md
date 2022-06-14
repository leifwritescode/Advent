## Challenge template

```
package y2021

import (
	"fmt"
	"io/ioutil"
	"strings"

	utils "github.com/championofgoats/advent-of-gode/utilities"
	"github.com/championofgoats/advent-of-gode/challenges"
)

type Challenge00 struct {
	challenges.BaseChallenge
	input []int
}

// this particular example initialises a simple integer array
func (challenge *Challenge00) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		sanitised := strings.ReplaceAll(str, "\n", ",")
		json := fmt.Sprintf("[%s]", sanitised)
		challenge.input = utils.MakeArray(json)
	}
	return err
}

func (challenge *Challenge00) SolvePartOne() string {
	return "not implemented"
}

func (challenge *Challenge00) SolvePartTwo() string {
	return "not implemented"
}

```

In `cmd\aog\main.go`, in `init()`, add the following line (setting AA and BB as appropriate):

```
	svc.NamedTransient("yAAAAdBB", func() impl.BaseChallenge {
		return &yAAAA.ChallengeBB{}
	})
```
