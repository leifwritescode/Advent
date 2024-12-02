from utilities import read_input

def is_serie_safe(serie):
    increasing = all(serie[i] < serie[i + 1] for i in range(len(serie) - 1))
    decreasing = all(serie[i] > serie[i + 1] for i in range(len(serie) - 1))
    safe = all(abs(serie[i] - serie[i + 1]) <= 3 and abs(serie[i] - serie[i+1]) >= 1 for i in range(len(serie) - 1))
    return (increasing or decreasing) and safe


def check_serie_part_one(serie):
    return 1 if is_serie_safe(serie) else 0
        

def part_one():
    lines = read_input()
    series = [list(map(int, line.split())) for line in lines]
    return sum([check_serie_part_one(serie) for serie in series])


def check_serie_part_two(serie):
    if is_serie_safe(serie):
        return 1

    # in the event of an unsafe serie, we can remove a value sequentially and try again
    # this is probably not the way eric intended
    for i in range(len(serie)):
        if is_serie_safe(serie[:i] + serie[i+1:]):
            return 1

    return 0


def part_two():
    lines = read_input()
    series = [list(map(int, line.split())) for line in lines]
    return sum([check_serie_part_two(serie) for serie in series])


def main():
    print(part_one())
    print(part_two())


if __name__ == '__main__':
    main()
