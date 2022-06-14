package championofgoats.advent
/*
import java.lang.reflect.*
//import org.reflections.Reflections
import championofgoats.advent.Problem
import championofgoats.advent.utils.logging.Logger

object Mirror {
    private val years = hashMapOf(
        Pair(2019, "twentynineteen"))
    
    fun findProblemsFor(year: Int, log: Logger) : List<Problem>? {
        if (!years.containsKey(year)) {
            log.Error("Key %s was not found.".format(year))
            return null
        }

        val rgx = "championofgoats.advent.%s.day[0-9]{2}".format(years[year]).toRegex()
        //val reflector = Reflections("championofgoats.advent.%s".format(years[year]))

        championofgoats.advent.Problem::class.sealedSubclasses

        //return reflector.getSubTypesOf(Problem::class.java)
        //    .filter { it.name.matches(rgx) }
        //    .mapNotNull { it.kotlin.objectInstance }
        //    .sortedBy { it.javaClass.simpleName }
    }
}
 */