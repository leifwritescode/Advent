package championofgoats.advent.twentynineteen.day5

import java.io.File
import championofgoats.advent.twentynineteen.utils.iclang.ICLMachine
import championofgoats.advent.utils.logging.ConsoleLogger

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day2.jar <input file>")
        return
    }

    // we won't bother checking that the file exists
    var program = File(args[0])
                    .readText()
                    .split(',')
                    .map { it.toInt() }

    val log = ConsoleLogger()
    val iclm = ICLMachine(log)
    var day5p1ans = iclm.exec(program, listOf(1))
    log.Info("DAY5p1 ans = %s <%s>".format(day5p1ans.last(), day5p1ans))
    var day5p2ans = iclm.exec(program, listOf(5))
    log.Info("DAY5p2 ans = %s <%s>".format(day5p2ans.last(), day5p2ans))
}
