package aocd

import (
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"io/ioutil"
	"net/http"
	"os"
	"regexp"
	"strings"
)

var (
	token = os.Getenv("AOC_TOKEN")
)

const (
	CORRECT   = "CORRECT"
	INCORRECT = "INCORRECT"

	LEVEL_FIRST  = 1
	LEVEL_SECOND = 2
)

type AdventofCodeData struct {
	year        int
	day         int
	input       string
	submissions map[string]string
}

// Encodes the appropriate file path for this user and challenge
func getFilePath(token string, year int, day int) string {
	return fmt.Sprintf("./%s-%d-%d.aocd", token, year, day)
}

// Encodes an AdventOfCodeData struct into json bytes
func encodeStruct(data AdventofCodeData) []byte {
	// define an anonymous struct matching the real one and populate
	thing := struct {
		Year        int
		Day         int
		Input       string
		Submissions map[string]string
	}{
		Year:        data.year,
		Day:         data.day,
		Input:       data.input,
		Submissions: data.submissions,
	}

	// marshal it down to json bytes
	bytes, err := json.Marshal(thing)
	if err != nil {
		panic(err)
	}

	return bytes
}

// Decodes an AdventOfCodeData struct from json bytes
func decodeStruct(bytes []byte) *AdventofCodeData {
	// define an anonymous struct matching the real one
	thing := struct {
		Year        int
		Day         int
		Input       string
		Submissions map[string]string
	}{}

	// unmarshal the given bytes into it
	if err := json.Unmarshal(bytes, &thing); err != nil {
		panic(err)
	}

	// transpose the anonymous struct contents to a real struct
	return &AdventofCodeData{
		year:        thing.Year,
		day:         thing.Day,
		input:       thing.Input,
		submissions: thing.Submissions,
	}
}

// fetch a fresh copy of the input for a given year and day
func fetchFromServer(year int, day int, file_path string) (*AdventofCodeData, error) {
	// ex: https://adventofcode.com/2021/day/1/input
	url := fmt.Sprintf("https://adventofcode.com/%d/day/%d/input", year, day)

	// news up an http client and passes back the pointer
	client := &http.Client{}

	// news up a request object
	request, err := http.NewRequest("GET", url, nil)
	if err != nil {
		return nil, err
	}

	// sets the cookie header on the request to our session token
	cookie := fmt.Sprintf("session=%s", token)
	request.Header.Set("Cookie", cookie)

	// actions the request
	response, err := client.Do(request)
	if err != nil {
		return nil, err
	}

	// closes the response body after we finish executing the function
	defer response.Body.Close()

	// if a non 200 OK status is received then that's a failure
	if response.StatusCode != 200 {
		return nil, errors.New("failed to fetch a fresh input")
	}

	// reads the response body bytes into a variable
	bytes, err := io.ReadAll(response.Body)
	if err != nil {
		return nil, err
	}

	// convert the response bytes into a string and create the AdventOfCodeData structure
	input := string(bytes)
	aocd := &AdventofCodeData{
		year:        year,
		day:         day,
		input:       input,
		submissions: make(map[string]string),
	}

	// encode it down
	bytes = encodeStruct(*aocd)

	// and then write the resulting bytes to file
	if err := ioutil.WriteFile(file_path, bytes, 0664); err != nil {
		return nil, err
	}

	// all being well, return the stuff we pulled
	return aocd, nil
}

func readFromFile(file_path string) (*AdventofCodeData, error) {
	// the file exists, so begin by reading out the bytes
	bytes, err := ioutil.ReadFile(file_path)
	if err != nil {
		return nil, err
	}

	// decode and hand it back to the caller
	result := decodeStruct(bytes)
	return result, err
}

func New(year int, day int) (*AdventofCodeData, error) {
	file_path := getFilePath(token, year, day)
	if _, err := os.Stat(file_path); err != nil {
		return fetchFromServer(year, day, file_path)
	} else {
		return readFromFile(file_path)
	}
}

func submit_impl(aocd *AdventofCodeData, level int, answer string) (string, error) {
	// first check to see if we've submitted this answer before
	key := fmt.Sprintf("%d:%s", level, answer)
	if val, ok := aocd.submissions[key]; ok {
		str_err := fmt.Sprintf("You've already submitted that answer for that level. The response was %s.", val)
		return val, errors.New(str_err)
	}

	// ex: https://adventofcode.com/2021/day/1/answer
	url := fmt.Sprintf("https://adventofcode.com/%d/day/%d/answer", aocd.year, aocd.day)

	// need to encode the payload especially
	payload := fmt.Sprintf("level=%d&answer=%s", level, answer)

	// news up an http client and passes back the pointer
	client := &http.Client{}

	// news up a request object
	request, err := http.NewRequest("POST", url, strings.NewReader(payload))
	if err != nil {
		return "", err
	}

	// sets the cookie header on the request to our session token
	// additionally configures the content headers
	cookie := fmt.Sprintf("session=%s", token)
	request.Header.Set("Cookie", cookie)
	request.Header.Set("Content-Type", "application/x-www-form-urlencoded")
	request.Header.Set("Content-Length", fmt.Sprintf("%d", len(payload)))

	// actions the request
	response, err := client.Do(request)
	if err != nil {
		return "", err
	}

	// closes the response body after we finish executing the function
	defer response.Body.Close()

	// if a non 200 OK status is received then that's a failure
	if response.StatusCode != 200 {
		return "", errors.New("failed to push the submission")
	}

	// reads the response body bytes into a variable
	bytes, err := io.ReadAll(response.Body)
	if err != nil {
		return "", err
	}

	// read out the body
	body := string(bytes)

	// check the response for success or failure
	matched, err := regexp.MatchString("That's the right answer!", body)
	if err != nil {
		return "", err
	}

	// once we've done that we can append the result to the submissions
	var result string
	if matched {
		result = CORRECT
	} else {
		result = INCORRECT
	}
	aocd.submissions[key] = result

	// generate the file name
	file_path := getFilePath(token, aocd.year, aocd.day)

	// encode it down
	bytes = encodeStruct(*aocd)

	// and then write the resulting bytes to file
	if err := ioutil.WriteFile(file_path, bytes, 0664); err != nil {
		return "", err
	}

	return result, nil
}

/* api surface */

// Gets the (personalised) challenge input from this AdventOfCodeData struct instance
func (s AdventofCodeData) GetInput() string {
	return s.input
}

// Gets the challenge year from this AdventOfCodeData struct instance
func (s AdventofCodeData) GetYear() int {
	return s.year
}

// Gets the challenge day from this AdventOfCodeData struct instance
func (s AdventofCodeData) GetDay() int {
	return s.day
}

// Submit an answer to the server
func (s *AdventofCodeData) Submit(level int, answer string) (string, error) {
	return submit_impl(s, level, answer)
}
