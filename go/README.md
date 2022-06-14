# Advent of Code 2021

Each year I use the Advent of Code event, generously run by Erik Wastl, to learn a new programming language. This year, I'm using it to refresh my memory on, and learn more about, the Go programming language.

You can run the code using `go run ./cmd/aog`. This will execute the first challenge of 2021.

To run additional challenges, run with `-y` and/or `-d` options set, where `y` encodes the year and `d` the day.

Challenges are implemented in the `challenges` package. See [this template](challenges/template.md) for how to add new challenges.

Each challenge has a matching test using the example data given by Eric. The tests can be run per-year using `go test ./challenges/yAAAA`, substituting `AAAA` for your chosen year.
