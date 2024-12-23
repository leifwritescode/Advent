from utilities import read_input, timed
from collections import defaultdict


def prepare_input():
    lines = read_input()

    graph = defaultdict(list)
    for line in lines:
        vertices = line.split("-")
        graph[vertices[0]].append(vertices[1])
        graph[vertices[1]].append(vertices[0])

    return graph


def find_groups_of_three_at_key(g, k):
    groups_at_vertex = set()

    # each group starts with k
    # we have g and k
    # we want to find an x in g[k] where some value y in g[x] is also in g[k]
    # then sort and add to the set
    for x in g[k]:
        for y in g[x]:
            if x == y:
                continue
            if y in g[k]:
                groups_at_vertex.add(tuple(sorted([k, x, y])))

    return groups_at_vertex


def part_one(graph):
    groups = set()
    for key in graph:
         if key[0] != "t":
             continue
         groups = groups.union(find_groups_of_three_at_key(graph, key))

    return len(groups)


def bron_kerbosch(R, P, X, graph, cliques):
    if not P and not X:
        # Found a maximal clique
        cliques.append(R)
        return
    for v in list(P):
        bron_kerbosch(
            R.union({v}), 
            P.intersection(graph[v]), 
            X.intersection(graph[v]), 
            graph, 
            cliques
        )
        P.remove(v)
        X.add(v)


def find_maximal_cliques(graph):
    cliques = []
    vertices = set(graph.keys())
    bron_kerbosch(set(), vertices, set(), graph, cliques)
    return cliques


def part_two(graph):
    largest_clique = list(max(find_maximal_cliques(graph), key=len))
    password = ",".join(sorted(largest_clique))
    return password


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
