package championofgoats.advent.twentynineteen.utils.iclang

import championofgoats.advent.utils.logging.Logger

// An IntCodeLang (ICLang) computer
// ICLang is a destructive language - each instuction may change the program
class ICLMachine(val log: Logger, val program: List<Int>, var stateful: Boolean = false, var pauseOnOutput: Boolean = false) {

    // The machines memory, which can be overwritten
    private var memory = program

    // The last op that was executed. Default is ERR
    private var lastOp = Opcode.ERR

    // True if the machine has halted
    val IsHalted: Boolean
            get() = ip == null && lastOp == Opcode.HLT

    // True if the machine is in an error state
    val IsErrored: Boolean
            get() = ip == null && lastOp == Opcode.ERR

    // The outputs since execution last started
    // This WILL change between calls to exec!
    private var output = listOf<Int>()
    var Output: List<Int>
            get() = output
            private set(value) { output = value }

    // The instruction pointer.
    // If null, the program has halted.
    private var ip: Int? = 0

    // Run an ICLang program
    fun exec(inputs: List<Int>): List<Int> {
        // Given an ICLang op, in integer form, convert to the Opcode representation
        fun parsIclOp(input: Int): Opcode {
            return Opcode.values().find { it.op == input % 100 } ?: Opcode.ERR
        }

        // Reset the last op, since this could be a resumption of execution
        lastOp = Opcode.ERR

        // Get writeble copies of everything
        // Including a temporary copy of the program memory, incase we are not stateful
        var tempMemory = memory.toMutableList()
        var input = inputs.toMutableList()
        var output = mutableListOf<Int>()

        // Main execution loop - keep going until we pause, for whatever reason, or the application halts
        while (ip != null && !paused()) {
            val op = parsIclOp(tempMemory[ip!!])
            val ins = ICLangOp(op,
                (1 until op.nParams).map { tempMemory[ip!! + it] },
                (tempMemory[ip!!] / 100).toString().padStart(op.nParams - 1, '0').map { it == '1' }.asReversed(),
                log)

            ip = ins.exec(ip!!, tempMemory, input, output)
            lastOp = op
        }

        if (stateful) {
            // A stateful ICLMachine needs to be updated
            memory = tempMemory
        } else {
            // A normal ICLMachine needs to be reset after execution
            reset()
        }

        // In both stateful and non-stateful modes, we should only update the output if it changed
        if (output.isNotEmpty()) {
            Output = output
        }

        return output
    }

    // Reset the machine back to its 'default' state
    fun reset() {
        memory = program
        lastOp = Opcode.ERR
        output = listOf<Int>()
        ip = 0
    }

    // Check if the ICLMachine is paused
    private fun paused(): Boolean {
        return pauseOnOutput && lastOp == Opcode.RDM
    }

    // Opcodes
    enum class Opcode(val op: Int, val nParams: Int) {
        ADD(1, 4),
        MUL(2, 4),
        WRM(3, 2),
        RDM(4, 2),
        JNZ(5, 3),
        JPZ(6, 3),
        LTN(7, 4),
        EQL(8, 4),
        HLT(99, 1),
        ERR(0, 1)
    }

    // A structure representing an ICLang instruction, including it's parameters and their modes
    // Encapsulates the execution functionality of the ICLang computer
    private data class ICLangOp(val op: Opcode, var params: List<Int>, var modes: List<Boolean>, val log: Logger) {
        fun exec(ip: Int, memory: MutableList<Int>, inputs: MutableList<Int>, outputs: MutableList<Int>): Int? {
            // Fetch a value from memory, respecting the parameter mode
            fun fetch(param: Int): Int {
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
                    log.Debug("%04d | ERR | 1202".format(ip))
                    return null
                }
            }
            return retval
        }
    }
}
