from utilities import read_input, timed
from functools import reduce


def prepare_input():
    lines = read_input()
    topography = { }
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            topography[(x[0], y[0])] = int(x[1])
    return topography


def search_for_trails(topography, current_cell, last_cell):
    # if we can't actually get here, bail
    if current_cell not in topography:
        return [-1]

    # if current cell is last cell, it's the first run
    # in first run, we know that topography[current_cell] is 0
    if current_cell != last_cell and topography[current_cell] - topography[last_cell] != 1:
        # bail early if the cells are not increasing
        return [-1]

    # if we reached a 9, woohoo, return its location upstream
    if topography[current_cell] == 9:
        return [current_cell]

    # otherwise, continue search in n, e, s, and w.
    next = [(-1, 0), (0, -1), (1, 0), (0, 1)]
    return reduce(lambda a, b: a + search_for_trails(topography, (current_cell[0] + b[0], current_cell[1] + b[1]), current_cell), next, [])


def part_one(topography):
    candidate_trailheads = [key for key in topography if topography[key] == 0]
    return sum(len(set([summit for summit in search_for_trails(topography, trailhead, trailhead) if summit != -1])) for trailhead in candidate_trailheads)


def part_two(topography):
    candidate_trailheads = [key for key in topography if topography[key] == 0]
    return sum(len([summit for summit in search_for_trails(topography, trailhead, trailhead) if summit != -1]) for trailhead in candidate_trailheads)


def main():
    input = prepare_input()

    # 12ms
    res = timed(lambda: part_one(input))
    print("part 1:", res)

    # 12ms
    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
