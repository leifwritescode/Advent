from utilities import read_input, timed


def prepare_input():
    line = read_input()[0]

    # fix short string by appending a zero-sized space
    if len(line) % 2:
        line += "0"

    files, spaces = [], []
    for i in range(0, len(line) - 1, 2):
        files.append(int(line[i]))
        spaces.append(int(line[i + 1]))

    return files, spaces


def expand_drive_map(files, spaces):
    storage = []
    file_id = 0

    for x in zip(files, spaces):
        storage.extend([file_id] * x[0])
        storage.extend([-1] * x[1])
        file_id += 1

    return storage


def compress_storage(storage):
    a, b = 0, len(storage) - 1

    while a < b:
        if storage[a] != -1:
            a += 1
            continue

        if storage[b] == -1:
            b -= 1
            continue

        temp = storage[a]
        storage[a] = storage[b]
        storage[b] = temp


def part_one(input):
    files, spaces = input

    storage = expand_drive_map(files, spaces)
    compress_storage(storage)

    return sum([x[0] * x[1] for x in enumerate(storage) if x[1] != -1])


def part_two(input):
    return -1


def main():
    input = prepare_input()

    res = timed(lambda: part_one(input))
    print("part 1:", res if res != -1 else "not implemented")

    res = timed(lambda: part_two(input))
    print("part 2:", res if res != -1 else "not implemented")


if __name__ == '__main__':
    main()
