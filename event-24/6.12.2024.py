#!/usr/bin/env python3

from utilities import read_input, timed
from copy import copy

# guard starts facing up and rotates right 90 degrees when encountering an obstacle
DIRECTIONS = [ (0, -1), (1, 0), (0, 1), (-1, 0) ]


def extract_map_and_start(lines):
    map = { }
    pos = (0, 0)
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            loc = (x[0], y[0])
            match x[1]:
                case '#':
                    map[loc] = True
                case '.':
                    map[loc] = False
                case '^':
                    map[loc] = False
                    pos = loc # should only happen once but fuck it we ball
                case _:
                    raise Exception("unexpected character at", loc)
    return map, pos


def part_one():
    lines = read_input()
    map, pos = extract_map_and_start(lines)

    direction = 0 # direction is an index into the direction array. when it changes, we modulo 4.
    visited = set()
    while pos in map:
        # record that we've visited current cell
        visited.add(pos)

        # determine next cell
        vector = DIRECTIONS[direction]
        next_pos = (pos[0] + vector[0], pos[1] + vector[1])

        # remembering that map is a collection of booleans
        if next_pos in map and map[next_pos]:
            # rotate
            direction = (direction + 1) % 4
        else:
            # move
            pos = next_pos

    return visited, len(visited)


def simulate_guard(map, pos, test):
    # set the obstruction
    my_map = copy(map)
    my_map[test] = True
    my_pos = copy(pos)

    direction = 0 # direction is an index into the direction array. when it changes, we modulo 4.
    visited = set() # true if the cell has been visited
    while my_pos in my_map:
        record = (my_pos, direction)

        # in part two, if we've visited this cell whilst facing the same direction, we have a loop
        if record in visited:
            return 1 # loop

        # record that we've visited current cell
        visited.add(record)

        # determine next cell
        vector = DIRECTIONS[direction]
        next_pos = (my_pos[0] + vector[0], my_pos[1] + vector[1])

        # remembering that map is a collection of booleans
        if next_pos in my_map and my_map[next_pos]:
            # rotate
            direction = (direction + 1) % 4
        else:
            # move
            my_pos = next_pos

    return 0


def part_two(path):
    lines = read_input()
    map, pos = extract_map_and_start(lines)
    return sum(simulate_guard(map, pos, cell) for cell in path if not map[cell])


def main():
    path, count = timed(lambda: part_one())
    print(count)

    # for part two, we only need to consider positions on the path visited in part one
    count = timed(lambda: part_two(path))
    print(count)


if __name__ == '__main__':
    main()
