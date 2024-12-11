from utilities import read_input, timed
from collections import defaultdict


def prepare_input():
    line = read_input()[0]
    stones = defaultdict(int)
    for key in line.split():
        stones[key] = 1
    return stones


def blink(stones):
    new_stones = defaultdict(int)
    for key in stones:
        num_stones = stones[key]
        if key == "0":
            new_stones["1"] += num_stones
            continue

        l = len(key)
        if l % 2 == 0:
            new_stones[str(int(key[l//2:]))] += num_stones
            new_stones[str(int(key[:l//2]))] += num_stones
            continue

        new_key = str(int(key) * 2024)
        new_stones[new_key] += num_stones
    return new_stones


def part_one(stones):
    for _ in range(25):
        stones = blink(stones)
    return sum([stones[key] for key in stones])


def part_two(stones):
    for _ in range(75):
        stones = blink(stones)
    return sum([stones[key] for key in stones])


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
