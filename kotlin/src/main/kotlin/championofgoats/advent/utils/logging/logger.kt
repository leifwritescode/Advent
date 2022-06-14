package championofgoats.advent.utils.logging

interface Logger {
    fun Debug(m: String)
    fun Info(m: String)
    fun Warning(m: String)
    fun Error(m: String)
    fun Solution(m: String)
}
