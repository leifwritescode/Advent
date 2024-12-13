from utilities import read_input, timed
import re


def part_one():
    lines = read_input()
    matches = [re.finditer("mul\((?P<lhs>\d+),(?P<rhs>\d+)\)", line) for line in lines]
    return sum([int(m.group("lhs")) * int(m.group("rhs")) for match in matches for m in match])


def part_two():
    lines = read_input()
    matches = [re.finditer("(?P<do>do\(\))|(?P<dont>don't\(\))|mul\((?P<lhs>\d+),(?P<rhs>\d+)\)", line) for line in lines]
    count = 0
    do = True
    for match in matches:
        for mo in match:
            if mo.group("do"):
                do = True
            elif mo.group("dont"):
                do = False
            else:
                if do:
                    count += int(mo.group("lhs")) * int(mo.group("rhs"))
    return count


def main():
    print(timed(lambda: part_one()))
    print(timed(lambda: part_two()))


if __name__ == '__main__':
    main()
