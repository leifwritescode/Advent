from utilities import read_input, timed


def prepare_input():
    lines = read_input()
    grid = { }
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            grid[(x[0], y[0])] = x[1]
    return grid


def find_neighbours(cell):
    vectors = [(-1, 0), (0, -1), (1, 0), (0, 1)]
    return [(cell[0] + vector[0], cell[1] + vector[1]) for vector in vectors]


def find_region(start, grid):
    queue = [ start ]
    plant = grid[start]
    region = { start }
    while queue:
        cell = queue.pop()
        neighbours = find_neighbours(cell)
        for neighbour in neighbours:
            if neighbour not in grid:
                continue
            if neighbour not in region and grid[neighbour] == plant:
                queue.append(neighbour)
                region.add(neighbour)
    return region


def find_regions(grid):
    candidates = { key for key in grid }
    regions = []
    while candidates:
        start = candidates.pop()
        region = find_region(start, grid)
        candidates -= region
        regions += [region]
    return regions


def sum_perimiter(region):
    result = 0
    for cell in region:
        result += 4 - len([neighbour for neighbour in find_neighbours(cell) if neighbour in region])
    return result * len(region)


def part_one(grid):
    return sum([sum_perimiter(region) for region in find_regions(grid)])


def sum_sides(region):
    edges = set()
    for cell in region:
        edges.update([(cell, neighbour) for neighbour in find_neighbours(cell) if neighbour not in region])

    sides = 0
    for cell, neighbour in edges:
        if cell[1] == neighbour[1]:
            a = (cell[0], cell[1] - 1)
            b = (neighbour[0], neighbour[1] - 1)
            if (a, b) not in edges:
                sides += 1
        else:
            a = (cell[0] - 1, cell[1])
            b = (neighbour[0] - 1, neighbour[1])
            if (a, b) not in edges:
                sides += 1
    return sides * len(region)


def part_two(grid):
    return sum([sum_sides(region) for region in find_regions(grid)])


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
