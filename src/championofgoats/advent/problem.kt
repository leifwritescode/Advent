package championofgoats.advent

import championofgoats.advent.utils.logging.Logger

interface Problem {
    fun solve(inputDir: String, outputDir: String, log: Logger): Unit
}
