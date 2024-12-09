from utilities import read_input, timed
from math import sqrt


# for every (unique) pair of antenna there are two antinodes
def part_one():
    lines = read_input()
    map = { }

    w = len(lines[0])
    h = len(lines)

    # extract the map.
    # we only care about the antenna positions and types
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            loc = (x[0], y[0])
            match x[1]:
                case '.':
                    continue
                case _:
                    if x[1] in map:
                        map[x[1]].append(loc)
                    else:
                        map[x[1]] = [loc]

    antinodes = set()
    for key in map:
        for a in map[key]:
            for b in map[key]:
                if a == b:
                    continue
                else:
                    v = (b[0] - a[0], b[1] - a[1])
                    mag = sqrt((v[0] ** 2) + (v[1] ** 2))
                    nrm = (v[0] / mag, v[1] / mag)
                    u = (nrm[0] * mag, nrm[1] * mag)
                    c = (a[0] - u[0], a[1] - u[1])
                    d = (b[0] + u[0], b[1] + u[1])
                    if 0 <= c[0] < w and 0 <= c[1] < h:
                        antinodes.add(c)
                    if 0 <= d[0] < w and 0 <= d[1] < h:
                        antinodes.add(d)

    return len(antinodes)


def part_two():
    lines = read_input()
    return 0


def main():
    res = timed(lambda: part_one())
    print("part 1:", res)

    res = timed(lambda: part_two())
    print("part 2:", res)


if __name__ == '__main__':
    main()
