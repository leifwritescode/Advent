# Advent of Code 2020

This repository contains shall contain my solutions for the upcoming 2020 Advent of Code, written in Swift. In the mean time, I'm enjoying learning Swift by solving earlier AoC problems.

## Using this repository

Just check out, update and go -
```
git clone https://github.com/ChampionOfGoats/advent-of-code-2020.git
cd advent-of-code-2020
swift package update
```
If you're a fan, you can create a compatible xcode package by executing the following statement -
```
swift package generate-xcodeproj
```
Lastly, to run a solver, do -
```
swift run aoc -y <year> -d <day> [-v]
```
Where `<day>` is the solver to run, and `<year>` is the associated event year. For example -
```
swift run aoc -y 2019 -d 1
```
Will run the solution to the 1st puzzle of 2019.

You may also use `-v` to increase output verbosity.
