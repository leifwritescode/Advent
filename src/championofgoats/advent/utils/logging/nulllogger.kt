package championofgoats.advent.utils.logging

class NullLogger : Logger {
    override fun Debug(m: String) { }
    override fun Info(m: String) { }
}

fun Logger?.NotNull(): Logger = if (this == null) NullLogger() else this
