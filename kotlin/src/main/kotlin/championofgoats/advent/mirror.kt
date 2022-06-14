package championofgoats.advent

import org.reflections.Reflections
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger

object Mirror {
    private val years = hashMapOf(
    Pair(2019, "twentynineteen"))
    
    fun findProblem(year: Int, day: Int, log: Logger) : List<Problem>? {
        if (!years.containsKey(year)) {
            log.Warning("No package was found matching year %s.".format(year))
            return null
        }
        
        val rgx = "championofgoats\\.advent\\.%s\\.day%d\\.Day%d".format(years[year], day, day).toRegex()
        val reflector = Reflections("championofgoats.advent.%s".format(years[year]))
        return reflector.getSubTypesOf(Problem::class.java)
        .filter {
            it.name.matches(rgx)
        }
        .mapNotNull {
            it.kotlin.objectInstance
        }
        .sortedBy {
            it.javaClass.simpleName
        }
    }
}
