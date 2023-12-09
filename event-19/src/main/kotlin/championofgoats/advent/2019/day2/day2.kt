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
        var ops = listOf(1,0,0,3,1,1,2,3,1,3,4,3,1,5,0,3,2,13,1,19,1,6,19,23,2,
            23,6,27,1,5,27,31,1,10,31,35,2,6,35,39,1,39,13,43,1,43,9,47,2,47,
            10,51,1,5,51,55,1,55,10,59,2,59,6,63,2,6,63,67,1,5,67,71,2,9,71,
            75,1,75,6,79,1,6,79,83,2,83,9,87,2,87,13,91,1,10,91,95,1,95,13,99,
            2,13,99,103,1,103,10,107,2,107,10,111,1,111,9,115,1,115,2,119,1,9,
            119,0,99,2,0,14,0)
        
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
