#!/usr/bin/env python3

from utilities import read_input, timed
from collections import defaultdict


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


def simulate_guard(map, pos):
    direction = 0 # direction is an index into the direction array. when it changes, we modulo 4.
    visited = set() # true if the cell has been visited
    while pos in map:
        record = (pos, direction)

        # in part two, if we've visited this cell whilst facing the same direction, we have a loop
        if record in visited:
            return True # loop

        # record that we've visited current cell
        visited.add(record)

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

    return False


def part_two(path):
    lines = read_input()
    map, pos = extract_map_and_start(lines)

    count = 0

    # for part two, we only need to consider positions on the path visited in part one
    for cell in path:
        if map[cell]:
            continue # ignore if already an obstruction

        map[cell] = True
        count += 1 if simulate_guard(map, pos) else 0
        map[cell] = False

    return count


def main():
    path, count = timed(lambda: part_one())
    print(count)

    # for part two, we only need to consider positions on the path visited in part one
    count = timed(lambda: part_two(path))
    print(count)


if __name__ == '__main__':
    main()
