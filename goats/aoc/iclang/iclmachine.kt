package goats.aoc.iclang

import goats.aoc.logging.Logger

// An IntCodeLang (ICLang) computer
// ICLang is a destructive language - each instuction may change the program
class ICLMachine(val log: Logger) {
    // Opcodes
    private enum class Opcode(val op: Int, val nParams: Int) {
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

    // Run an ICLang program
    fun exec(program: List<Int>, inputs: List<Int>) : List<Int> {
        // Given an ICLang op, in integer form, convert to the Opcode representation
        fun parsIclOp(input: Int) : Opcode {
            return Opcode.values().find { it. op == input % 100 } ?: Opcode.ERR
        }

        var memory = program.toMutableList()
        var input = inputs.toMutableList()
        var output = mutableListOf<Int>()
        var ip = 0;
        while (true) {
            val op = parsIclOp(memory[ip])
            val ins = ICLangOp(op,
                (1 until op.nParams).map { memory[ip + it] },
                (memory[ip] / 100).toString().padStart(op.nParams - 1, '0').map { it == '1' }.asReversed(),
                log)
            ip = ins.exec(ip, memory, input, output) ?: return output.toList()
        }
    }

    // A structure representing an ICLang instruction, including it's parameters and their modes
    // Encapsulates the execution functionality of the ICLang computer
    private data class ICLangOp(val op: Opcode, var params: List<Int>, var modes: List<Boolean>, val log: Logger) {
        fun exec(ip : Int, memory: MutableList<Int>, inputs: MutableList<Int>, outputs: MutableList<Int>) : Int? {
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
                    log.Debug("%04d | ADD | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.MUL -> { // c = a * b
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2]] = a * b
                    log.Debug("%04d | MUL | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.WRM -> { // c = [a]
                    memory[params[0]] = inputs.removeAt(0)
                    log.Debug("%04d | WRM | 01 %d".format(ip, params[0]))
                }
                Opcode.RDM -> { // [a] ->
                    var a = fetch(0)
                    outputs.add(a)
                    log.Debug("%04d | RDM | %d -> %d".format(ip, params[0], a))
                }
                Opcode.JNZ -> { // ip = a? -> [b]
                    var a = fetch(0)
                    var b = fetch(1)
                    retval = if (a != 0) b else retval
                    log.Debug("%04d | JNZ | %d %d".format(ip, a, b))
                }
                Opcode.JPZ -> { // ip = !a? -> [b]
                    var a = fetch(0)
                    var b = fetch(1)
                    retval = if (a == 0) b else retval
                    log.Debug("%04d | JPZ | %d %d".format(ip, a, b))
                }
                Opcode.LTN -> { // c = a < b ? 1 : 0
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2]] = if (a < b) 1 else 0
                    log.Debug("%04d | LTN | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.EQL -> { // c = a == b ? 1 : 0
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2]] = if (a == b) 1 else 0
                    log.Debug("%04d | EQL | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.HLT -> { // STOP
                    log.Debug("%04d | HLT | 99".format(ip))
                    return null
                }
                Opcode.ERR -> { // STOP
                    log.Debug("%04d | ERR | 1202".format(ip));
                    return null
                }
            }
            return retval
        }
    }
}
