from utilities import read_input
from functools import reduce


# all possible directions from origin
VECTORS_P1 = [(-1, 0), (-1, -1), (0, -1), (1, -1), (1, 0), (1, 1), (0, 1), (-1, 1)]

# part 2 all possible configurations of the x
XMAS = [
    [ 'M', 'M', 'S', 'S' ],
    [ 'S', 'M', 'M', 'S' ],
    [ 'S', 'S', 'M', 'M' ],
    [ 'M', 'S', 'S', 'M' ]
]

# part 2 all directions mapped the same as XMAS
VECTORS_P2 = [(-1, -1), (1, -1), (1, 1), (-1, 1)]


# given the grid, width, height, index, and character
# determine if we've found an xmas
def check_in_dir(g, w, h, x, y, v, c):
    # always return up the chain if we're out of bounds
    if x < 0 or x >= w or y < 0 or y >= h:
        return 0

    # bail if we have a mismatch
    if g[y * w + x] != c:
        return 0

    # haha principal-level engineer go brrrrrrr
    nc = c
    if nc == 'M':
        nc = 'A'
    elif nc == 'A':
        nc = 'S'

    # if c is S, and we're here, we've found an xmas
    return 1 if c == 'S' else check_in_dir(g, w, h, x + v[0], y + v[1], v, nc)


def part_one():
    lines = read_input()
    height = len(lines)
    width = len(lines[0])
    grid = reduce(lambda a, b: a + b, lines)

    count = 0
    for y in range(height):
        for x in range(width):
            if grid[y * width + x] != 'X':
                continue
            count += reduce(lambda a, v: a + check_in_dir(grid, width, height, x + v[0], y + v[1], v, 'M'), VECTORS_P1, 0)

    return count


# find x-mas, there are 9 in the test file
# allegedly, 2003
# 0.04s to run, we're beginning to get outside of brute force territory
def part_two():
    lines = read_input()
    height = len(lines)
    width = len(lines[0])
    grid = reduce(lambda a, b: a + b, lines)

    count = 0

    # since we know we're checking the centre of the pattern, we can ignore the outermost columns and rows
    for y in range(1, height - 1):
        for x in range(1, width - 1):
            if grid[y * width + x] != 'A':
                continue

            # good lord this is embarassingly bad lmao
            for xmas in XMAS:
                # this is probably slower than checkin them manually, but equally it is neater
                zipped = list(zip(VECTORS_P2, xmas))
                if all([grid[(y + v[0][1]) * width + (x + v[0][0])] == v[1] for v in zipped]):
                    count += 1
                    break # into outer loop

    return count


def main():
    print(part_one())
    print(part_two())


if __name__ == '__main__':
    main()
