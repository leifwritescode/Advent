package utilities

type Set struct {
	Values map[int]struct{}
}

func MakeSet() *Set {
	set := &Set{
		Values: make(map[int]struct{}),
	}
	return set
}

func (set *Set) Append(val int) {
	set.Values[val] = struct{}{}
}

func (set *Set) AppendRange(vals []int) {
	for _, val := range vals {
		set.Append(val)
	}
}

func (set *Set) Remove(val int) {
	delete(set.Values, val)
}

func (set *Set) Has(val int) bool {
	_, ok := set.Values[val]
	return ok
}

func (set *Set) Count() int {
	return len(set.Values)
}

func (set *Set) Intersection(rhs Set) *Set {
	intersection := MakeSet()

	lhs := *set
	if len(set.Values) > len(rhs.Values) {
		lhs, rhs = rhs, lhs
	}

	for key := range lhs.Values {
		if _, ok := rhs.Values[key]; ok {
			intersection.Values[key] = struct{}{}
		}
	}

	return intersection
}

func (set *Set) Equals(rhs Set) bool {
	if len(set.Values) != len(rhs.Values) || len(set.Values) == 0 || len(rhs.Values) == 0 {
		return false
	}

	for key := range rhs.Values {
		if _, ok := set.Values[key]; !ok {
			return false
		}
	}

	return true
}
