from utilities import read_input, timed
import re
from collections import defaultdict


w = 101
h = 103

extents = [
    ((0, 0), (w // 2, h // 2)), # upper left
    ((w // 2 + 1, 0), (w, h // 2)), # upper right
    ((0, h // 2 + 1), (w // 2, h)), # lower left
    ((w // 2 + 1, h // 2 + 1), (w, h)) # lower right
]


def prepare_input():
    lines = read_input()
    
    grid = { }
    for line in lines:
        matches = re.search('p=(-?\d+),(-?\d+) v=(-?\d+),(-?\d+)', line)
        key = (int(matches.group(1)), int(matches.group(2)))
        value = (int(matches.group(3)), int(matches.group(4)))

        if key in grid:
            grid[key].append(value)
        else:
            grid[key] = [value]

    return grid


def part_one(grid):
    final_grid = defaultdict(int)
    for key in grid:
        for pos in grid[key]:
            final_pos = (key[0] + 100 * pos[0]) % w, (key[1] + 100 * pos[1]) % h
            final_grid[final_pos] += 1

    count = 1
    for extent in extents:
        count *= sum(final_grid[key] for key in final_grid if extent[0][0] <= key[0] < extent[1][0] and extent[0][1] <= key[1] < extent[1][1])

    return count


def part_two(grid):
    cycles = 0
    max_cycles = w * h

    # we can assume that, if they're arranged like a tree, it will be the first cycle where no two robots share a space
    while any(len(grid[key]) != 1 for key in grid) and cycles < max_cycles:
        cycles += 1

        new_grid = defaultdict(list)
        for pos in grid:
            for vector in grid[pos]:
                new_pos = (pos[0] + vector[0]) % w, (pos[1] + vector[1]) % h
                new_grid[new_pos].append(vector)

        grid = new_grid

    return cycles


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
