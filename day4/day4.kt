import java.io.File
import kotlin.text.Regex

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day4.jar <input file>")
        return
    }

    var day4p1ans = 0
    var day4p2ans = 0

    var lowBound = 0
    var highBound = 0
    File(args[0]).forEachLine { 
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

    println("DAY4p1 ans = %d".format(day4p1ans))
    println("DAY4p2 ans = %d".format(day4p2ans))
}
