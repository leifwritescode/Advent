package championofgoats.advent.twentynineteen.day12

import championofgoats.advent.Problem
import championofgoats.advent.utils.MutablePair
import championofgoats.advent.utils.Vector3
import championofgoats.advent.utils.logging.Logger

object Day12 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger) {

        // The moons to simulate, as a zero-index list of pairs of their position and current velocity
        var moons = listOf(
            MutablePair(Vector3(-6, -5, -8), Vector3.zero),    // Io
            MutablePair(Vector3(0, -3, -13), Vector3.zero),    // Europa
            MutablePair(Vector3(-15, 10, -11), Vector3.zero),  // Ganymede
            MutablePair(Vector3(-3, -8, 3), Vector3.zero)      // Callisto
        )

        // The moons to simulate, as a zero-index list of pairs of moons to apply gravity to
        var pairs = listOf(
            Pair(0, 1), // Io       -> Europa
            Pair(0, 2), // Io       -> Ganymede
            Pair(0, 3), // Io       -> Callisto
            Pair(1, 2), // Europa   -> Ganymede
            Pair(1, 3), // Europa   -> Callisto
            Pair(2, 3)  // Ganymede -> Callisto
        )

        fun determineGravitationalPull(a: Vector3, b: Vector3) : Vector3 {
            // For each axis, if the position of a < b then +1 else -1
            return Vector3(
                a.x.compareTo(b.x),
                a.y.compareTo(b.y),
                a.z.compareTo(b.z))
        }

        fun applyGravityToVelocity(pair: Pair<Int, Int>) {
            // determine the pull for each moon
            val gravity = determineGravitationalPull(moons[pair.first].first, moons[pair.second].first)

            // apply pull to velocity
            moons[pair.first].second = moons[pair.first].second - gravity
            moons[pair.second].second = moons[pair.second].second + gravity
        }

        fun applyVelocityToPosition(moon: Int) {
            // new position of the moon is the position + the velocity
            moons[moon].first = moons[moon].first + moons[moon].second
        }

        fun applyGravity() {
            for (p in pairs) {
                applyGravityToVelocity(p)
            }

            for (p in 1..moons.size) {
                applyVelocityToPosition(p - 1)
            }
        }

        // do 1000 time steps
        (1..1000).forEach { applyGravity() }

        // then find the sum of the total energy
        var totalEnergyInSystem = 0
        moons.forEach { m ->
            var a = m.first.absSum()
            var b = m.second.absSum()
            totalEnergyInSystem += a * b
        }

        // Initial answer is 768975672, which was too high.
        log.Solution("DAY12p1 ans = %d".format(totalEnergyInSystem))
    }
}
