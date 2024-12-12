from utilities import read_input, timed


def prepare_input():
    lines = read_input()
    grid = { }
    for y in enumerate(lines):
        for x in enumerate(y[1]):
            grid[(x[0], y[0])] = x[1]
    return grid, len(lines[0]), len(lines)


def neighbours(cell):
    vectors = [(-1, 0), (0, -1), (1, 0), (0, 1)]
    return [(cell[0] + vector[0], cell[1] + vector[1]) for vector in vectors]


def search_for_all_neighbours(graph, visited, grid, plots, cell, plot_key):
    if cell in visited:
        return

    # mark that we've visited this cell
    visited.add(cell)

    # exclude any neighbours that don't match the current cell
    next_cells = [next_cell for next_cell in neighbours(cell) if next_cell in grid and grid[next_cell] == grid[cell]]

    # graph is just a mapping of possible paths from cell
    graph[cell] = next_cells

    # update the current plot with the sides at this cell
    if plot_key not in plots:
        plots[plot_key] = []
    plots[plot_key] += [4 - len(next_cells)]

    # if there is no work to do, return up stream
    if not len(next_cells):
        return
    
    # examine each of the neighbouring cells
    for next_cell in next_cells:
        search_for_all_neighbours(graph, visited, grid, plots, next_cell, plot_key)


def part_one(input):
    grid, w, h = input

    graph = { } # a graph of cells and their similar neighbours
    plots = { }
    visited = set()
    for y in range(h):
        for x in range(w):
            if (x, y) in visited:
                continue
            plot_key = (x, y, grid[(x, y)])
            search_for_all_neighbours(graph, visited, grid, plots, (x, y), plot_key)

    return sum([len(plots[plot]) * sum(plots[plot]) for plot in plots]), graph


def part_two(input, graph):
    grid, w, h = input
    return -1


def main():
    input = prepare_input()

    res, graph = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input, graph))
    print("part 2:", res)


if __name__ == '__main__':
    main()
