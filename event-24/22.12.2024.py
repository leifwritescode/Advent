from utilities import read_input, timed


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


def part_one(input):
    return sum(step_two_k_times(s) for s in input)


def part_two(input):
    return -1


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
