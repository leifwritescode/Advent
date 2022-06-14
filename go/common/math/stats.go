package math

import (
	"github.com/ahmetb/go-linq/v3"
)

func Abs(n int) int {
	r := n
	if r < 0 {
		r *= -1
	}
	return r
}

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

func Min32(a, b int) int {
	r := a
	if a > b {
		r = b
	}
	return r
}

func Max32(a, b int) int {
	r := a
	if a < b {
		r = b
	}
	return r
}

func Max(a, b int64) int64 {
	r := a
	if a < b {
		r = b
	}
	return r
}

func Clamp(v, l, h int) int {
	return Min32(h, Max32(v, l))
}
