package championofgoats.advent.twentynineteen.utils.iclang

import championofgoats.advent.utils.logging.Logger

// A 64-bit IntCodeLang (ICLang) computer
// ICLang is a destructive language - each instuction may change the program
class ICLMachine64(val log: Logger, val program: List<Long>, var stateful: Boolean = false, var pauseOnOutput: Boolean = false) {

    // The total amount of memory to allocate
    // Abitrary at best
    private val memory_space_bytes = 50000000

    // The machines memory, which can be overwritten
    // The memory is effectively whatever 'memory_space_bytes' is set to bytes long
    // Program starts at 0 and runs until program.size. The rest is 0's.
    private var memory = listOf(program, List<Long>(memory_space_bytes - program.size, { 0L })).flatten()

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
    private var output = listOf<Long>()
    var Output: List<Long>
            get() = output
            private set(value) { output = value }

    // The relative base.
    // This is used by parameter mode 2, and the ARB instruction.
    private var rb = 0

    // The instruction pointer.
    // If null, the program has halted.
    private var ip: Int? = 0

    // Run an ICLang program
    fun exec(inputs: List<Long>): List<Long> {
        // Given an ICLang op, in integer form, convert to the Opcode representation
        fun parsIclOp(input: Long): Opcode {
            return Opcode.values().find { it.op == input % 100 } ?: Opcode.ERR
        }

        fun parsePMode(input: Char): ParamMode {
            val pLong = input.toString().toLong()
            return ParamMode.values().find { it.mode == pLong } ?: ParamMode.POSITIONAL
        }

        // Reset the last op, since this could be a resumption of execution
        lastOp = Opcode.ERR

        // Get writeble copies of everything
        // Including a temporary copy of the program memory, incase we are not stateful
        var tempMemory = memory.toMutableList()
        var input = inputs.toMutableList()
        var output = mutableListOf<Long>()

        // Main execution loop - keep going until we pause, for whatever reason, or the application halts
        while (ip != null && !paused()) {
            val op = parsIclOp(tempMemory[ip!!])
            val ins = ICLangOp(this, op,
                (1 until op.nParams).map { tempMemory[ip!! + it] },
                (tempMemory[ip!!] / 100).toString().padStart(op.nParams - 1, '0').map { parsePMode(it) }.asReversed())

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
        memory = listOf(program, List<Long>(memory_space_bytes - program.size, { 0L })).flatten()
        lastOp = Opcode.ERR
        output = listOf<Long>()
        ip = 0
        rb = 0
    }

    // Check if the ICLMachine is paused
    private fun paused(): Boolean {
        return pauseOnOutput && lastOp == Opcode.RDM
    }

    // Opcodes
    private enum class Opcode(val op: Long, val nParams: Int) {
        ADD(1, 4),
        MUL(2, 4),
        WRM(3, 2),
        RDM(4, 2),
        JNZ(5, 3),
        JPZ(6, 3),
        LTN(7, 4),
        EQL(8, 4),
        ARB(9, 2),
        HLT(99, 1),
        ERR(0, 1)
    }

    // Parameter modes
    private enum class ParamMode(val mode: Long) {
        POSITIONAL(0),
        IMMEDIATE(1),
        RELATIVE(2)
    }

    // A structure representing an ICLang instruction, including it's parameters and their modes
    // Encapsulates the execution functionality of the ICLang computer
    private data class ICLangOp(val machine: ICLMachine64, val op: Opcode, var params: List<Long>, var modes: List<ParamMode>) {
        fun exec(ip: Int, memory: MutableList<Long>, inputs: MutableList<Long>, outputs: MutableList<Long>): Int? {
            // Fetch a value from memory, respecting the parameter mode
            fun fetch(param: Int): Long {
                return when (modes[param]) {
                    ParamMode.POSITIONAL -> memory[params[param].toInt()]
                    ParamMode.IMMEDIATE -> params[param]
                    ParamMode.RELATIVE -> memory[(machine.rb + params[param]).toInt()]
                }
            }

            var retval: Int? = ip + op.nParams
            when (op) {
                Opcode.ADD -> { // c = a + b
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2].toInt()] = a + b
                    machine.log.Debug("%04d | ADD | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.MUL -> { // c = a * b
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2].toInt()] = a * b
                    machine.log.Debug("%04d | MUL | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.WRM -> { // c = [a]
                    memory[params[0].toInt()] = inputs.removeAt(0)
                    machine.log.Debug("%04d | WRM | 01 %d".format(ip, params[0]))
                }
                Opcode.RDM -> { // [a] ->
                    var a = fetch(0)
                    outputs.add(a)
                    machine.log.Debug("%04d | RDM | %d -> %d".format(ip, params[0], a))
                }
                Opcode.JNZ -> { // ip = a? -> [b]
                    var a = fetch(0)
                    var b = fetch(1)
                    retval = if (a != 0L) b.toInt() else retval
                    machine.log.Debug("%04d | JNZ | %d %d".format(ip, a, b))
                }
                Opcode.JPZ -> { // ip = !a? -> [b]
                    var a = fetch(0)
                    var b = fetch(1)
                    retval = if (a == 0L) b.toInt() else retval
                    machine.log.Debug("%04d | JPZ | %d %d".format(ip, a, b))
                }
                Opcode.LTN -> { // c = a < b ? 1 : 0
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2].toInt()] = if (a < b) 1 else 0
                    machine.log.Debug("%04d | LTN | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.EQL -> { // c = a == b ? 1 : 0
                    var a = fetch(0)
                    var b = fetch(1)
                    memory[params[2].toInt()] = if (a == b) 1 else 0
                    machine.log.Debug("%04d | EQL | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.ARB -> {
                    var a = fetch(0)
                    machine.rb += a.toInt() // again, since memory is only int-max large, we can assume a < int-max
                    machine.log.Debug("%04d | ARB | %d".format(ip, a))
                }
                Opcode.HLT -> { // STOP
                    machine.log.Debug("%04d | HLT | 99".format(ip))
                    retval = null
                }
                Opcode.ERR -> { // STOP
                    machine.log.Debug("%04d | ERR | 1202".format(ip))
                    retval = null
                }
            }
            return retval
        }
    }
}
