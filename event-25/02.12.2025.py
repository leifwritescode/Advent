from utilities import read_input, timed
from math import log10, floor

def prepare_input():
    lines = read_input()

    nums = []

    # input is a comma-separated list of ranges
    # decompose into a list of all represented numbers
    ranges = lines[0].split(',')
    for r in ranges:
        a = r.split('-')
        b, c = int(a[0]), int(a[1])
        nums += list(range(b, c + 1))

    return nums


def bifurcate_and_test(i):
    """
    for a given natural integer i
    2k = floor( log10( i ) ) + 1
    return if 2k mod 2 = 1
    k = 2k / 2
    i_l = floor( |i| / 10^k )
    i_r = |i| mod 10^k
    return i_l = i_r
    """
    k = floor(log10(i))+1
    if (k % 2): return 0
    h_k = k // 2
    d = 10 ** h_k
    i_l = i // d
    i_r = i % d
    return i if i_l == i_r else 0

# lookup table for the set of
# values n satisfying 2 <= n <= d
# for some natural integer d satisfying d <= 10
# where d % n = 0
m_s = [
    [ ],
    [ ],
    [ 2 ],
    [ 3 ],
    [ 2, 4 ],
    [ 5 ],
    [ 2, 3, 6 ],
    [ 7 ],
    [ 2, 4, 8 ],
    [ 3, 9 ],
    [ 2, 5, 10 ]
]

def birfurcate_and_test_maximal(i):
    """
    for a given natural integer i
    d = floor( log10( i ) ) + 1
    m = set of all values n satisfying 2 <= n <= d where d % n = 0
    for each value m_i of m
    k = d / m_i
    b = floor( i / 10^k( m_i - 1) )
    if i = b dot (10^km - 1 / 10^k - 1)
    """
    d = floor(log10(i))+1
    m = m_s[d]
    for m_i in m:
        k = d // m_i
        b = i // (10 ** (k * (m_i - 1)))
        r = b * (10 ** (k * m_i) - 1) // ((10 ** k) - 1)
        if r == i: return i
    return 0


def part_one(input):
    return sum([bifurcate_and_test(i) for i in input])


def part_two(input):
    return sum([birfurcate_and_test_maximal(i) for i in input])


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
