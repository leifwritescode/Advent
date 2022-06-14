package championofgoats.advent.twentynineteen.day3

import java.io.File
import java.util.*
import kotlin.collections.*
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger
import championofgoats.advent.utils.logging.ConsoleLogger

object Day3 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger)  {
        // a point in 2D space
        data class Point(val x: Int, val y: Int)
        
        // get the absolute (e.g. non-zero) value of an integer
        fun abs(x: Int) : Int = if (x < 0) x * -1 else x
        
        // compute the rectilinear distance between two points
        fun rectilinearDistance(a: Point, b: Point) : Int = abs(b.x - a.x) + abs(b.y - a.y)
        
        // return a point describing the direction of the edge
        fun getOffset(instruction: String) : Point {
            // instructions take the form [URDL]\d+, e.g. U123
            return when (instruction.first()) {
                'U' -> Point(0, 1)
                'R' -> Point(1, 0)
                'D' -> Point(0, -1)
                'L' -> Point(-1, 0)
                else -> Point(0, 0)
            }
        }
        
        // given a two points describing an edge, append to l all points that are touched by the edge
        // return l
        fun appendEdge(l: MutableList<Point>, origin: Point, instruction: String) : MutableList<Point> {
            var offset = getOffset(instruction)
            var totalPoints = instruction.drop(1).toInt() // the number of steps
            for (i in 1..totalPoints) {
                var p = Point(origin.x + (offset.x * i), origin.y + (offset.y * i))
                l.add(p)
            }
            return l
        }
        
        // read the input, parse to point lists
        var wires = mutableListOf<MutableList<Point>>()
        File("$inputDir/day3.input").forEachLine {
            var edges = it.split(",")
            var wire = mutableListOf<Point>()
            var origin = Point(0, 0)
            for (edge in edges) {
                wire = appendEdge(wire, origin, edge)
                origin = wire.last()
            }
            wires.add(wire)
        }
        
        // create a hashmap, keyed by points
        // initially, populate with each point passed by the first wire
        // do so once for each point, such that each k -> v is k -> 1
        var stepMap = hashMapOf<Point, Int>()
        var hashMap = hashMapOf<Point, Int>()
        var firstWire = wires.get(0)
        for (i in 0..firstWire.size-1) {
            var p = firstWire.get(i)
            if (!hashMap.containsKey(p)) {
                hashMap.set(p, 1)
                // initially, step map value for p is indexOf(p) + 1
                stepMap.set(p, i+1)
            }
        }
        
        // then, for the second wire, increment any points that already appear at least once
        var totalWires = wires.size - 1
        for (w in 1..totalWires) {
            var wire = wires.get(w)
            for (i in 0..wire.size-1) {
                var p = wire.get(i)
                if (hashMap.containsKey(p)) {
                    // v = w if wire not yet counted for p
                    var v = hashMap.getValue(p)
                    if (v == w) {
                        hashMap.set(p, v + 1)
                        var s = stepMap.getValue(p)
                        // each additional point is step map v(p) + indexOf(p) + 1
                        stepMap.set(p, s + i + 1)
                    }
                }
            }
        }
        
        // filter out any values which don't occur at least as many times as there are wires
        var output = hashMap.filterValues { it == wires.size }
        
        // reduce keys to list, sorting ascending by rectilinear distance
        var distances = output.map{ (k,_) -> rectilinearDistance(Point(0, 0), k) }.toMutableList()
        distances.sort()
        
        // filter out any points from steps that don't appear in the output candidates
        // map down to values and sort ascending
        var steps = stepMap.filterKeys{ output.containsKey(it) }.map{ (_,v) -> v }.toMutableList()
        steps.sort()
        
        // first points are closest intersect to origin + closest intersect on wires by distance
        log.Solution("DAY3p1 ans = %s".format(distances.get(0))) 
        log.Solution("DAY3p2 ans = %s".format(steps.get(0)))
    }
}
