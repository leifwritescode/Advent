package goats.aoc.logging

class ConsoleLogger : Logger {
    override fun Debug(m: String) {
        if (System.getenv().containsKey("DEBUG")) {
            println("[DBG] %s".format(m))
        }
    }

    override fun Info(m: String) {
        println("[INF] %s".format(m))
    }
}
