import re


atoi = [ 'one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'eno', 'owt', 'eerht', 'ruof', 'evif', 'xis', 'neves', 'thgie', 'enin' ]


def read_input():
    raw = open('1.12.2023.txt', 'r')
    return raw.readlines()


def part_two():
    lines = read_input()
    count = 0
    for line in lines:
        first = re.search(r'(\d|one|two|three|four|five|six|seven|eight|nine)', line).group(1)
        # there has to be a better way than this
        last = re.search(r'(\d|eno|owt|eerht|ruof|evif|xis|neves|thgie|enin)', line[::-1]).group(1)
        count += (atoi.index(first) % 9 + 1) * 10 + (atoi.index(last) % 9 + 1)
    return count # should be 54530


def part_one():
    lines = read_input()
    count = 0
    for line in lines:
        first = re.search(r'(\d)', line).group(1)
        last = re.search(r'(\d)', line[::-1]).group(1)
        count += int(first + last)
    return count


def main():
    print(part_one())
    print(part_two())


if __name__ == '__main__':
    main()
