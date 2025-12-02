from utilities import read_input, timed
from math import log10, floor, pow

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
    d = pow(10, h_k)
    i_l = floor(i // d)
    i_r = i % d
    return i if i_l == i_r else 0


def part_one(input):
    return sum([bifurcate_and_test(i) for i in input])


def part_two(input):
    return -1


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
