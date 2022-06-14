package championofgoats.advent.utils.graphs

import kotlin.collections.List
import kotlin.collections.MutableList
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.NotNull

// An undirected graph, where the vertices are names rather than indexes
class UndirectedOneToOneGraphOfStringVertices : Graph<String>{
    // The adjacency table, mapped by vertex
    var edges = hashMapOf<String, String>()
    var adjacents = mapOf<String, List<String>>()
    var log: Logger

    constructor(logger: Logger?) : this(emptyList(), logger)
    constructor(graph: List<String>, logger: Logger?) {
        log = logger.NotNull()
        if (graph.isEmpty())
            return

        graph.forEach {
            it.split(")").let { (v, w) -> addEdge(w, v) }
        }
    }

    override val V: Int get() = adjacents.size
    override val E: Int get() = edges.count()

    override fun adj(v: String) : List<String> = adjacents.getOrDefault(v, listOf())

    override fun path(from: String, to: String) : List<String> = if (to == from) listOf(from) else path(edges.getValue(from), to) + from

    override fun compute(root: String) {
        adjacents = edges.map { (k,_) -> k to path(k, root) }.toMap()
    }

    private fun addEdge(v: String, w: String) {
        if (!edges.containsKey(v)) {
            edges.set(v, w)
        }
    }

}
