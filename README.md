# Advent of Code 2019
Solutions in Kotlin

## Usage
```
gradle run -q
```
Will build the project and run the default scenario, which is currently day 1 of 2019.

This is configurable at the command line by specifying arguments in `--args` as below.
```
usage: [-h] [-y YEAR] [-d DAY] [-i INPUTDIR] [-o OUTPUTDIR]

optional arguments:
  -h, --help              show this help message and exit

  -y YEAR, --year YEAR    the year from which to run solutions

  -d DAY, --day DAY       the solution to run

  -i INPUTDIR,            the directory from which to source inputs
  --inputDir INPUTDIR

  -o OUTPUTDIR,           the directory in which to store outputs
  --outputDir OUTPUTDIR
```
For example, consider the following statement
```
gradle run -q --args='-y 2019 -d 8 -o /tmp'
```
This will execute solution 8, from 2019, and direct any file-based outputs to `/temp`.

## Acknowledgements
Thanks to Laurence Gonsalves, authour of the [kotlin-argparser](https://github.com/xenomachina/kotlin-argparser) library.

Thanks to ronmamo, authour of the [reflections](https://github.com/ronmamo/reflections) library.