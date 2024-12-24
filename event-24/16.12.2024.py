from utilities import read_input, timed
from collections import namedtuple, defaultdict
from math import inf
from enum import Enum


Point = namedtuple('Point', ["x", "y"])


# Define directions
class Direction(Enum):
    EAST = 0
    NORTH = 1
    WEST = 2
    SOUTH = 3

    def rotate_to(self, target):
        """Calculate the cost of rotating from the current direction to the target direction."""
        diff = abs(self.value - target.value)
        if diff == 2:  # 180-degree turn
            return 2000
        elif diff == 1 or diff == 3:  # 90-degree turn (clockwise or counterclockwise)
            return 1000
        return 0  # No rotation


def prepare_input():
    lines = read_input()

    grid = []
    end = None
    start = None
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            if x[1] == "#":
                continue

            p = Point(x[0], y[0])
            match x[1]:
                case "E":
                    end = p
                case "S":
                    start = p

            grid.append(p)

    return grid, start, end


def reconstruct_path(came_from, current):
    path = []
    total_cost = 0
    while current in came_from:
        prev, prev_direction = came_from[current]
        current, current_direction = current

        # Calculate the cost for this step
        rotation_cost = prev_direction.rotate_to(current_direction)
        step_cost = 1 + rotation_cost
        total_cost += step_cost

        path.append((current, step_cost))
        current = (prev, prev_direction)
    path.reverse()
    return path, total_cost


def neighbours_of(a):
    # Neighbours are oriented W, N, E, S
    neighbours = [Point(-1, 0), Point(0, -1), Point(1, 0), Point(0, 1)]
    return [Point(a.x + p.x, a.y + p.y) for p in neighbours]


def heuristic(a, b):
    """
    Manhattan Distance
    """
    return abs(a.x - b.x) + abs(a.y - b.y)


def modified_a_star(grid, start, target):
    """
    A modified A* algorithm that accounts for change in direction.
    Assumes we are initially facing EAST.
    """
    open_set = {(start, Direction.EAST)}
    came_from = {}
    g_score = defaultdict(lambda: inf)
    g_score[(start, Direction.EAST)] = 0
    f_score = defaultdict(lambda: inf)
    f_score[(start, Direction.EAST)] = heuristic(start, target)

    while open_set:
        # Select the node in open_set with the lowest f_score
        current, current_direction = min(open_set, key=lambda x: f_score[x])
        open_set.remove((current, current_direction))

        if current == target:
            return reconstruct_path(came_from, (current, current_direction))

        for i, neighbour in enumerate(neighbours_of(current)):
            if neighbour not in grid:
                continue

            # Determine the direction to the neighbour
            neighbour_direction = Direction(i)

            # Compute rotation cost
            rotation_cost = current_direction.rotate_to(neighbour_direction)

            # Calculate tentative g_score
            tentative_g_score = g_score[(current, current_direction)] + 1 + rotation_cost

            # Update scores if this path is better
            if tentative_g_score < g_score[(neighbour, neighbour_direction)]:
                came_from[(neighbour, neighbour_direction)] = (current, current_direction)
                g_score[(neighbour, neighbour_direction)] = tentative_g_score
                f_score[(neighbour, neighbour_direction)] = tentative_g_score + heuristic(neighbour, target)
                open_set.add((neighbour, neighbour_direction))

    return None



def part_one(input):
    # a star search for fastest path where rotations cost 1000 and forward steps cost 1
    # ergo a step to a neighbour involving n rotations costs 1 + (n * 1000)
    # only ever need to rotate twice (max 2000) since we can rotate both ways
    grid, start, end = input
    shortest_path, cost = modified_a_star(grid, start, end)
    return len(shortest_path), cost


def part_two(input):
    return -1


def main():
    input = prepare_input()

    # example should = 11048
    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
