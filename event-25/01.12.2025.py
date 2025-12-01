from utilities import read_input, timed
from abc import ABC, abstractmethod, abstractproperty


class Operation(ABC):
    def __init__(self, value):
        self.value = value

    @abstractmethod
    def execute(self, p):
        pass


class Addition(Operation):
    def execute(self, p):
        return (p + self.value) % 100


class Subtraction(Operation):
    def execute(self, p):
        return (p - self.value) % 100


def prepare_input():
    lines = read_input()

    # each line of the input is a string beginning with an L or an R, followed by a number
    # e.g. "L3", "R2", etc.
    # if the is prefixed with L, the operation is subtraction and, if R, addition
    processed = []
    for line in lines:
        direction = line[0]
        value = int(line[1:])
        if direction == 'L':
            op = Subtraction(value)
        else:
            op = Addition(value)
        processed.append(op)

    return processed


def part_one(input):
    pointer = 50 # 0-99
    counter = 0

    for operation in input:
        pointer = operation.execute(pointer)
        if pointer == 0:
            counter += 1
    
    return counter


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
