from utilities import read_input, timed


def prepare_input():
    lines = read_input()
    return [list(map(int, list(line))) for line in lines]


def even_largester_joltage(bank, k):
    drop = len(bank) - k
    stack = []

    for digit in bank:
        while drop > 0 and stack and stack[-1] < digit:
            stack.pop()
            drop -= 1
        stack.append(digit)

    return sum([stack[i] * (10**((i-k+1)*-1)) for i in range(k)])


def part_one(input):
    return sum([even_largester_joltage(bank, 2) for bank in input])


def part_two(input):
    return sum([even_largester_joltage(bank, 12) for bank in input])


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
