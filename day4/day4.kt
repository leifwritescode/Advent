import java.io.File
import kotlin.text.Regex

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day4.jar <input file>")
        return
    }

    var dayp1ans = 0
    var dayp2ans = 0

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
                dayp1ans += 1
        }
    }

    println("DAYp1 ans = %d".format(dayp1ans))
    println("DAYp2 ans = %d".format(dayp2ans))
}
