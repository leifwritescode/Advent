from utilities import read_input, timed


def prepare_input():
    lines = read_input()

    register_a = int(lines[0])
    program = [int(x) for x in lines[3].split(",")]

    return register_a, program


def run_one_cycle_of_program(a, b, c):
    """
    Runs a single execution of the program, without looping
    outputs the state of the registers, and the value output by the program
    """
    b = a % 8
    b = b ^ 1
    c = a // (2 ** b)
    b = b ^ 5
    a = a // 8
    b = b ^ c
    return a, b, c, b % 8


def run_program_for_a(a):
    """
    Runs the program until a is 0

    BST A => B = A % 8
    BXL 1 => B = B ^ 1
    CDV B => C = A // (2 ** B)
    BXL 5 => B = B ^ 5
    ADV 3 => A = A // 8
    BXC 3 => B = B ^ C
    OUT B => WRITE B % 8
    JNZ 0 => GOTO 0 if A not 0
    """
    b, c = 0, 0
    out = []
    while a != 0:
        a, b, c, x = run_one_cycle_of_program(a, b, c)
        out.append(x)
    return out


def part_one(input):
    a, _ = input
    return ",".join([str(x) for x in run_program_for_a(a)])


def try_find_a(program, a = 0):
    if len(program) == 0:
        return a
    
    for candidate in (a * 8 + bits for bits in range(8)):
        _, _, _, x = run_one_cycle_of_program(candidate, 0, 0)
        if x == program[-1]:
            val = try_find_a(program[:-1], candidate)
            if val is None:
                continue
            return val


def part_two(input):
    _, program = input
    return try_find_a(program)


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res)

    res = timed(lambda: part_two(input))
    print("part 2:", res)


if __name__ == '__main__':
    main()
