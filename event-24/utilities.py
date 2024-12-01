import __main__
from pathlib import Path


def read_input():
    path = Path(__main__.__file__)
    input_file_name = path.stem + '.txt'
    input_file_absolute_path = path.with_name(input_file_name)
    with open(input_file_absolute_path, 'r') as file:
        lines = [line.strip() for line in file]
    return lines
