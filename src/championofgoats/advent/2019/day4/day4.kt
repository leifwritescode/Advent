package championofgoats.advent.twentynineteen.day4

import java.io.File
import kotlin.text.Regex
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day4 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {
        var day4p1ans = 0
        var day4p2ans = 0
        
        var lowBound = 0
        var highBound = 0
        File("$inputDir/day4.input").forEachLine { 
            var range = it.split("-")
            lowBound = range[0].toInt()
            highBound = range[1].toInt()
        }
        
        // this regex finds pairs of numbers
        var digitPairTest = "(\\d)\\1".toRegex()
        for (i in lowBound..highBound) {
            var cand = i.toString()
            if (digitPairTest.containsMatchIn(cand)) {
                // so if it matches: split it, sort it, join it
                // if the results match, we've got a success!
                var sortTest = (fun (str: String) : String { var toSort = str.toCharArray(); toSort.sort(); return toSort.joinToString(""); })(cand)
                if (cand == sortTest)
                day4p1ans += 1
            }
        }
        
        // this regex finds 
        digitPairTest = "(\\d)(\\1+)".toRegex()
        for (i in lowBound..highBound) {
            var cand = i.toString()
            // find all matches, map down to group value, drop the first group (we don't care about the full match)
            // if the digit appears twice, and only twice, it's a pass
            if (digitPairTest.findAll(cand).any { it.groups.drop(1).mapNotNull { m -> m?.value }.joinToString("").length == 2 }) {
                // this step is the same as for p1
                // if the results match, we've got a success!
                var sortTest = (fun (str: String) : String { var toSort = str.toCharArray(); toSort.sort(); return toSort.joinToString(""); })(cand)
                if (cand == sortTest)
                day4p2ans += 1
            }
        }
        
        log.Solution("DAY4p1 ans = %d".format(day4p1ans))
        log.Solution("DAY4p2 ans = %d".format(day4p2ans))
    }
}

fun main(args: Array<String>) {
    Day4.solve(
    "src/championofgoats/advent/2019/data",
    "src/championofgoats/advent/2019/day4",
    ConsoleLogger())
}
