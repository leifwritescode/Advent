package championofgoats.advent.twentynineteen.day6

import java.io.File
import championofgoats.advent.utils.graphs.UndirectedOneToOneGraphOfStringVertices
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day6 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {
        
    val graph = UndirectedOneToOneGraphOfStringVertices(File("$inputDir/day6.input").readLines(), null)
    // compute the graph, with COM as the root
    graph.compute("COM")

    val youToCom = graph.path("YOU", "COM").toMutableList()
    val youToSanta  = graph.path("SAN", "COM").toMutableList()
    while(youToCom.first() == youToSanta.first()) { youToCom.removeAt(0); youToSanta.removeAt(0) }

    val day6p1ans = graph.edges.keys.map { graph.path(it, "COM").size - 1 }.sum()
    val day6p2ans = youToCom.size + youToSanta.size - 1

    log.Solution("DAY6p1 ans = %d".format(day6p1ans))
    log.Solution("DAY6p2 ans = %d".format(day6p2ans))
    }
}

fun main(args: Array<String>) {
    Day6.solve(
        "src/championofgoats/advent/2019/data",
        "src/championofgoats/advent/2019/day6",
        ConsoleLogger())
}
