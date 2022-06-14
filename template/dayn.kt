import java.io.File

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day.jar <input file>")
        return
    }

    File(args[0]).forEachLine { 
        // line is 'it'
    }

    var dayp1ans = "0"
    var dayp2ans = "0"

    println("DAYp1 ans = %s".format(dayp1ans))
    println("DAYp2 ans = %s".format(dayp2ans))
}
