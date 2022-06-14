package championofgoats.advent.twentynineteen.utils.iclang

import championofgoats.advent.utils.logging.Logger

// An IntCodeLang (ICLang) computer
// ICLang is a destructive language - each instuction may change the program
class ICLMachine(val log: Logger, val program: List<Int>, var supportState: Boolean = false, var supportPauseResume: Boolean = false) {
    
    // The machines memory, which can be overwritten
    private var memory = program
    
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
    private var output = listOf<Int>()
    var Output: List<Int>
    get() = output
    private set(value) { output = value }
    
    // True if the ICLMachine has been prematurel aborted
    private var aborted = false
    
    // The instruction pointer.
    // If null, the program has halted.
    private var ip: Int? = 0
    
    // Run an ICLang program
    fun exec(inputs: List<Int>): List<Int> {
        // If we're resuming, and we're stateful, we need to force ourselves out of paused execution
        lastOp = Opcode.ERR
        
        // Get writeble copies of everything
        // Including a temporary copy of the program memory, incase we are not stateful
        var tempMemory = memory.toMutableList()
        var input = inputs.toMutableList()
        var output = mutableListOf<Int>()
        
        // Main execution loop - keep going until we pause, for whatever reason, or the application halts
        while (!aborted && !paused() && ip != null) {
            // Given an ICLang op, in integer form, convert to the Opcode representation
            val op = tempMemory[ip!!].let { val i = it; Opcode.values().find { it.op == i % 100 } ?: Opcode.ERR }
            val ins = ICLangOp(this, op,
            (1 until op.nParams).map { tempMemory[ip!! + it] },
            // Take the params (first three digits), separate, map to ParamModes
            (tempMemory[ip!!] / 100).let { listOf<Int>(it % 10, (it / 10) % 10, it / 100).map { val i = it; ParamMode.values().find { it.mode == i } ?: ParamMode.ERR }})
            
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
        memory = program
        lastOp = Opcode.ERR
        output = listOf<Int>()
        ip = 0
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
    enum class Opcode(val op: Int, val nParams: Int, val pauseOnExec: Boolean = false) {
        ADD(1, 4),
        MUL(2, 4),
        WRM(3, 2),
        RDM(4, 2, true),
        JNZ(5, 3),
        JPZ(6, 3),
        LTN(7, 4),
        EQL(8, 4),
        HLT(99, 1),
        ERR(0, 1)
    }
    
    // Parameter modes
    private enum class ParamMode(val mode: Int) {
        POS(0),
        IMM(1),
        ERR(-1)
    }
    
    // A structure representing an ICLang instruction, including it's parameters and their modes
    // Encapsulates the execution functionality of the ICLang computer
    private data class ICLangOp(val machine: ICLMachine, val op: Opcode, var params: List<Int>, var modes: List<ParamMode>) {
        fun exec(ip: Int, memory: MutableList<Int>, inputs: MutableList<Int>, outputs: MutableList<Int>): Int? {
            // Fetch a value from memory, respecting the parameter mode
            fun memread(param: Int): Int {
                return when (modes[param]) {
                    ParamMode.POS -> memory[params[param].toInt()]
                    ParamMode.IMM -> params[param]
                    ParamMode.ERR -> {
                        machine.abort("Encountered unexpected parameter mode")
                        return 0
                    }
                }
            }
            
            // Write a value to memory, respecting the parameter mode
            fun memwrite(param: Int, value: Int) {
                when (modes[param]) {
                    ParamMode.POS, ParamMode.IMM -> memory[params[param]] = value
                    ParamMode.ERR -> machine.abort("Encountered unexpected parameter mode")
                }
            }
            
            var retval: Int? = ip + op.nParams
            when (op) {
                Opcode.ADD -> { // c = a + b
                    var a = memread(0)
                    var b = memread(1)
                    memwrite(2, a + b)
                    machine.log.Debug("%04d | ADD | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.MUL -> { // c = a * b
                    var a = memread(0)
                    var b = memread(1)
                    memwrite(2, a * b)
                    machine.log.Debug("%04d | MUL | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.WRM -> { // c = [a]
                    memwrite(0, inputs.removeAt(0))
                    machine.log.Debug("%04d | WRM | 01 %d".format(ip, params[0]))
                }
                Opcode.RDM -> { // [a] ->
                    var a = memread(0)
                    outputs.add(a)
                    machine.log.Debug("%04d | RDM | %d -> %d".format(ip, params[0], a))
                }
                Opcode.JNZ -> { // ip = a? -> [b]
                    var a = memread(0)
                    var b = memread(1)
                    retval = if (a != 0) b else retval
                    machine.log.Debug("%04d | JNZ | %d %d".format(ip, a, b))
                }
                Opcode.JPZ -> { // ip = !a? -> [b]
                    var a = memread(0)
                    var b = memread(1)
                    retval = if (a == 0) b else retval
                    machine.log.Debug("%04d | JPZ | %d %d".format(ip, a, b))
                }
                Opcode.LTN -> { // c = a < b ? 1 : 0
                    var a = memread(0)
                    var b = memread(1)
                    memwrite(2, if (a < b) 1 else 0)
                    machine.log.Debug("%04d | LTN | %d %d %d".format(ip, a, b, params[2]))
                }
                Opcode.EQL -> { // c = a == b ? 1 : 0
                    var a = memread(0)
                    var b = memread(1)
                    memwrite(2, if (a == b) 1 else 0)
                    machine.log.Debug("%04d | EQL | %d %d %d".format(ip, a, b, params[2]))
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
