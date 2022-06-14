package championofgoats.advent.twentynineteen.day8

import java.awt.image.BufferedImage
import java.io.File
import java.nio.file.Paths
import javax.imageio.ImageIO

fun main(args: Array<String>) {
    if (args.size != 1) {
        println("Usage: java -jar day8.jar <input file>")
        return
    }
    
    val width = 25
    val height = 6
    
    var layers = File(args[0]).readText().chunked(width * height)
    val layersSorted = layers.sortedBy { it.count { it == '0' } }
    
    var day8p1ans = layersSorted.first().count { it == '1' } * layersSorted.first().count { it == '2' }
    println("DAY8p1 ans = %s".format(day8p1ans))
    
    /**
    * for part 2, we need to flatten
    * for the purposes of the problem: 0 is black, 1 is white and 2 is transparent
    * the first layer is on the top
    * alg: from 0..count(layers)-1, for each pixel, we need to find the first occurence of a value that is not 0 (and failing that, 0)
    */
    
    var flattened = ""
    for (p in 0..width * height - 1) {
        var pixel = layers.firstOrNull { it.get(p) != '2' }?.get(p) ?: '0'
        flattened += pixel
    }
    
    println("DAY8p2 ans below")
    flattened.chunked(width).forEach {
        println(it)
    }
    
    if (System.getenv().containsKey("DEBUG")) {
        println("DAY8p2 ans dumping to file")
        var img = BufferedImage(width, height, BufferedImage.TYPE_INT_RGB)
        val pixels = flattened.map {
            when (it) {
                '0' -> 0x000000
                '1' -> 0xFFFFFF
                '2' -> 0xA9A9A9 // rather than transparent, print a light-ish grey
                else -> 0xC0C0C0 // noise
            }
        }
        
        for (p in 0..width * height - 1) {
            img.setRGB(p % width, p / width, pixels[p])
        }
        
        var out = File("%s/src/championofgoats/advent/2019/day8/day8.png".format(Paths.get("").toAbsolutePath().toString()))
        ImageIO.write(img, "png", out)
    }
}
