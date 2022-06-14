package championofgoats.advent.twentynineteen.day6

import java.io.File
import championofgoats.advent.utils.graphs.*

fun main(args: Array<String>) {

    val graph = UndirectedOneToOneGraphOfStringVertices(File(args[0]).readLines(), null)
    // compute the graph, with COM as the root
    graph.compute("COM")

    val youToCom = graph.path("YOU", "COM").toMutableList()
    val youToSanta  = graph.path("SAN", "COM").toMutableList()
    while(youToCom.first() == youToSanta.first()) { youToCom.removeAt(0); youToSanta.removeAt(0) }

    val day6p1ans = graph.edges.keys.map { graph.path(it, "COM").size - 1 }.sum()
    val day6p2ans = youToCom.size + youToSanta.size - 1

    println("DAY6p1 ans = %d".format(day6p1ans))
    println("DAY6p2 ans = %d".format(day6p2ans))
}
