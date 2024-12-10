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


def compress_storage_by_block(storage):
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
    compress_storage_by_block(storage)

    return sum([x[0] * x[1] for x in enumerate(storage) if x[1] != -1])


def find_contiguous_span_of(value, array):
    """
    Given an array and a value, find the start and length of the first contiguous block
    of the value in the array

    Might throw.
    """
    start = -1
    try:
        start = array.index(value)
    except:
        return (-1, -1)

    run = 1
    while start + run < len(array) and array[start + run] == value:
        run +=1

    return (start, run)

def find_contiguous_span_of_length(value, array, length, offset):
    start = -1
    try:
        start = array.index(value)
    except:
        return (-1, -1)

    run = 1
    while start + run < len(array) and array[start + run] == value:
        run +=1

    if length <= run:
        return (start + offset, run)
    elif start + run == len(array):
        return (-1, -1)
    else:
        return find_contiguous_span_of_length(value, array[start + run:], length, offset + start + run)


def swap_spans(storage, source, dest):
    """
    swaps two spans of data in the array
    """
    source_val = storage[source[0]]
    # dest_val is always -1

    for x in range(dest[0], dest[0] + source[1]):
        storage[x] = source_val

    for x in range(source[0], source[0] + source[1]):
        storage[x] = -1


def compress_storage_by_span(storage):
    # since we know that there is no free blocks at the end of the array
    # we can cheese finding the first file_id
    file_id = storage[-1]

    while file_id > 0: # file_id 0 is guaranteed to be at the start
        print("processing", file_id)
        file_span = find_contiguous_span_of(file_id, storage)
        free_span = find_contiguous_span_of_length(-1, storage[:file_span[0]], file_span[1], 0)
        if free_span[0] != -1:
            swap_spans(storage, file_span, free_span)
        file_id -= 1


def part_two(input):
    files, spaces = input

    storage = expand_drive_map(files, spaces)
    compress_storage_by_span(storage)

    return sum([x[0] * x[1] for x in enumerate(storage) if x[1] != -1])


def main():
    input = prepare_input()

    # 150ms
    res = timed(lambda: part_one(input))
    print("part 1:", res if res != -1 else "not implemented")

    # 6418529470362 after 16 minutes lmfao
    # we can try to optimise by recording the contiguous free memory ONCE
    # and then updating that map each time we change
    # if we use a map of { index : space }, then we should be able to say 
    # min(key) for key in dict if dict[key] <= n
    # where n is the amount of space required
    # then update the dict using dict[key] = dict[key] - n
    # and clearing the key if it zeroes out
    # res = timed(lambda: part_two(input))
    # print("part 2:", res if res != -1 else "not implemented")


if __name__ == '__main__':
    main()
