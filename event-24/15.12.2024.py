from utilities import read_input, timed
from itertools import groupby
from time import sleep

vectors = { "^": (0, -1), ">": (1, 0), "v": (0, 1), "<": (-1, 0), }


def prepare_input():
    lines = read_input(True)

    grid = None
    moves = None
    start = None
    for key, group in groupby(lines, lambda x: x != ''):
        if not key:
            continue

        if not grid:
            grid = { }
            for y in enumerate(list(group)):
                for x in enumerate(y[1]):
                    pos = (x[0], y[0])
                    match x[1]:
                        case '@':
                            start = pos
                            grid[pos] = "."
                        case _:
                            grid[pos] = x[1]
            continue

        if not moves:
            moves = []
            for line in list(group):
                for x in line:
                    moves.append(x)

    return grid, moves, start


def can_i_go_here(g, p, m):
    # if p is a wall, or out of bounds, we can't move here
    if p not in g: return False
    if g[p] == "#": return False

    # if it's a free space, we can!
    if g[p] == ".": return True

    # otherwise, we are a box. determine if the box can move
    new_p = (p[0] + m[0], p[1] + m[1])
    if can_i_go_here(g, new_p, m):
        g[p] = "."
        g[new_p] = "O"
        return True

    return False


def move(g, m, p):
    new_p = (p[0] + m[0], p[1] + m[1])

    if can_i_go_here(g, new_p, m):
        return new_p

    return p


def part_one(input):
    grid, moves, position = input
    for m in moves:
        position = move(grid, vectors[m], position)
    return sum(key[1] * 100 + key[0] for key in grid if grid[key] == 'O')


def scale_up_map(original_map):
    """Scales up the map by doubling its width and adjusting boxes."""
    scaled_map = {}
    for (x, y), value in original_map.items():
        new_x = x * 2
        new_y = y
        if value == "O":
            scaled_map[(new_x, new_y)] = "["
            scaled_map[(new_x + 1, new_y)] = "]"
        else:
            scaled_map[(new_x, new_y)] = value 
            if value == "@":
                scaled_map[(new_x + 1, new_y)] = "."
            else:
                scaled_map[(new_x + 1, new_y)] = value

    return scaled_map


def can_i_go_here_2(g, p, m):
    # if p is a wall, or out of bounds, we can't move here
    if p not in g: return False
    if g[p] == "#": return False

    # if it's a free space, we can!
    if g[p] == ".": return True

    # otherwise, we are a box. determine if the box can move
    # depending on which side we are on, a box is either represented by a [ or a ]
    # if it's a [, then we also need to check if the cell to the right can move.
    # if it's a ], then we also need to check if the cell to the left can move.
    # boxes still only move one cell at a time, not two, so
    # if yes, then our p is valid
    new_p_l = None
    new_p_r = None
    if m[0] == 0: # we're moving down
        if g[p] == "[":
            new_p_l = (p[0] + m[0], p[1] + m[1])
            new_p_r = (p[0] + m[0] + 1, p[1] + m[1])
        else:
            new_p_l = (p[0] + m[0] - 1, p[1] + m[1])
            new_p_r = (p[0] + m[0], p[1] + m[1])
    else:
        # if we're testing moving left/right, then we only need to check the cell 2*m from us
        new_p_l = (p[0] + (m[0] * 2), p[1] + m[1]) 
        new_p_r = (p[0] + (m[0] * 2), p[1] + m[1])

    if can_i_go_here_2(g, new_p_l, m) and can_i_go_here_2(g, new_p_r, m):
        if new_p_r == new_p_l: # we're going left/right
            if g[p] == "[": # we are on the left
                print("i am moving a box right")
                g[(p[0] + m[0], p[1] + m[1])] = "["
                g[(p[0] + (m[0] * 2), p[1] + m[1])] = "]"
                g[p] = "."
            else: # we are on the right
                print("i am moving a box left")
                g[(p[0] + m[0], p[1] + m[1])] = "]"
                g[(p[0] + (m[0] * 2), p[1] + m[1])] = "["
                g[p] = "."
        else:
            print("i am moving a box up or down")
            g[new_p_l] = "["
            g[new_p_r] = "]"
            g[(new_p_l[0], new_p_l[1] - m[1])] = "."
            g[(new_p_r[0], new_p_r[1] - m[1])] = "."
        return True

    return False


def move_2(g, m, p):
    new_p = (p[0] + m[0], p[1] + m[1])

    if can_i_go_here_2(g, new_p, m):
        return new_p

    return p


def print_grid(g, p):
    for y in range(max(key[1] for key in g) + 1):
        line = ""
        for x in range(max(key[0] for key in g) + 1):
            if (x, y) == p:
                line += "@"
            else:
                line += g[(x, y)]
        print(line)
    sleep(1)


def part_two(input):
    # fresh grid, scale out, adjust start
    grid, moves, position = prepare_input()
    scaled_map = scale_up_map(grid)
    position = (position[0] * 2, position[1])

    #print_grid(scaled_map, position)
    for m in moves:
        print("moving", m)
        position = move_2(scaled_map, vectors[m], position)
    #    print_grid(scaled_map, position)
    print_grid(scaled_map, position)
    return -1

def main():
    input = prepare_input()

    # example output should be 10092
    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
