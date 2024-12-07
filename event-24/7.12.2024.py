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


# for the concatenation pass, we do it forward because the concatenation happens to the current value
# reversing the concatenation would be challenging
def validate_equation_part_2(target, current, operands):
    # if target is not a whole number, then this operation wasn't valid
    if not current.is_integer():
        return False

    # if there are no more values, then test to see if current is the target
    if len(operands) == 0:
        return target == current
    
    # otherwise, recurse through the tree
    val = operands[0]
    a = validate_equation_part_2(target, current * val, operands[1:])
    b = validate_equation_part_2(target, current + val, operands[1:])
    c = validate_equation_part_2(target, int(f"{int(current)}{int(val)}"), operands[1:])
    return a or b or c


def part_two():
    lines = read_input()
    lines = [line.split(": ") for line in lines]
    equations = [(float(line[0]), list(map(float, line[1].split()))) for line in lines]
    return int(sum([equation[0] if validate_equation_part_2(equation[0], equation[1][0], equation[1][1:]) else 0 for equation in equations]))


def main():
    res = timed(lambda: part_one())
    print("part 1:", res)

    res = timed(lambda: part_two())
    print("part 2:", res)


if __name__ == '__main__':
    main()
