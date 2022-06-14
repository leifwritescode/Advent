package championofgoats.advent

import com.xenomachina.argparser.*

class AdventArgs(parser: ArgParser) {
    val year by parser.storing(
        "-y", "--year", help = "the year from which to run solutions"
    ) { toInt() } .default(2019)
    val day by parser.storing(
        "-d", "--day", help = "the solution to run"
    ) { toInt() } .default(1)
    val inputDir by parser.storing(
        "-i", "--inputDir", help = "the directory from which to source inputs"
    ) .default("${System.getProperty("user.dir")}/data")
    val outputDir by parser.storing(
        "-o", "--outputDir", help = "the directory in which to store outputs"
    ) .default("${System.getProperty("user.dir")}/data")
}
