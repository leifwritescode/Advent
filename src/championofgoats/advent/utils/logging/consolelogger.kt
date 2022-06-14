package championofgoats.advent.utils.logging

class ConsoleLogger : Logger {
    override fun Debug(m: String) {
        if (System.getenv().containsKey("DEBUG")) {
            println("[DBG] %s".format(m))
        }
    }

    override fun Info(m: String) {
        println("[INF] %s".format(m))
    }

    override fun Warning(m: String) {
        println("%c[33m[WRN] %s%c[0m".format(27, m, 27))
    }

    override fun Error(m: String) {
        println("%c[31m[ERR] %s%c[0m".format(27, m, 27))
    }

    override fun Solution(m: String) {
        println("%c[32m[SLV] %s%c[0m".format(27, m, 27))
    }
}
