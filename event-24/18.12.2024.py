from utilities import read_input, timed
from collections import namedtuple, defaultdict, deque
from sys import maxsize

directions = [(1, 0), (0, -1), (-1, 0), (0, 1)]

Point = namedtuple('Point', ["x", "y"])

initial_cutoff = 1024
width_heigh = 70


def prepare_input():
    lines = read_input()

    input = []
    for line in lines:
        x = line.split(",")
        input.append(Point(int(x[0]), int(x[1])))

    return input


def reconstruct_path(came_from, current):
    path = { current }
    while current in came_from:
        current = came_from[current]
        path.add(current)
    return path


def neighbours_of(a, w, h):
    neighbours = [Point(-1, 0), Point(0, -1), Point(1, 0), Point(0, 1)]
    return [Point(a.x + p.x, a.y + p.y) for p in neighbours if 0 <= (a.x + p.x) <= w and 0 <= (a.y + p.y) <= h]


def heuristic(a, b):
    """
    Manhattan Distance
    """
    return abs(a.x - b.x) + abs(a.y + b.y)


def a_star(fallen_bytes, start, target, w, h):
    open_set = { start }
    came_from = { }
    g_score = defaultdict(lambda: maxsize)
    g_score[start] = 0
    f_score = defaultdict(lambda: maxsize)
    f_score[start] = heuristic(start, target)

    while open_set:
        current = open_set.pop()

        if current == target:
            return reconstruct_path(came_from, current)

        neighbours = [neighbour for neighbour in neighbours_of(current, w, h) if neighbour not in fallen_bytes]
        for neighbour in neighbours:
            tentative_g_score = g_score[current] + 1
            if tentative_g_score < g_score[neighbour]:
                came_from[neighbour] = current
                g_score[neighbour] = tentative_g_score
                f_score[neighbour] = tentative_g_score + heuristic(neighbour, target)
                if neighbour not in open_set:
                    open_set.add(neighbour)

    return None


def part_one(input):
    fallen_bytes = input[:initial_cutoff]
    path = a_star(fallen_bytes, Point(0, 0), Point(width_heigh, width_heigh), width_heigh, width_heigh)
    return len(path) - 1 # the path includes start and end


def part_two(input):
    fallen_bytes = input[:initial_cutoff]
    remaining_bytes = deque(input[initial_cutoff:])

    # we need an initial copy of the path as a starting point
    path = a_star(fallen_bytes, Point(0, 0), Point(width_heigh, width_heigh), width_heigh, width_heigh)
    while remaining_bytes:

        # pop the next falling byte from the queue and add it to the fallen bytes
        next_byte = remaining_bytes.popleft()
        fallen_bytes.append(next_byte)

        # if that byte is not on the previously computed path, then we can ignore it and continue the loop
        if next_byte not in path:
            continue

        # otherwise, we need to recompute the path. if there is no valid path, then next_byte is the answer
        path = a_star(fallen_bytes, Point(0, 0), Point(width_heigh, width_heigh), width_heigh, width_heigh)
        if not path:
            return next_byte

    raise Exception("didn't find the answer")


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
