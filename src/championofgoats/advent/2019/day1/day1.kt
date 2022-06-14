package championofgoats.advent.twentynineteen.day1

import java.io.File
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day1 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {
        // fuel for module of mass m is (m/3)-2
        fun getFuel(mass: Int) : Int =  (mass / 3) - 2
        
        // fuel for module of mass m is (m/3)-2
        // this function recursively computes the fuel required to carry the fuel
        // the minimum value of m for which (m/3)-2 > 0 is 9, which will be our break value
        fun getFuelRecursive(mass: Int) : Int {
            if (mass < 9)
                return 0
        
            var m = (mass / 3) - 2
            return m + getFuelRecursive(m)
        }

        //if (args.size != 1) {
        //    println("Usage: java -jar day1.jar <input file>")
        //    return
        //}
    
        var fuelNeededPartA = 0
        var fuelNeededPartB = 0;
    
        // we won't bother checking that the file exists
        File("$inputDir/day1.input").forEachLine {
            fuelNeededPartA += getFuel(it.toInt())
            fuelNeededPartB += getFuelRecursive(it.toInt())
        }
    
        log.Solution("DAY1p1 ans = %d".format(fuelNeededPartA))
        log.Solution("DAY1p2 ans = %d".format(fuelNeededPartB))
    }
}
