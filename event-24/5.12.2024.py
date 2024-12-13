from utilities import read_input, timed
from collections import defaultdict, deque


def split_rules_and_updates(lines):
    rules = []
    updates = []
    is_update_section = False
    
    for line in lines:
        if '|' in line:  # It's a rule
            if not is_update_section:
                rules.append(line)
        elif line == '':
            continue
        else:  # It's an update
            is_update_section = True
            updates.append(line)

    return rules, updates


def parse_input(input):
    rules, updates = split_rules_and_updates(input)
    rules = [tuple(map(int, rule.split('|'))) for rule in rules]
    updates = [list(map(int, update.split(','))) for update in updates]
    return rules, updates


def is_update_valid(update, rules):
    # Create a mapping of page indices in the current update
    index_map = {page: idx for idx, page in enumerate(update)}
    for x, y in rules:
        if x in index_map and y in index_map:
            # x must appear before y
            if index_map[x] >= index_map[y]:
                return False
    return True


def sum_middle_pages(rules, updates):
    valid_updates = []
    for update in updates:
        if is_update_valid(update, rules):
            valid_updates.append(update)
    
    middle_pages = [update[len(update) // 2] for update in valid_updates]
    return sum(middle_pages)


def part_one():
    rules, updates = parse_input(read_input())
    return sum_middle_pages(rules, updates)


def topological_sort(pages, rules):
    # Create a graph from the rules
    graph = defaultdict(list)
    indegree = defaultdict(int)
    pages_set = set(pages)
    
    for x, y in rules:
        if x in pages_set and y in pages_set:
            graph[x].append(y)
            indegree[y] += 1
            indegree.setdefault(x, 0)
    
    # Perform topological sort using Kahn's algorithm
    queue = deque([node for node in pages if indegree[node] == 0])
    sorted_pages = []
    
    while queue:
        current = queue.popleft()
        sorted_pages.append(current)
        for neighbor in graph[current]:
            indegree[neighbor] -= 1
            if indegree[neighbor] == 0:
                queue.append(neighbor)
    
    return sorted_pages


def fix_and_sum_middle_pages(rules, updates):
    incorrect_updates = []
    fixed_updates = []
    
    for update in updates:
        if not is_update_valid(update, rules):
            incorrect_updates.append(update)
            fixed_update = topological_sort(update, rules)
            fixed_updates.append(fixed_update)
    
    middle_pages = [update[len(update) // 2] for update in fixed_updates]
    return sum(middle_pages)


def part_two():
    rules, updates = parse_input(read_input())
    return fix_and_sum_middle_pages(rules, updates)


def main():
    print(timed(lambda: part_one()))
    print(timed(lambda: part_two()))


if __name__ == '__main__':
    main()
