package championofgoats.advent.utils

import kotlin.math.abs
import kotlin.math.sign

// A coordinate-space agnostic point in 2D space
data class Point(var x: Int, var y: Int) {
    fun directionTo(other: Point): Direction {
        var out: Direction
        if (this.x == other.x) {
            // the slope is horizontal
            out = Direction(this.y < other.y, 1, 0)
        } else {
            // a / b is the slope
            val a = other.y - this.y
            val b = other.x - this.x
            
            // gcd of (|a|, |b|) lets us simplify
            val c = gcd(abs(a), abs(b))
            
            // extract sign (either -1 or 1)
            val s = (this.x - other.x).sign
            
            // populate
            out = Direction(
            this.x > other.x, // true if negative
            (a / c) * s, // (a / gcd(|a|, |b|)) * sign
            (b / c) * s) // (b / gcd(|a|, |b|)) * sign
        }
        return out
    }
}
