from utilities import read_input, timed


def prepare_input():
    lines = read_input()
    return lines


def part_one(input):
    return -1


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
