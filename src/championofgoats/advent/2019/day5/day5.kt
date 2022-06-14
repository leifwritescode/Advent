package championofgoats.advent.twentynineteen.day5

import java.io.File
import championofgoats.advent.twentynineteen.utils.iclang.ICLMachine
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day5 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {
        
        // we won't bother checking that the file exists
        var program = File("$inputDir/day5.input")
        .readText()
        .split(',')
        .map { it.toInt() }
        
        val iclm = ICLMachine(log, program)
        var day5p1ans = iclm.exec(listOf(1))
        log.Solution("DAY5p1 ans = %s <%s>".format(day5p1ans.last(), day5p1ans))
        var day5p2ans = iclm.exec(listOf(5))
        log.Solution("DAY5p2 ans = %s <%s>".format(day5p2ans.last(), day5p2ans))
    }
}
