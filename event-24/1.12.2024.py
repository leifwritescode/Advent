from utilities import read_input
from functools import reduce
from collections import Counter

def part_one():
    lines = read_input()
    # ["1   2", "3   4"] -> [(1, 2), (3, 4)] -> [[1, 3], [2, 4]] -> [1, 3], [2, 4]
    left_list, right_list = zip(*[tuple(map(int, line.split())) for line in lines])
    pairs = zip(sorted(left_list), sorted(right_list))
    return reduce(lambda a, b: a + abs(b[0] - b[1]), pairs, 0)


def part_two():
    lines = read_input()
    left_list, right_list = zip(*[tuple(map(int, line.split())) for line in lines])
    right_counts = Counter(right_list)
    return sum(num * right_counts[num] for num in left_list)

def main():
    print(part_one())
    print(part_two())


if __name__ == '__main__':
    main()
