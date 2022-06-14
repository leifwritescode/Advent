package championofgoats.advent

import com.xenomachina.argparser.*
import championofgoats.advent.AdventArgs
import championofgoats.advent.Mirror
import championofgoats.advent.utils.logging.ConsoleLogger

fun main(args: Array<String>) = mainBody {
    val log = ConsoleLogger()
    ArgParser(args).parseInto(::AdventArgs).run {
        Mirror.findProblem(year, day, log)?.apply {
            getOrNull(0)?.apply {
                solve(inputDir, outputDir, log)
            }.also {
                it ?: log.Error("No solution object Day$day was found, exiting.")
            }
        }.also {
            it ?: log.Error("No package was found matching year $year, exiting.")
        }
    }
    log.Debug("Finished")
}
