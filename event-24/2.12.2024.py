from utilities import read_input


def is_serie_safe(serie):
    gaps = [serie[i+1] - serie[i] for i in range(len(serie) - 1)]
    return (max(gaps) <= 3 and min(gaps) >= 1) or (max(gaps) <= -1 and min(gaps) >= -3)


def check_serie_part_one(serie):
    return 1 if is_serie_safe(serie) else 0
        

def part_one():
    lines = read_input()
    series = [list(map(int, line.split())) for line in lines]
    return sum([check_serie_part_one(serie) for serie in series])


def check_serie_part_two(serie):
    return 1 if any([is_serie_safe(serie[:i]+serie[i+1:]) for i in range(len(serie))]) else 0


def part_two():
    lines = read_input()
    series = [list(map(int, line.split())) for line in lines]
    return sum([check_serie_part_two(serie) for serie in series])


def main():
    print(part_one())
    print(part_two())


if __name__ == '__main__':
    main()
