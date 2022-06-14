package championofgoats.advent.twentynineteen.day7

import java.io.File
import kotlin.math.*
import championofgoats.advent.twentynineteen.utils.iclang.ICLMachine
import championofgoats.advent.utils.logging.ConsoleLogger

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day7.jar <input file>")
        return
    }

    // precomputed array of permutations of 0..4 inc. where no repetitions and order is important
    val permutationsPart1 = listOf(
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

    // precomputed array of permutations of 5..9 inc. where no repetitions and order is important
    val permutationsPart2 = listOf(
        arrayOf(5, 6, 7, 8, 9), arrayOf(5, 6, 7, 9, 8), arrayOf(5, 6, 8, 7, 9), arrayOf(5, 6, 8, 9, 7),
        arrayOf(5, 6, 9, 7, 8), arrayOf(5, 6, 9, 8, 7), arrayOf(5, 7, 6, 8, 9), arrayOf(5, 7, 6, 9, 8),
        arrayOf(5, 7, 8, 6, 9), arrayOf(5, 7, 8, 9, 6), arrayOf(5, 7, 9, 6, 8), arrayOf(5, 7, 9, 8, 6),
        arrayOf(5, 8, 6, 7, 9), arrayOf(5, 8, 6, 9, 7), arrayOf(5, 8, 7, 6, 9), arrayOf(5, 8, 7, 9, 6),
        arrayOf(5, 8, 9, 6, 7), arrayOf(5, 8, 9, 7, 6), arrayOf(5, 9, 6, 7, 8), arrayOf(5, 9, 6, 8, 7),
        arrayOf(5, 9, 7, 6, 8), arrayOf(5, 9, 7, 8, 6), arrayOf(5, 9, 8, 6, 7), arrayOf(5, 9, 8, 7, 6),
        arrayOf(6, 5, 7, 8, 9), arrayOf(6, 5, 7, 9, 8), arrayOf(6, 5, 8, 7, 9), arrayOf(6, 5, 8, 9, 7),
        arrayOf(6, 5, 9, 7, 8), arrayOf(6, 5, 9, 8, 7), arrayOf(6, 7, 5, 8, 9), arrayOf(6, 7, 5, 9, 8),
        arrayOf(6, 7, 8, 5, 9), arrayOf(6, 7, 8, 9, 5), arrayOf(6, 7, 9, 5, 8), arrayOf(6, 7, 9, 8, 5),
        arrayOf(6, 8, 5, 7, 9), arrayOf(6, 8, 5, 9, 7), arrayOf(6, 8, 7, 5, 9), arrayOf(6, 8, 7, 9, 5),
        arrayOf(6, 8, 9, 5, 7), arrayOf(6, 8, 9, 7, 5), arrayOf(6, 9, 5, 7, 8), arrayOf(6, 9, 5, 8, 7),
        arrayOf(6, 9, 7, 5, 8), arrayOf(6, 9, 7, 8, 5), arrayOf(6, 9, 8, 5, 7), arrayOf(6, 9, 8, 7, 5),
        arrayOf(7, 5, 6, 8, 9), arrayOf(7, 5, 6, 9, 8), arrayOf(7, 5, 8, 6, 9), arrayOf(7, 5, 8, 9, 6),
        arrayOf(7, 5, 9, 6, 8), arrayOf(7, 5, 9, 8, 6), arrayOf(7, 6, 5, 8, 9), arrayOf(7, 6, 5, 9, 8),
        arrayOf(7, 6, 8, 5, 9), arrayOf(7, 6, 8, 9, 5), arrayOf(7, 6, 9, 5, 8), arrayOf(7, 6, 9, 8, 5),
        arrayOf(7, 8, 5, 6, 9), arrayOf(7, 8, 5, 9, 6), arrayOf(7, 8, 6, 5, 9), arrayOf(7, 8, 6, 9, 5),
        arrayOf(7, 8, 9, 5, 6), arrayOf(7, 8, 9, 6, 5), arrayOf(7, 9, 5, 6, 8), arrayOf(7, 9, 5, 8, 6),
        arrayOf(7, 9, 6, 5, 8), arrayOf(7, 9, 6, 8, 5), arrayOf(7, 9, 8, 5, 6), arrayOf(7, 9, 8, 6, 5),
        arrayOf(8, 5, 6, 7, 9), arrayOf(8, 5, 6, 9, 7), arrayOf(8, 5, 7, 6, 9), arrayOf(8, 5, 7, 9, 6),
        arrayOf(8, 5, 9, 6, 7), arrayOf(8, 5, 9, 7, 6), arrayOf(8, 6, 5, 7, 9), arrayOf(8, 6, 5, 9, 7),
        arrayOf(8, 6, 7, 5, 9), arrayOf(8, 6, 7, 9, 5), arrayOf(8, 6, 9, 5, 7), arrayOf(8, 6, 9, 7, 5),
        arrayOf(8, 7, 5, 6, 9), arrayOf(8, 7, 5, 9, 6), arrayOf(8, 7, 6, 5, 9), arrayOf(8, 7, 6, 9, 5),
        arrayOf(8, 7, 9, 5, 6), arrayOf(8, 7, 9, 6, 5), arrayOf(8, 9, 5, 6, 7), arrayOf(8, 9, 5, 7, 6),
        arrayOf(8, 9, 6, 5, 7), arrayOf(8, 9, 6, 7, 5), arrayOf(8, 9, 7, 5, 6), arrayOf(8, 9, 7, 6, 5),
        arrayOf(9, 5, 6, 7, 8), arrayOf(9, 5, 6, 8, 7), arrayOf(9, 5, 7, 6, 8), arrayOf(9, 5, 7, 8, 6),
        arrayOf(9, 5, 8, 6, 7), arrayOf(9, 5, 8, 7, 6), arrayOf(9, 6, 5, 7, 8), arrayOf(9, 6, 5, 8, 7),
        arrayOf(9, 6, 7, 5, 8), arrayOf(9, 6, 7, 8, 5), arrayOf(9, 6, 8, 5, 7), arrayOf(9, 6, 8, 7, 5),
        arrayOf(9, 7, 5, 6, 8), arrayOf(9, 7, 5, 8, 6), arrayOf(9, 7, 6, 5, 8), arrayOf(9, 7, 6, 8, 5),
        arrayOf(9, 7, 8, 5, 6), arrayOf(9, 7, 8, 6, 5), arrayOf(9, 8, 5, 6, 7), arrayOf(9, 8, 5, 7, 6),
        arrayOf(9, 8, 6, 5, 7), arrayOf(9, 8, 6, 7, 5), arrayOf(9, 8, 7, 5, 6), arrayOf(9, 8, 7, 6, 5))

    val program = File(args[0])
        .readText()
        .split(',')
        .map { it.toInt() }

    var day7p1ans = 0
    var day7p2ans = 0

    var logger = ConsoleLogger()
    val iclm = listOf(
        ICLMachine(logger, program),
        ICLMachine(logger, program),
        ICLMachine(logger, program),
        ICLMachine(logger, program),
        ICLMachine(logger, program))

    permutationsPart1.forEach {
        var out = 0
        for (s in 0..4) {
            out = iclm[s].exec(listOf(it[s], out)).last()
        }
        day7p1ans = max(day7p1ans, out)
    }

    logger.Info("DAY7p1 ans = %d".format(day7p1ans))

    // We now need the machines to be stateful.
    // We also need them to wait on each output.
    // Let's change modes, and reset them
    iclm.forEach {
        it.stateful = true
        it.pauseOnOutput = true
        it.reset()
    }

    permutationsPart2.forEach {
        logger.Debug("Processing %s".format(it.toString()))

        // Prime the machines with their phase
        // Input is the previous machines last output
        // The exception to this rule is that, exactly once, the first machine gets 0 as its input.
        iclm[0].exec(listOf(it[0], 0))
        for (s in 1..4) {
            logger.Debug("Executing Initial Phase %d".format(s))
            iclm[s].exec(listOf(it[s], iclm[s - 1].Output.last()))
        }

        // Then, loop until the final machine halts
        // Each machine will pause each time it outputs
        // In that instance, we process the next machine until it pauses and so on
        var cycle = 0
        while (!iclm.last().IsHalted) {
            ++cycle
            for (s in 0..4) {
                var sin = if (s == 0) iclm.last().Output.last() else iclm[s-1].Output.last()
                logger.Debug("Executing Phase %d (cycle=%d, input=%d)".format(s, cycle, sin))
                iclm[s].exec(listOf(sin))
            }
        }

        day7p2ans = max(day7p2ans, iclm.last().Output.last())
        iclm.forEach { it.reset() }
    }

    logger.Info("DAY7p2 ans = %d".format(day7p2ans))
}
