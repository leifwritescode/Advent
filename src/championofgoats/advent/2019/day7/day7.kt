package championofgoats.advent.twentynineteen.day7

import championofgoats.advent.twentynineteen.utils.iclang.ICLMachine
import championofgoats.advent.utils.logging.ConsoleLogger
import java.io.File
import kotlin.math.*

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day7.jar <input file>")
        return
    }

    // precomputed array of permutations of 0..4 inc. where no repetitions and order is important
    val permutations = arrayOf(
        arrayOf(0, 1, 2, 3, 4), arrayOf(0, 1, 2, 4, 3), arrayOf(0, 1, 3, 2, 4), arrayOf(0, 1, 3, 4, 2),
        arrayOf(0, 1, 4, 2, 3), arrayOf(0, 1, 4, 3, 2), arrayOf(0, 2, 1, 3, 4), arrayOf(0, 2, 1, 4, 3),
        arrayOf(0, 2, 3, 1, 4), arrayOf(0, 2, 3, 4, 1), arrayOf(0, 2, 4, 1, 3), arrayOf(0, 2, 4, 3, 1),
        arrayOf(0, 3, 1, 2, 4), arrayOf(0, 3, 1, 4, 2), arrayOf(0, 3, 2, 1, 4), arrayOf(0, 3, 2, 4, 1),
        arrayOf(0, 3, 4, 1, 2), arrayOf(0, 3, 4, 2, 1), arrayOf(0, 4, 1, 2, 3), arrayOf(0, 4, 1, 3, 2),
        arrayOf(0, 4, 2, 1, 3), arrayOf(0, 4, 2, 3, 1), arrayOf(0, 4, 3, 1, 2), arrayOf(0, 4, 3, 2, 1),
        arrayOf(1, 0, 2, 3, 4), arrayOf(1, 0, 2, 4, 3), arrayOf(1, 0, 3, 2, 4), arrayOf(1, 0, 3, 4, 2),
        arrayOf(1, 0, 4, 2, 3), arrayOf(1, 0, 4, 3, 2), arrayOf(1, 2, 0, 3, 4), arrayOf(1, 2, 0, 4, 3),
        arrayOf(1, 2, 3, 0, 4), arrayOf(1, 2, 3, 4, 0), arrayOf(1, 2, 4, 0, 3), arrayOf(1, 2, 4, 3, 0),
        arrayOf(1, 3, 0, 2, 4), arrayOf(1, 3, 0, 4, 2), arrayOf(1, 3, 2, 0, 4), arrayOf(1, 3, 2, 4, 0),
        arrayOf(1, 3, 4, 0, 2), arrayOf(1, 3, 4, 2, 0), arrayOf(1, 4, 0, 2, 3), arrayOf(1, 4, 0, 3, 2),
        arrayOf(1, 4, 2, 0, 3), arrayOf(1, 4, 2, 3, 0), arrayOf(1, 4, 3, 0, 2), arrayOf(1, 4, 3, 2, 0),
        arrayOf(2, 0, 1, 3, 4), arrayOf(2, 0, 1, 4, 3), arrayOf(2, 0, 3, 1, 4), arrayOf(2, 0, 3, 4, 1),
        arrayOf(2, 0, 4, 1, 3), arrayOf(2, 0, 4, 3, 1), arrayOf(2, 1, 0, 3, 4), arrayOf(2, 1, 0, 4, 3),
        arrayOf(2, 1, 3, 0, 4), arrayOf(2, 1, 3, 4, 0), arrayOf(2, 1, 4, 0, 3), arrayOf(2, 1, 4, 3, 0),
        arrayOf(2, 3, 0, 1, 4), arrayOf(2, 3, 0, 4, 1), arrayOf(2, 3, 1, 0, 4), arrayOf(2, 3, 1, 4, 0),
        arrayOf(2, 3, 4, 0, 1), arrayOf(2, 3, 4, 1, 0), arrayOf(2, 4, 0, 1, 3), arrayOf(2, 4, 0, 3, 1),
        arrayOf(2, 4, 1, 0, 3), arrayOf(2, 4, 1, 3, 0), arrayOf(2, 4, 3, 0, 1), arrayOf(2, 4, 3, 1, 0),
        arrayOf(3, 0, 1, 2, 4), arrayOf(3, 0, 1, 4, 2), arrayOf(3, 0, 2, 1, 4), arrayOf(3, 0, 2, 4, 1),
        arrayOf(3, 0, 4, 1, 2), arrayOf(3, 0, 4, 2, 1), arrayOf(3, 1, 0, 2, 4), arrayOf(3, 1, 0, 4, 2),
        arrayOf(3, 1, 2, 0, 4), arrayOf(3, 1, 2, 4, 0), arrayOf(3, 1, 4, 0, 2), arrayOf(3, 1, 4, 2, 0),
        arrayOf(3, 2, 0, 1, 4), arrayOf(3, 2, 0, 4, 1), arrayOf(3, 2, 1, 0, 4), arrayOf(3, 2, 1, 4, 0),
        arrayOf(3, 2, 4, 0, 1), arrayOf(3, 2, 4, 1, 0), arrayOf(3, 4, 0, 1, 2), arrayOf(3, 4, 0, 2, 1),
        arrayOf(3, 4, 1, 0, 2), arrayOf(3, 4, 1, 2, 0), arrayOf(3, 4, 2, 0, 1), arrayOf(3, 4, 2, 1, 0),
        arrayOf(4, 0, 1, 2, 3), arrayOf(4, 0, 1, 3, 2), arrayOf(4, 0, 2, 1, 3), arrayOf(4, 0, 2, 3, 1),
        arrayOf(4, 0, 3, 1, 2), arrayOf(4, 0, 3, 2, 1), arrayOf(4, 1, 0, 2, 3), arrayOf(4, 1, 0, 3, 2),
        arrayOf(4, 1, 2, 0, 3), arrayOf(4, 1, 2, 3, 0), arrayOf(4, 1, 3, 0, 2), arrayOf(4, 1, 3, 2, 0),
        arrayOf(4, 2, 0, 1, 3), arrayOf(4, 2, 0, 3, 1), arrayOf(4, 2, 1, 0, 3), arrayOf(4, 2, 1, 3, 0),
        arrayOf(4, 2, 3, 0, 1), arrayOf(4, 2, 3, 1, 0), arrayOf(4, 3, 0, 1, 2), arrayOf(4, 3, 0, 2, 1),
        arrayOf(4, 3, 1, 0, 2), arrayOf(4, 3, 1, 2, 0), arrayOf(4, 3, 2, 0, 1), arrayOf(4, 3, 2, 1, 0))

    val program = File(args[0])
        .readText()
        .split(',')
        .map { it.toInt() }

    var day7p1ans = 0

    var logger = ConsoleLogger()
    val iclm = ICLMachine(logger)
    permutations.forEach {
        var out = 0
        it.forEach {
            out = iclm.exec(program, listOf(it, out)).last()
        }
        day7p1ans = max(day7p1ans, out)
    }

    println("DAYp1 ans = %s".format(day7p1ans))
}
