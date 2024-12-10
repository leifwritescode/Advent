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


def cache_free_spans(storage):
    """
    Given a storage array, caches the results of find_contiguous_span_of across the full storage
    """
    cached_spans = { }

    offset = 0
    span = find_contiguous_span_of(-1, storage[offset:])
    while span[0] != -1:
        cached_spans[offset + span[0]] = span[1]

        offset += span[0] + span[1]
        span = find_contiguous_span_of(-1, storage[offset:])

    return cached_spans


def try_use_free_span(cached_spans: dict, length, position):
    """
    Given the cached free spans, a length of space, and a cut off
    Returns the index of the first large enough span and updates the cache
    """
    keys = [key for key in cached_spans if cached_spans[key] >= length and key < position]
    if not len(keys):
        return -1

    # get the smallest key (the earliest span) and its contents
    index = min(keys)
    size = cached_spans[index]

    # then, delete that key
    del cached_spans[index]

    # add a *new* key that is updated with the length used
    # provided there is space remaining
    if size - length > 0:
        cached_spans[index + length] = size - length

    return index


def swap_spans(storage, source, dest):
    """
    swaps two spans of data in the array
    source is a (start, run) and dest is an index
    """
    source_val = storage[source[0]]
    # dest_val is always -1

    for x in range(dest, dest + source[1]):
        storage[x] = source_val

    for x in range(source[0], source[0] + source[1]):
        storage[x] = -1


def compress_storage_by_span(storage, cached_spans):
    # since we know that there is no free blocks at the end of the array
    # we can cheese finding the first file_id
    file_id = storage[-1]

    while file_id > 0: # file_id 0 is guaranteed to be at the start
        file_span = find_contiguous_span_of(file_id, storage)
        free_span = try_use_free_span(cached_spans, file_span[1], file_span[0])

        if free_span != -1:
            swap_spans(storage, file_span, free_span)

        file_id -= 1


def part_two(input):
    files, spaces = input

    storage = expand_drive_map(files, spaces)
    cached_spans = cache_free_spans(storage)
    compress_storage_by_span(storage, cached_spans)

    return sum([x[0] * x[1] for x in enumerate(storage) if x[1] != -1])


def main():
    input = prepare_input()

    # 150ms
    res = timed(lambda: part_one(input))
    print("part 1:", res if res != -1 else "not implemented")

    # ~6.5s after optimisation
    res = timed(lambda: part_two(input))
    print("part 2:", res if res != -1 else "not implemented")


if __name__ == '__main__':
    main()
