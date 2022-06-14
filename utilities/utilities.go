package utilities

import (
	"encoding/json"
	"fmt"
	"os"
	"path"
	"path/filepath"
	"runtime"
)

func Guard(e error) {
	if e != nil {
		panic(e)
	}
}

// Creates an integer array from a string containing a properly formed JSON array.
func MakeArray(str string) []int {
	var result []int
	err := json.Unmarshal([]byte(str), &result)
	Guard(err)
	return result
}

// Returns a string representing file_path relative to the project root.
func RootDir(file_path string) string {
	_, b, _, _ := runtime.Caller(0)
	basepath := path.Join(path.Dir(b))
	r := fmt.Sprintf("%s%c%s",
		filepath.Dir(basepath),
		os.PathSeparator,
		filepath.FromSlash(file_path))
	return r
}
