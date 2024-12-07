from utilities import read_input, timed

# answer = x         // is valid if answer == x
# answer = expr * x  // is valid if x divides answer and (answer / x = expr) is valid
# answer = expr + x  // is valid if (answer - x = expr) is valid
# answer = expr || x // is valid if str(answer) ends with str(x) and (answer.removeSuffix(x) = expr) is valid

def validate_equation_part_1(target, operands):
    # if target is not a whole number, then this operation wasn't valid
    if not target.is_integer():
        return False

    # if we've overshot the target, then the math doesn't check out
    if target <= 0:
        return False

    val = operands[-1]

    # if it's the last value, then our target should match it
    if len(operands) == 1:
        return val == target
    
    # turns out // is floor division, and / is normal divison
    # otherwise, recurse on the next
    return validate_equation_part_1(target / val, operands[:-1]) or validate_equation_part_1(target - val, operands[:-1])

# answer is too high
def part_one():
    lines = read_input()
    lines = [line.split(": ") for line in lines]
    equations = [(float(line[0]), list(map(float, line[1].split()))) for line in lines]
    return int(sum([equation[0] if validate_equation_part_1(equation[0], equation[1]) else 0 for equation in equations]))


def validate_equation_part_2(target, operands):
    # if target is not a whole number, then this operation wasn't valid
    if not target.is_integer():
        return False

    # if we've overshot the target, then the math doesn't check out
    if target <= 0:
        return False

    val = operands[-1]

    # if it's the last value, then our target should match it
    if len(operands) == 1:
        return val == target
    
    a = validate_equation_part_2(target / val, operands[:-1])
    b = validate_equation_part_2(target - val, operands[:-1])

    # we should only ever test concatenation if it is
    # possible that concatenation occurred
    if str(int(target)).endswith(str(int(val))):
        # we can strip the end off the concatenated number
        # by dividing it by 10 ^ len(val)
        # e.g. 198, concatenated from 19 and 8, would be 198 / 10
        # we intentionally floor the output
        c = validate_equation_part_2(target // (10 ** len(str(int(val)))), operands[:-1])
        return a or b or c
    return a or b


def part_two():
    lines = read_input()
    lines = [line.split(": ") for line in lines]
    equations = [(float(line[0]), list(map(float, line[1].split()))) for line in lines]
    return int(sum([equation[0] if validate_equation_part_2(equation[0], equation[1]) else 0 for equation in equations]))


def main():
    res = timed(lambda: part_one())
    print("part 1:", res)

    res = timed(lambda: part_two())
    print("part 2:", res)


if __name__ == '__main__':
    main()
