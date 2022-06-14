package championofgoats.advent.twentynineteen.utils.iclang

import championofgoats.advent.utils.logging.Logger

// A 64-bit IntCodeLang (ICLang) computer
// ICLang is a destructive language - each instuction may change the program
class ICLMachine64(val log: Logger, val program: List<Long>, var supportState: Boolean = false, var supportPauseResume: Boolean = false) {
    
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
    get() = (ip == null && lastOp == Opcode.HLT)
    
    // True if the machine is in an error state
    val IsErrored: Boolean
    get() = (ip == null && lastOp == Opcode.ERR) || aborted
    
    // The outputs since execution last started
    // This WILL change between calls to exec!
    private var output = listOf<Long>()
    var Output: List<Long>
    get() = output
    private set(value) { output = value }
    
    // The relative base.
    // This is used by parameter mode 2, and the ARB instruction.
    private var rb = 0
    
    // True if the ICLMachine has been prematurel aborted
    private var aborted = false
    
    // The instruction pointer.
    // If null, the program has halted.
    private var ip: Int? = 0
    
    // Run an ICLang program
    fun exec(inputs: List<Long>): List<Long> {
        // Given an ICLang op, in integer form, convert to the Opcode representation
        fun parsIclOp(input: Long): Opcode {
            return Opcode.values().find { it.op == input % 100 } ?: Opcode.ERR
        }
        
        // Converts from integers to parammode enum
        fun parsePMode(input: Char): ParamMode {
            val pLong = input.toString().toLong()
            return ParamMode.values().find { it.mode == pLong } ?: ParamMode.ERR
        }

        // If we're resuming, and we're stateful, we need to force ourselves out of paused execution
        lastOp = Opcode.ERR
        
        // Get memwriteble copies of everything
        // Including a temporary copy of the program memory, incase we are not stateful
        var tempMemory = memory.toMutableList()
        var input = inputs.toMutableList()
        var output = mutableListOf<Long>()
        
        // Main execution loop - keep going until we pause, for whatever reason, or the application halts
        while (!aborted && !paused() && ip != null) {
            val op = parsIclOp(tempMemory[ip!!])
            val ins = ICLangOp(this, op,
            (1 until op.nParams).map { tempMemory[ip!! + it] },
            (tempMemory[ip!!] / 100).toString().padStart(op.nParams - 1, '0').map { parsePMode(it) }.asReversed())
            
            ip = ins.exec(ip!!, tempMemory, input, output)
            lastOp = op
        }
        
        if (supportState) {
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
        aborted = false
    }
    
    // Abort execution entirely until reset
    private fun abort(m: String) {
        log.Error("$m, aborting")
        aborted = true
    }
    
    // Check if the ICLMachine is paused
    private fun paused(): Boolean {
        return supportPauseResume && lastOp.pauseOnExec
    }
    
    // Opcodes
    private enum class Opcode(val op: Long, val nParams: Int, val pauseOnExec: Boolean = false) {
        ADD(1, 4),
        MUL(2, 4),
        WRM(3, 2),
        RDM(4, 2, true),
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
        POS(0),
        IMM(1),
        REL(2),
        ERR(-1)
    }
    
    // A structure representing an ICLang instruction, including it's parameters and their modes
    // Encapsulates the execution functionality of the ICLang computer
    private data class ICLangOp(val machine: ICLMachine64, val op: Opcode, var params: List<Long>, var modes: List<ParamMode>) {
        fun exec(ip: Int, memory: MutableList<Long>, inputs: MutableList<Long>, outputs: MutableList<Long>): Int? {
            // Fetch a value from memory, respecting the parameter mode
            fun memread(param: Int): Long {
                return when (modes[param]) {
                    ParamMode.POS -> memory[params[param].toInt()]
                    ParamMode.IMM -> params[param]
                    ParamMode.REL -> memory[(machine.rb + params[param]).toInt()]
                    ParamMode.ERR -> {
                        machine.abort("Encountered unexpected parameter mode")
                        return 0L
                    }
                }
            }
            
            // Write a value to memory, respecting the parameter mode
            // Return the address that was written to
            fun memwrite(param: Int, value: Long) : Long {
                when (modes[param]) {
                    ParamMode.POS, ParamMode.IMM -> {
                        memory[params[param].toInt()] = value
                        return params[param]
                    } 
                    ParamMode.REL -> {
                        memory[(machine.rb + params[param]).toInt()] = value
                        return machine.rb + params[param]
                    }
                    ParamMode.ERR -> {
                        machine.abort("Encountered unexpected parameter mode")
                        return 0
                    }
                }
            }
            
            var retval: Int? = ip + op.nParams
            when (op) {
                Opcode.ADD -> { // c = a + b
                    var a = memread(0)
                    var b = memread(1)
                    var c = memwrite(2, a + b)
                    machine.log.Debug("%04d | ADD | %d %d %d".format(ip, a, b, c))
                }
                Opcode.MUL -> { // c = a * b
                    var a = memread(0)
                    var b = memread(1)
                    var c = memwrite(2, a * b)
                    machine.log.Debug("%04d | MUL | %d %d %d".format(ip, a, b, c))
                }
                Opcode.WRM -> { // c = [a]
                    var a = memwrite(0, inputs.removeAt(0))
                    machine.log.Debug("%04d | WRM | 01 %d".format(ip, a))
                }
                Opcode.RDM -> { // [a] ->
                    var a = memread(0)
                    outputs.add(a)
                    machine.log.Debug("%04d | RDM | %d -> %d".format(ip, params[0], a))
                }
                Opcode.JNZ -> { // ip = a? -> [b]
                    var a = memread(0)
                    var b = memread(1)
                    retval = if (a != 0L) b.toInt() else retval
                    machine.log.Debug("%04d | JNZ | %d %d".format(ip, a, b))
                }
                Opcode.JPZ -> { // ip = !a? -> [b]
                    var a = memread(0)
                    var b = memread(1)
                    retval = if (a == 0L) b.toInt() else retval
                    machine.log.Debug("%04d | JPZ | %d %d".format(ip, a, b))
                }
                Opcode.LTN -> { // c = a < b ? 1 : 0
                    var a = memread(0)
                    var b = memread(1)
                    var c = memwrite(2, if (a < b) 1 else 0)
                    machine.log.Debug("%04d | LTN | %d %d %d".format(ip, a, b, c))
                }
                Opcode.EQL -> { // c = a == b ? 1 : 0
                    var a = memread(0)
                    var b = memread(1)
                    var c = memwrite(2, if (a == b) 1 else 0)
                    machine.log.Debug("%04d | EQL | %d %d %d".format(ip, a, b, c))
                }
                Opcode.ARB -> {
                    var a = memread(0)
                    machine.rb += a.toInt()
                    machine.log.Debug("%04d | ARB | %d".format(ip, a))
                }
                Opcode.HLT -> { // STOP
                    machine.log.Debug("%04d | HLT | 99".format(ip))
                    retval = null
                }
                Opcode.ERR -> { // STOP
                    machine.log.Debug("%04d | ERR | 1202".format(ip))
                    machine.abort("Encountered unexpected stop code")
                    retval = null
                }
            }
            return retval
        }
    }
}
