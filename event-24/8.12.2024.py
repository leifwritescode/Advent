from utilities import read_input, timed
from math import sqrt
from functools import reduce


def extract_grid(lines):
    """
    Given the puzzle input, extract and return the grid, it's width, and it's height.
    """
    grid = { }
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            loc = (x[0], y[0])
            match x[1]:
                case '.':
                    continue
                case _:
                    if x[1] in grid:
                        grid[x[1]].append(loc)
                    else:
                        grid[x[1]] = [loc]
    return grid, len(lines[0]), len(lines)


def get_vec_u(a, b):
    """
    Given two points `a` and `b`, return the distance vector between them.
    """
    direction = (b[0] - a[0], b[1] - a[1])
    magnitude = sqrt((direction[0] ** 2) + (direction[1] ** 2))
    normalised_direction = (direction[0] / magnitude, direction[1] / magnitude)

    # we have to round u, as rounding errors could create erroneous nodes
    return (round(normalised_direction[0] * magnitude, 0), round(normalised_direction[1] * magnitude, 0))


def find_antinodes(a, b):
    u = get_vec_u(a, b)
    a = (a[0] - u[0], a[1] - u[1])
    b = (b[0] + u[0], b[1] + u[1])
    return [a, b]


def bounds_checked_antinodes(nodes, w, h):
    return [node for node in nodes if 0 <= node[0] < w and 0 <= node[1] < h]


# for every (unique) pair of antenna there are two antinodes
def part_one():
    grid, w, h = extract_grid(read_input())

    antinodes = set()
    
    for key in grid:
        for a in grid[key]:
            for b in grid[key]:
                if a == b:
                    continue

                antinodes.update(bounds_checked_antinodes(find_antinodes(a, b), w, h))

    return len(antinodes)


def part_two():
    grid, w, h = extract_grid(read_input())

    antinodes = set()
    for key in grid:
        for a in grid[key]:
            for b in grid[key]:
                if a == b:
                    continue
                else:
                    # any frequency broadcast by at least two antennas
                    # results in antinodes at each antenna broadcasting the frequency
                    antinodes.add(a)
                    antinodes.add(b)

                    v = (b[0] - a[0], b[1] - a[1])
                    mag = sqrt((v[0] ** 2) + (v[1] ** 2))
                    nrm = (v[0] / mag, v[1] / mag)

                    # we have to round u, as rounding errors could create erroneous nodes
                    u = (round(nrm[0] * mag, 0), round(nrm[1] * mag, 0))

                    # resonant harmonics mean the antinodes now appear at intervals
                    # defined by the vector u
                    # keep placing antinodes prior to a and after b until we reach the
                    # bounds of the map
                    c = (a[0] - u[0], a[1] - u[1])
                    while 0 <= c[0] < w and 0 <= c[1] < h:
                        antinodes.add(c)
                        c = (c[0] - u[0], c[1] - u[1])

                    d = (b[0] + u[0], b[1] + u[1])
                    while 0 <= d[0] < w and 0 <= d[1] < h:
                        antinodes.add(d)
                        d = (d[0] + u[0], d[1] + u[1])

    return len(antinodes) # 1156 (too high)


def main():
    res = timed(lambda: part_one())
    print("part 1:", res)

    res = timed(lambda: part_two())
    print("part 2:", res)


if __name__ == '__main__':
    main()
