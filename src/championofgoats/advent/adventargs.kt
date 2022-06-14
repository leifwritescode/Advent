package championofgoats.advent

import com.xenomachina.argparser.ArgParser

class AdventArgs(parser: ArgParser) {
    val year: Int by parser.storing(
        "-y", "--year", help = "the year from which to run problems")
    val day: Int by parser.storing(
        "-d", "--day", help = "the problem to run")
    val outputDir: String by parser.storing(
        "-o", "--outputDir", help = "the location in which to dump output files")
}
