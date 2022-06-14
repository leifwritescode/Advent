package championofgoats.advent.utils

import kotlin.Comparator
import kotlin.comparisons.*

// A structure representing the direction between two points
// $sign is true if the slope is descending, else false
// $nominator/$denominator are the slope
data class Direction(var sign: Boolean, var nominator: Int, var denominator: Int) {
    companion object {
        val comparator: Comparator<Direction> = compareBy<Direction> { d -> d.sign }
        .thenBy { d -> d.denominator != 0 }
        .thenComparator { (_, y1, x1), (_, y2, x2) -> compareValues(y1 * x2, y2 * x1) }
    }
}
