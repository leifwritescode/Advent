import __main__
from pathlib import Path


def read_input():
    raw = open(Path(__main__.__file__).stem + '.txt', 'r')
    return raw.readlines()
