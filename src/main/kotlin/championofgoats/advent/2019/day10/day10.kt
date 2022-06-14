package championofgoats.advent.twentynineteen.day10

import java.io.File
import kotlin.sequences.*
import championofgoats.advent.Problem
import championofgoats.advent.utils.Direction
import championofgoats.advent.utils.Point
import championofgoats.advent.utils.logging.Logger

object Day10 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger) {
        // Extract a list of all asteroid locations, then
        val lines = File("$inputDir/day10.input").readText().lines()
        
        /** Part 1 solution
         * For each line s at y, and for each character c at x on that line, if c is # then store Point(x, y), else do nothing
         * Map point p with the list of astroids (sans p) grouped by their direction from p
         * Of those maps generated, take the largest
         * Output is, ideally, Pair<Point, Map<Direction, List<Point>>>
         */
        var candidates = lines.withIndex()
        .flatMap {
            (y, s) -> s.withIndex().mapNotNull { 
                (x, c) ->if (c == '#') Point(x, y) else null
            }
        }
        val asteroid = candidates.map {
            p -> candidates.filter { 
                q -> p != q
            }
            .groupBy {
                k -> p.directionTo(k)
            }
        }
        .sortedByDescending {
            it.size
        }
        .first()

        log.Solution("DAY10p1 ans = %d".format(asteroid.size))

        /** part 2 solution
         * Take the best map, A, and sort its keys by direction clockwise ascending
         * Then, perform a round robin eliminaton:
         *      Reduce A down to a map M of iterators for each direction
         *      While M is not an empty map, take an iterator over M Ia.
         *      While Ia is not empty, take the next iterator Ib.
         *      If Ib is not empty, yield the next item, else remove it from Ia.
         * The result is the sequence of asteroids in the order they would be destroyed by the laser.
         */
         var destroyed = mutableListOf<Point>()
         val iterA = asteroid.toSortedMap(Direction.comparator).values.map { it.iterator() }.toMutableList().iterator()
         while (iterA.hasNext()) {
             val iterB = iterA.next()
             if (iterB.hasNext()) {
                 destroyed.add(iterB.next())
             } else {
                 iterA.remove()
             }
         }

         destroyed.get(199).apply {
            log.Solution("DAY10p2 ans = %d".format(100 * x + y))
         }
    }
}
