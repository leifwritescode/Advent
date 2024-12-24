from utilities import read_input, timed
from collections import namedtuple, deque
from itertools import groupby
import re


Instruction = namedtuple("Instruction", ["in1", "in2", "op", "out"])


def prepare_input():
    lines = read_input()

    registers = None
    instructions = None
    for key, group in groupby(lines, lambda x: x != ''):
        if not key:
            continue

        if not registers:
            registers = { }
            for _, line in enumerate(list(group)):
                m = re.search("(\w+): (\d)", line)
                registers[m.group(1)] = int(m.group(2))
            continue

        if not instructions:
            instructions = []
            for _, line in enumerate(list(group)):
                m = re.search("(\w+) (\w+) (\w+) -> (\w+)", line)
                i = Instruction(m.group(1), m.group(3), m.group(2), m.group(4))
                instructions.append(i)
            continue

    return registers, instructions


def part_one(input):
    registers, instructions = input

    # process instructions as a retry queue
    queue = deque(instructions)
    while queue:
        ins = queue.popleft()

        if ins.in1 not in registers:
            queue.append(ins)
            continue

        if ins.in2 not in registers:
            queue.append(ins)
            continue

        a = registers[ins.in1]
        b = registers[ins.in2]

        c = 0
        match ins.op:
            case "XOR":
                c = a ^ b
            case "OR":
                c = a | b
            case "AND":
                c = a & b
            case _:
                raise Exception("encounted weird opcode")

        registers[ins.out] = c

    z_registers = [key for key in registers if key[0] == "z"]
    output = 0
    for z_register in z_registers:
        order = int(z_register[1:])
        output += registers[z_register] << order

    return output


def part_two(input):
    # cnk,mps,msq,qwf,vhm,z14,z27,z39
    return "by hand - see comment"


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
