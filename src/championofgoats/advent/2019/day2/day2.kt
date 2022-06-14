package championofgoats.advent.twentynineteen.day2

import java.io.File
import java.util.*
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day2 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {   
        fun intcodeComputer(ops : MutableList<Int>) : Int {
            // program counter
            var pc = 0
            var pcshift = 4
            while (pc != -1 && ops[pc] != 99) {
                var pos1 = ops[pc + 1]
                var pos2 = ops[pc + 2]
                var pos3 = ops[pc + 3]
                
                when (ops[pc]) {
                    1 -> {
                        ops.set(pos3, ops.get(pos1) + ops.get(pos2))
                    }
                    2 -> {
                        ops.set(pos3, ops.get(pos1) * ops.get(pos2))
                    }
                    else -> {
                        // alarm - move pc to -1
                        pcshift = (pc * -1) -1
                    }  
                }
                pc += pcshift
            }
            return ops.get(0)
        }
        
        // we won't bother checking that the file exists
        var ops = File("$inputDir/day2.input")
        .readText()
        .split(',')
        .map { it.trim().toInt() }
        
        var day2p1ops = ops.toMutableList()
        day2p1ops.set(1, 12)
        day2p1ops.set(2, 2)
        var output = intcodeComputer(day2p1ops)
        log.Solution("DAY2p1 ans = %d".format(output))
        
        for (noun in 0..99) {
            for (verb in 0..99) {
                var day2p2ops = ops.toMutableList()
                day2p2ops.set(1, noun)
                day2p2ops.set(2, verb)
                output = intcodeComputer(day2p2ops)
                if (output == 19690720) {
                    log.Solution("DAY2p2 ans = %d".format((100 * noun) + verb))
                    return
                }
            }
        }
    }
}

fun main(args: Array<String>) {
    Day2.solve(
    "src/championofgoats/advent/2019/data",
    "src/championofgoats/advent/2019/day2",
    ConsoleLogger())
}
