from utilities import read_input, timed
from itertools import groupby
import re


def prepare_input():
    lines = read_input()

    systems = []
    for key, group in groupby(lines, lambda x: x != ''):
        if not key:
            continue

        equation = list(group)
        a = re.search(r'X\+(\d+), Y\+(\d+)', equation[0])
        b = re.search(r'X\+(\d+), Y\+(\d+)', equation[1])
        p = re.search(r'X=(\d+), Y=(\d+)', equation[2])

        systems.append([(int(a.group(1)), int(a.group(2))), (int(b.group(1)), int(b.group(2))), (int(p.group(1)), int(p.group(2)))])

    return systems


def determinant(a, b):
    return a[0] * b[1] - a[1] * b[0]


def solve(a, b, p, o):
    p = (p[0] + o, p[1] + o)
    det = determinant(a, b)
    i, j = (p[0] * b[1] - p[1] * b[0]), (a[0] * p[1] - a[1] * p[0])

    if det == 0 or i % det != 0 or j % det != 0:
        return 0

    A, B = i / det, j / det
    return int(A * 3 + B)


def part_one(systems):
    return sum([solve(a, b, p, 0) for a, b, p in systems])


def part_two(systems):
    return sum([solve(a, b, p, 10000000000000) for a, b, p in systems])


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
