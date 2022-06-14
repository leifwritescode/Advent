package championofgoats.advent.utils

// Get the greatest common divisor of two digits
fun gcd(a: Int, b: Int) : Int = if (b == 0) 0 else gcd(b, a % b)

// Get an identity matrix
// Points P where the 1-dimensional index i = (i % size) * size (i % size) have value 1.0
// All other points Q are 0.0
fun identity(size: Int) : List<Double> = (1..size * size).mapIndexed { i, _ -> if (i == (i % size) * size + (i % size)) 1.0 else 0.0 }

// Compute the Gauss-Jordan Elimination inverse matrix of the input
// NB: This function doesn't confirm whether or not a given matrix can be inverted!
fun invertMatrix(size: Int, input: List<Double>) : List<Double> {
    var inMatrix = input.toMutableList() // lhs
    var inverse = identity(size).toMutableList() // rhs

    for (y in 0..size - 1) {
        // project 1D array to 2D
        var rowOff = y * size

        // divisor is the number required to get 1 in our desired position
        var divisor = inMatrix[size * y + y]
        
        // for each value in row[y], divide by $divisor
        for (x in rowOff..(rowOff + size - 1)) {
            inMatrix[x] /= divisor
            inverse[x] /= divisor
        }
        
        // for each subsequent row...
        for (j in 0..size - 1) {

            // that is *not* row[y]
            if (j != y) {
                // The $subtractor is the value such that row[j][y] - $subtractor = 0
                var subtractor = inMatrix[j * size + y]

                // For each value in the row...
                for (k in 0..size- 1) {
                    // f(j,k) = Row[j][k] - ( $subtractor * row[y][k] )
                    inMatrix[j * size + k] = inMatrix[j * size + k] - (subtractor * inMatrix[y * size + k])
                }

                /// For each value in the row...
                for (k in 0..size - 1) {
                    // f(j,k) = Row[j][k] - ( $subtractor * row[y][k] )
                    inverse[j * size + k] = inverse[j * size + k] - (subtractor * inverse[y * size + k])
                }      
            }
        }
    }

    return inverse
}
