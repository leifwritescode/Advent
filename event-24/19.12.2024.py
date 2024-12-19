from utilities import read_input, timed
from collections import defaultdict


def prepare_input():
    lines = read_input()

    towels = lines[0].split(", ")
    stacks = lines[1:]

    return towels, stacks


def can_make_design(towels, stack):
    cache = defaultdict(int)
    cache[0] = 1 # only ever one way to make an empty stack

    for i in range(1, len(stack) + 1):
        for towel in towels:
            if i >= len(towel) and stack[i - len(towel):i] == towel:
                cache[i] += cache[i - len(towel)]

    return cache[len(stack)] # 0 if no ways to make this stack


def part_one(input):
    towels, stacks = input
    return sum(1 if can_make_design(towels, stack) else 0 for stack in stacks)


def part_two(input):
    towels, stacks = input
    return sum(can_make_design(towels, stack) for stack in stacks)


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
