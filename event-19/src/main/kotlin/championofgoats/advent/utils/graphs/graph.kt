package championofgoats.advent.utils.graphs

import kotlin.collections.List

// A graph
interface Graph<T> {
    // Gets the number of vertices in the graph
    val V: Int
    
    // Gets the number of edges in the graph
    val E: Int

    // Gets a list of all vertices adjacent to, e.g. sharing an edge with, 'v'
    fun adj(v: T): List<T>

    // Generates the list of vertices between 'from' and 'to', inclusive
    fun path(from: T, to: T): List<T>

    // Compute the graph, relative to a given 'root' vertex
    fun compute(root: String): Unit
}
