package championofgoats.advent.twentynineteen.day11

import championofgoats.advent.Problem
import championofgoats.advent.twentynineteen.utils.iclang.ICLMachine64
import championofgoats.advent.utils.Point
import championofgoats.advent.utils.logging.Logger
import java.awt.image.BufferedImage
import java.io.File
import javax.imageio.ImageIO

object Day11 : Problem {
    override fun solve(inputDir: String, outputDir: String, log: Logger) {
        val program = listOf(3, 8, 1005, 8, 304, 1106, 0, 11, 0, 0, 0, 104, 1,
        104, 0, 3, 8, 102, -1, 8, 10, 101, 1, 10, 10, 4, 10, 1008, 8, 1, 10,
        4, 10, 1002, 8, 1, 29, 2, 103, 1, 10, 1, 106, 18, 10, 3, 8, 102, -1,
        8, 10, 1001, 10, 1, 10, 4, 10, 1008, 8, 1, 10, 4, 10, 102, 1, 8, 59,
        2, 102, 3, 10, 2, 1101, 12, 10, 3, 8, 102, -1, 8, 10, 1001, 10, 1, 10,
        4, 10, 108, 0, 8, 10, 4, 10, 101, 0, 8, 88, 3, 8, 102, -1, 8, 10, 1001,
        10, 1, 10, 4, 10, 108, 1, 8, 10, 4, 10, 101, 0, 8, 110, 2, 108, 9, 10,
        1006, 0, 56, 3, 8, 102, -1, 8, 10, 1001, 10, 1, 10, 4, 10, 108, 0, 8,
        10, 4, 10, 101, 0, 8, 139, 1, 108, 20, 10, 3, 8, 102, -1, 8, 10, 101,
        1, 10, 10, 4, 10, 108, 0, 8, 10, 4, 10, 102, 1, 8, 165, 1, 104, 9, 10,
        3, 8, 102, -1, 8, 10, 101, 1, 10, 10, 4, 10, 1008, 8, 0, 10, 4, 10,
        1001, 8, 0, 192, 2, 9, 14, 10, 2, 1103, 5, 10, 1, 1108, 5, 10, 3, 8,
        1002, 8, -1, 10, 101, 1, 10, 10, 4, 10, 1008, 8, 1, 10, 4, 10, 102, 1,
        8, 226, 1006, 0, 73, 1006, 0, 20, 1, 1106, 11, 10, 1, 1105, 7, 10, 3,
        8, 102, -1, 8, 10, 1001, 10, 1, 10, 4, 10, 108, 0, 8, 10, 4, 10, 1001,
        8, 0, 261, 3, 8, 102, -1, 8, 10, 101, 1, 10, 10, 4, 10, 108, 1, 8, 10,
        4, 10, 1002, 8, 1, 283, 101, 1, 9, 9, 1007, 9, 1052, 10, 1005, 10, 15,
        99, 109, 626, 104, 0, 104, 1, 21101, 48062899092, 0, 1, 21101, 0, 321,
        0, 1105, 1, 425, 21101, 936995300108, 0, 1, 21101, 0, 332, 0, 1106, 0,
        425, 3, 10, 104, 0, 104, 1, 3, 10, 104, 0, 104, 0, 3, 10, 104, 0, 104, 
        1, 3, 10, 104, 0, 104, 1, 3, 10, 104, 0, 104, 0, 3, 10, 104, 0, 104, 1,
        21102, 209382902951, 1, 1, 21101, 379, 0, 0, 1106, 0, 425, 21102,
        179544747200, 1, 1, 21102, 390, 1, 0, 1106, 0, 425, 3, 10, 104, 0, 104,
        0, 3, 10, 104, 0, 104, 0, 21102, 1, 709488292628, 1, 21102, 1, 413, 0,
        1106, 0, 425, 21101, 0, 983929868648, 1, 21101, 424, 0, 0, 1105, 1,
        425, 99, 109, 2, 22101, 0, -1, 1, 21102, 40, 1, 2, 21102, 456, 1, 3,
        21101, 446, 0, 0, 1106, 0, 489, 109, -2, 2106, 0, 0, 0, 1, 0, 0, 1,
        109, 2, 3, 10, 204, -1, 1001, 451, 452, 467, 4, 0, 1001, 451, 1, 451,
        108, 4, 451, 10, 1006, 10, 483, 1102, 0, 1, 451, 109, -2, 2105, 1, 0,
        0, 109, 4, 1201, -1, 0, 488, 1207, -3, 0, 10, 1006, 10, 506, 21102, 1,
        0, -3, 21202, -3, 1, 1, 21201, -2, 0, 2, 21101, 0, 1, 3, 21101, 525, 0,
        0, 1105, 1, 530, 109, -4, 2105, 1, 0, 109, 5, 1207, -3, 1, 10, 1006,
        10, 553, 2207, -4, -2, 10, 1006, 10, 553, 21202, -4, 1, -4, 1105, 1,
        621, 21201, -4, 0, 1, 21201, -3, -1, 2, 21202, -2, 2, 3, 21102, 1, 572,
        0, 1106, 0, 530, 21201, 1, 0, -4, 21101, 0, 1, -1, 2207, -4, -2, 10,
        1006, 10, 591, 21102, 0, 1, -1, 22202, -2, -1, -2, 2107, 0, -3, 10,
        1006, 10, 613, 22101, 0, -1, 1, 21101, 0, 613, 0, 106, 0, 488, 21202,
        -2, -1, -2, 22201, -4, -2, -4, 109, -5, 2106, 0, 0)

        fun generateRegIdentifier(startingColor: Long): MutableMap<Point, Long> {
            // A look up table of...
            val lookupTable = arrayOf(
                // left turns and...
                mapOf(Direction.UP to Direction.LEFT, Direction.LEFT to Direction.DOWN, Direction.DOWN to Direction.RIGHT, Direction.RIGHT to Direction.UP),
                // right turns
                mapOf(Direction.UP to Direction.RIGHT, Direction.RIGHT to Direction.DOWN, Direction.DOWN to Direction.LEFT, Direction.LEFT to Direction.UP)   
            )
            
            /*algorithm
            * let c = colour of cell, initial 0
            * let p = point of cell, initial (0,0)
            * let d = direction of bot, initial up
            * let m = map of points to colours
            * let o = the singular output of a machine run
            * until the machine halts
            *   execute the machine, input m[p] -> c = o
            *   execute the machine, input m[p] -> d = direction[o][d]
            *   if m contains p
            *       m[p] = c
            *   else
            *       m put (p,c)
            *   p = p + d
            */

            // set everything up
            log.Info("Generating a Registration Identifier.")
            log.Warning("This could take a while...")
            val iclm = ICLMachine64(log, program, true, true)
            var c = startingColor
            var p = Point(0, 0)
            var d = Direction.UP
            var m = mutableMapOf<Point, Long>()
            
            // prime the map
            m.put(p, startingColor)
            while (!iclm.IsHalted) {
                
                // the input for each cycle is the colour of the current tile
                // this will be black (0) unless otherwise set
                var inp = listOf(m.getOrDefault(p, 0))
                
                // execute the bot, receiving the colour to paint
                c = iclm.exec(inp).firstOrNull() ?: 0L
                if (!iclm.IsHalted) {
                    
                    // execute the bot, receiving the direction to turn
                    // 0 is left, 1 is right
                    // this line looks at the lookup table and works out where our next direction to face is
                    // for example, if the output is 0 (turn left) and our direction is UP, our new direction would be LEFT
                    d = lookupTable[iclm.exec(inp).firstOrNull()?.toInt() ?: 0].get(d)!!
                    
                    // we then paint the current tile to the map
                    m.put(p, c)
                    
                    // we then turn to face our new direction, and move one tile
                    p = Point(p.x + d.xOff, p.y + d.yOff)
                    
                    // to debug, let's just drop the size of the map
                    log.Info("Points touched at least once = %d".format(m.size))
                }
            }
            return m
        }
        
        val day11p1ans = generateRegIdentifier(0L).size
        log.Solution("DAY11p1 ans = %d".format(day11p1ans))
        
        val day11p2ans = generateRegIdentifier(1L)
        log.Solution("DAY11p2 ans is an image, and will be dumped to file")
        val w = 40
        val h = 10
        var img = BufferedImage(w, h, BufferedImage.TYPE_INT_RGB)
        val pixels = (1..w * h).map {
            var x = it % w
            var y = it / w
            val p = day11p2ans.getOrDefault(Point(x, y), 0)
            when (p) {
                0L -> 0x000000
                1L -> 0xFFFFFF
                else -> 0xC0C0C0
            }
        }
        
        for (p in 0..w * h - 1) {
            img.setRGB(p % w, p / w, pixels[p])
        }

        ImageIO.write(img, "png", File("$outputDir/day11.png"))
        log.Solution("Done! DAY11p1 ans written to $outputDir/day11.png")
    }
    
    enum class Direction(val xOff: Int, val yOff: Int) {
        UP(0, -1),
        DOWN(0, 1),
        LEFT(-1, 0),
        RIGHT(1, 0)
    }
}
