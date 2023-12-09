package challenges

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"strings"

	"github.com/Dadido3/blackcl"
	"github.com/championofgoats/advent-of-gode/challenges"
	utils "github.com/championofgoats/advent-of-gode/utilities"
)

type Challenge09_OpenCL struct {
	challenges.BaseChallenge
	input         []float32
	lava_tube_map []float32
	width         float32
	height        float32
	opencl_kernel string
}

// Creates an integer array from a string containing a properly formed JSON array.
func (c *Challenge09_OpenCL) MakeOpenClCompatArray(str string) []float32 {
	var result []float32
	err := json.Unmarshal([]byte(str), &result)
	utils.Guard(err)
	return result
}

func (c *Challenge09_OpenCL) Initialise(file_path string) error {
	bytes, err := ioutil.ReadFile(file_path)
	if err == nil {
		str := string(bytes)
		temp := strings.Split(str, "\n")
		sanitised := strings.ReplaceAll(str, "\n", "")
		sanitised = strings.Join(strings.Split(sanitised, ""), ",")
		json := fmt.Sprintf("[%s]", sanitised)

		c.width = float32(len(temp[0]))
		c.height = float32(len(temp))
		c.input = c.MakeOpenClCompatArray(json)
	}

	// this special version of the solution requires a C kernel
	bytes, err = ioutil.ReadFile(utils.RootDir("challenges/y2021/challenge09_opencl.kernel"))
	if err == nil {
		str := string(bytes)
		c.opencl_kernel = str
	}

	return err
}

// returns all values in values that match predicate
func (c *Challenge09_OpenCL) allWhere(values []float32, predicate func(p1 int, p2 float32) bool) []int {
	result := make([]int, 0)
	for k, v := range values {
		if predicate(k, v) {
			result = append(result, k)
		}
	}
	return result
}

// the actual
func (c *Challenge09_OpenCL) doPartOneOpenCL() {
	// the kernel size
	size := c.width * c.height

	// get the gpus
	log.Print("Searching for OpenCL capable devices...\n\n")
	devices, err := blackcl.GetDevices(blackcl.DeviceTypeGPU)
	if err != nil {
		panic("no opencl device")
	}

	// pick the first, arbitrarily
	d := devices[0]
	for i := 0; i < len(devices); i++ {
		log.Printf("Found %s (%s)\n\n", devices[i].Name(), devices[i].Vendor())
		defer devices[i].Release()
	}
	log.Printf("Using %s (%s)\n\n", d.Name(), d.Vendor())

	// allocate input buffer on the device
	v_in, err := d.NewVector(int(size))
	if err != nil {
		panic("could not allocate input buffer")
	}
	defer v_in.Release()

	//copy data to the vector
	err = <-v_in.Copy(c.input)
	if err != nil {
		panic("could not copy data to buffer")
	}

	// allocate output buffer on the device
	v_out, err := d.NewVector(int(size))
	if err != nil {
		panic("could not allocate output buffer")
	}
	defer v_out.Release()

	d.AddProgram(c.opencl_kernel)
	k := d.Kernel("compute_map")

	//run kernel (global work size size and local work size 1)
	_, err = k.Global(int(size)).Local(1).Run(false, nil, v_in, v_out, c.width, size)
	if err != nil {
		panic("could not run kernel")
	}

	// get the resulting indexes out
	c.lava_tube_map, err = v_out.Data()
	if err != nil {
		panic("could not get data from buffer")
	}
}

func (c *Challenge09_OpenCL) SolvePartOne() string {
	// At about 3.30am, Friday 10th December, something occurred to me about this challenge.
	//
	// We need to know just two things in order to determine where a given node flows to: Its height, and the heights of all surrounding nodes.
	// Given the 1D heightmap, we can get all of these data from the coordinates alone.
	// As a result, each node is calculable independently of all others.
	// Therefore, the problem is massively parallel for an arbitrarily sized heightmap
	//
	// OpenCL enter stage left
	//
	// Of course, this means we need to adjust how we do things -- point structures are out.
	// We have to use a straight float array, which means coded indices and coded values.

	c.doPartOneOpenCL()

	// count the basins and compute total risk
	basins := c.allWhere(c.lava_tube_map, func(p1 int, p2 float32) bool { return p1 == int(p2) })
	total_risk := 0
	for i := 0; i < len(basins); i++ {
		p := basins[i]
		total_risk += 1 + int(c.input[p])
	}
	return fmt.Sprintf("%d", total_risk)
}

func (c *Challenge09_OpenCL) SolvePartTwo() string {
	return "I'm not implemented for this special version of challenge 09."
}
