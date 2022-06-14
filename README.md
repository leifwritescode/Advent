# Advent of Code 2020

This repository shall contain my solutions for the upcoming 2020 Advent of Code, written in Swift. In the mean time, I'm enjoying learning Swift by solving earlier AoC problems.

## Using this repository

To preapre a checkout for development, issue the following commands in your favourite terminal.

```
git clone https://github.com/ChampionOfGoats/advent-of-code-2020.git
cd advent-of-code-2020
swift package update
```

If you're a fan, you can create a Xcode-compatible project file. To do so, issue the following command at the root of your checkout.

```
swift package generate-xcodeproj
```

Each solver is implemented by a single class, identifable by the year and date of the problem it pertains to. To execute a solver, issue the following command at the root of your checkout.

```
swift run aoc --year <year> --day <day>
```

Where `<day>` is the solver to run, and `<year>` is the associated event year. For example, issuing the following command will execute the solution for the 1st puzzle of 2020.

```
swift run aoc --year 2020 --day 1
```

## Options

```
USAGE: aoc [--year <year>] [--day <day>] [--verbose] [--both | --first | --second]

OPTIONS:
  -y, --year <year>       The year from which to run a puzzle solver, between 2015 and 2020 inclusive.
                          (default: 2015)
  -d, --day <day>         The day for which to run the puzzle solver, between 1 and 25 inclusive. (default: 1)
  -v, --verbose           Include additional debug information in puzzle solver output. 
  --both                  Run the complete solver. (default: both)
  --first                 Run first half of the solver only. (default: both)
  --second                Run second half of the solver only. (default: both)
  -h, --help              Show help information.
```
