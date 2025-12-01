from utilities import read_input, timed
from abc import ABC, abstractmethod


class Operation(ABC):
    def __init__(self, value):
        self.value = value

    @abstractmethod
    def execute(self, p):
        pass


class Addition(Operation):
    def execute(self, p):
        new_p = (p + self.value) % 100
        times_at_zero = (p + self.value) // 100
        return (new_p, times_at_zero)


class Subtraction(Operation):
    def execute(self, p):
        new_p = (p - self.value) % 100
        times_at_zero = (self.value - (p or 100)) // 100 + 1 if self.value >= p else 0
        return (new_p, times_at_zero)


def prepare_input():
    lines = read_input()

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
        pointer, _ = operation.execute(pointer)
        if pointer == 0:
            counter += 1
    
    return counter


def part_two(input):
    pointer = 50 # 0-99
    counter = 0

    for operation in input:
        pointer, times_at_zero = operation.execute(pointer)
        counter += times_at_zero

    return counter


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
