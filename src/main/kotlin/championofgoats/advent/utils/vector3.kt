package championofgoats.advent.utils

import kotlin.math.abs

// A vector in 3d space
data class Vector3(var x: Int, var y: Int, var z: Int) {
    companion object {
        // A vector of zeroes
        val zero: Vector3
            get() = Vector3(0, 0, 0)

        // A vector of ones
        val one: Vector3
            get() = Vector3(1, 1, 1)
    }

    // by vector3
    operator fun plus(other: Vector3) : Vector3 = Vector3(x + other.x, y + other.y, z + other.z)
    operator fun minus(other: Vector3) : Vector3 = Vector3(x - other.x, y - other.y, z - other.z)
    operator fun times(other: Vector3) : Vector3 = Vector3(x * other.x, y * other.y, z * other.z)
    operator fun div(other: Vector3) : Vector3 = Vector3(x / other.x, y / other.y, z / other.z)
    // by scalar
    operator fun plus(other: Int) : Vector3  = Vector3(x + other, y + other, z + other)
    operator fun minus(other: Int) : Vector3  = Vector3(x - other, y - other, z - other)
    operator fun times(other: Int) : Vector3  = Vector3(x * other, y * other, z * other)
    operator fun div(other: Int) : Vector3 = Vector3(x / other, y / other, z / other)

    // The absolute value of a vector
    fun abs() : Vector3 = Vector3(abs(x), abs(y), abs(z))

    // The absolute sum of a vector
    fun absSum() : Int {
        val a = abs()
        return a.x + a.y + a.z
    }
}
