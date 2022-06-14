package championofgoats.advent.twentynineteen.day1

import java.io.File
import java.util.stream.IntStream
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day1 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {
        // Fuel required is
        // F(m) = (m / 3) - 2 + F((m / 3) - 2)
        // For values of m < 9, F(m) = 0
        fun getFuelRecursive(m: Int) : Int = if (m < 9) 0 else (m / 3) - 2 + getFuelRecursive((m / 3) - 2)
        
        // we won't bother checking that the file exists
        val masses = File("$inputDir/day1.input").readLines().map { it.toInt() }
        log.Solution("DAY1p1 ans = %d".format(masses.sumBy { (it / 3) - 2 }))
        log.Solution("DAY1p2 ans = %d".format(masses.sumBy { getFuelRecursive(it) }))
    }
}