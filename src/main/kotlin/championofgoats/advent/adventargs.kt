package championofgoats.advent

class AdventArgs() {

    var year: Int = 2019
    var day: Int = 1
    var inputDir: String = "src/championofgoats/advent/2019/data"
    var outputDir: String = "src/championofgoats/advent/2019/day1"

    fun parse(args: Array<String>) : Boolean {
        if (args.size == 0 || args.size % 2 != 0)
            return false

        for (i in 0..args.size-1) {
            var cur = args[i]
            when (cur) {
                "-y" -> year = args[i+1].toInt()
                "-d" -> day = args[i+1].toInt()
                "-i" -> inputDir = args[i+1]
                "-o" -> outputDir = args[i+1]
            }
        }

        return true
    }
}
