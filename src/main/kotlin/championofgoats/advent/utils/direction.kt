package championofgoats.advent.utils

// A structure representing the direction between two points
// $sign is true if the slope is descending, else false
// $nominator/$denominator are the slope
data class Direction(var sign: Boolean, var nominator: Int, var denominator: Int)
