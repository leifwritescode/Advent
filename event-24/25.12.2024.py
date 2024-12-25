from utilities import read_input, timed
from itertools import groupby


def prepare_input():
    lines = read_input()

    keys = []
    locks = []
    for key, group in groupby(lines, lambda x: x != ''):
        if not key:
            continue

        schematic = list(group)
        counts = [c.count("#") for c in list(zip(*schematic))]
        locks.append(counts) if schematic[0][0] == "#" else keys.append(counts)

    print(len(locks), len(keys))
    return locks, keys


def part_one(input):
    locks, keys = input
    return sum([all(l + k < 8 for l, k in zip(lock, key)) for lock in locks for key in keys])


def part_two(input):
    return "Merry Christmas, ya filthy animals!"


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
