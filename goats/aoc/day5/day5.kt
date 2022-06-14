package goats.aoc.day5

import java.io.File
import java.util.*

// Opcodes
enum class Opcode(val op: Int, val nParams: Int) {
    ADD(1,4),
    MUL(2,4),
    WRM(3,2),
    RDM(4,2),
    JNZ(5,3),
    JPZ(6,3),
    LTN(7,4),
    EQL(8,4),
    HLT(99,1),
    ERR(0,1)
}

// A structure representing an ICLang instruction, including it's parameters and their modes
// Encapsulates the execution functionality of the ICLang computer
data class ICLangOp(val op: Opcode, var params: List<Int>, var modes: List<Boolean>) {
    fun exec(ip : Int, memory: MutableList<Int>, inputs: MutableList<Int>, outputs: MutableList<Int>) : Int? {
        
        // Wrapper around println that only prints during a debug essions
        fun debug(str: String) {
            if (!System.getenv("DEBUG").isNullOrEmpty()) {
                println(str)
            }
        }

        // Fetch a value from memory, respecting the parameter mode
        fun fetch(param: Int) : Int {
            var retval: Int
            if (modes[param]) {
                retval = params[param] 
            } else { 
                retval = memory[params[param]]
            }
            return retval
        }

        var retval = ip + op.nParams
        when (op) {
            Opcode.ADD -> { // c = a + b
                var a = fetch(0)
                var b = fetch(1)
                memory[params[2]] = a + b
                debug("%04d | ADD | %d %d %d".format(ip, a, b, params[2]))
            }
            Opcode.MUL -> { // c = a * b
                var a = fetch(0)
                var b = fetch(1)
                memory[params[2]] = a * b
                debug("%04d | MUL | %d %d %d".format(ip, a, b, params[2]))
            }
            Opcode.WRM -> { // c = [a]
                memory[params[0]] = inputs.removeAt(0)
                debug("%04d | WRM | 01 %d".format(ip, params[0]))
            }
            Opcode.RDM -> { // [a] ->
                var a = fetch(0)
                outputs.add(a)
                debug("%04d | RDM | %d -> %d".format(ip, params[0], a))
            }
            Opcode.JNZ -> { // ip = a? -> [b]
                var a = fetch(0)
                var b = fetch(1)
                retval = if (a != 0) b else retval
                debug("%04d | JNZ | %d %d".format(ip, a, b))
            }
            Opcode.JPZ -> { // ip = !a? -> [b]
                var a = fetch(0)
                var b = fetch(1)
                retval = if (a == 0) b else retval
                debug("%04d | JPZ | %d %d".format(ip, a, b))
            }
            Opcode.LTN -> { // c = a < b ? 1 : 0
                var a = fetch(0)
                var b = fetch(1)
                memory[params[2]] = if (a < b) 1 else 0
                debug("%04d | LTN | %d %d %d".format(ip, a, b, params[2]))
            }
            Opcode.EQL -> { // c = a == b ? 1 : 0
                var a = fetch(0)
                var b = fetch(1)
                memory[params[2]] = if (a == b) 1 else 0
                debug("%04d | EQL | %d %d %d".format(ip, a, b, params[2]))
            }
            Opcode.HLT -> { // STOP
                debug("%04d | HLT | 99".format(ip))
                return null
            }
            Opcode.ERR -> { // STOP
                debug("%04d | ERR | 1202".format(ip));
                return null
            }
        }
        return retval
    }
}

// Given an ICLang op, in integer form, convert to the Opcode representation
fun parseIcLangOp(input: Int) : Opcode {
    return Opcode.values().find { it. op == input % 100 } ?: Opcode.ERR
}

// Run an ICLang program
fun runProgram(program: List<Int>, inputs: List<Int>) : List<Int> {
    var memory = program.toMutableList()
    var input = inputs.toMutableList()
    var output = mutableListOf<Int>()
    var ip = 0;
    while (true) {
        val op = parseIcLangOp(memory[ip])
        val ins = ICLangOp(op,
            (1 until op.nParams).map { memory[ip + it] },
            (memory[ip] / 100).toString().padStart(op.nParams - 1, '0').map { it == '1' }.asReversed())
        ip = ins.exec(ip, memory, input, output) ?: return output.toList()
    }
}

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day2.jar <input file>")
        return
    }

    // we won't bother checking that the file exists
    var program = File(args[0])
                    .readText()
                    .split(',')
                    .map { it.toInt() }

    var day5p1ans = runProgram(program, listOf(1))
    println("DAY5p1 ans = %s <%s>".format(day5p1ans.last(), day5p1ans))
    var day5p2ans = runProgram(program, listOf(5))
    println("DAY5p2 ans = %s <%s>".format(day5p2ans.last(), day5p2ans))
}
