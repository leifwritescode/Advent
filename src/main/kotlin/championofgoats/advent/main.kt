package championofgoats.advent

import championofgoats.advent.AdventArgs
import championofgoats.advent.utils.logging.ConsoleLogger
import championofgoats.advent.twentynineteen.day1.Day1
import championofgoats.advent.twentynineteen.day2.Day2
import championofgoats.advent.twentynineteen.day3.Day3
import championofgoats.advent.twentynineteen.day4.Day4
import championofgoats.advent.twentynineteen.day5.Day5
import championofgoats.advent.twentynineteen.day6.Day6
import championofgoats.advent.twentynineteen.day7.Day7
import championofgoats.advent.twentynineteen.day8.Day8

val problems = hashMapOf<Int, Array<Problem>>(
Pair(2019, arrayOf<Problem>(Day1, Day2, Day3, Day4,
Day5, Day6, Day7, Day8))
)


        fun main(args: Array<String>) {
            val adventArgs = AdventArgs()
            if (!adventArgs.parse(args)) {
                println("Usage: java -jar advent.jar -y 2019 -d [0123456789] -i <dir> -o <dir>")
                return
            }
            
            val log = ConsoleLogger()
            val problemsForYear = problems.getOrDefault(adventArgs.year, emptyArray())
            if (!problemsForYear.isNullOrEmpty()) {
                val problem = problemsForYear.getOrNull(adventArgs.day - 1)
                if (problem != null) {
                    problem.solve(adventArgs.inputDir, adventArgs.outputDir, log)
                } else {
                    log.Error("No solution for %d/12/%d, exiting.".format(adventArgs.day, adventArgs.year))
                }
            } else {
                log.Error("No solutions for %d, exiting.".format(adventArgs.year))
            }
        }
