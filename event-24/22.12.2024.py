from utilities import read_input, timed
from itertools import pairwise
from collections import defaultdict


def prepare_input():
    lines = read_input()
    return [int(line) for line in lines]


def step(s):
    a = s ^ (s * 64) % 16777216
    b = a ^ (a // 32) % 16777216
    return b ^ (b * 2048) % 16777216


def step_two_k_times(s):
    for _ in range(2000):
        s = step(s)
    return s


def part_one(secrets):
    return sum(step_two_k_times(s) for s in secrets)


def get_prices_from_secret(s):
    """
    Yields an iterator of prices derived from stepping the secret 2000 times
    """
    yield s % 10
    for _ in range(2000):
        yield (s := step(s)) % 10


def map_changes_in_price_to_sequences(s):
    map_of_sequence_to_price = { }
    prices = list(get_prices_from_secret(s))
    changes = [b - a for a, b in pairwise(prices)]
    for i in range(len(changes) - 3):
        sequence = tuple(changes[i:i + 4])
        price = prices[i + 4]
        if sequence in map_of_sequence_to_price:
            continue
        map_of_sequence_to_price[sequence] = price
    return map_of_sequence_to_price


def part_two(secrets):
    mappings = [map_changes_in_price_to_sequences(s) for s in secrets]

    union_of_mappings = defaultdict(int)
    for mapping in mappings:
        for key in mapping:
            union_of_mappings[key] += mapping[key]

    return max(union_of_mappings[key] for key in union_of_mappings)


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
