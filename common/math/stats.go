package math

import (
	"github.com/ahmetb/go-linq/v3"
)

func Median(values []int) int {
	nums := len(values)
	half := nums / 2

	var sorted []int
	linq.From(values).OrderByT(func(v int) int { return v }).ToSlice(&sorted)

	if nums%2 == 0 {
		return (sorted[half] + sorted[half-1]) / 2
	} else {
		return sorted[half]
	}
}

func Mean(values []int) float64 {
	return linq.From(values).SelectT(func(v int) float64 { return float64(v) }).SumFloats() / float64(len(values))
}

func Min(a, b int64) int64 {
	r := a
	if a > b {
		r = b
	}
	return r
}

// see https://en.wikipedia.org/wiki/Gauss_sum
func GauseSum(v int) int {
	return (v * (v + 1)) / 2
}
