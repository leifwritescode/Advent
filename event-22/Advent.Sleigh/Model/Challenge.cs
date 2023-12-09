using System.ComponentModel.DataAnnotations;

namespace Advent.Sleigh.Model;

public class Challenge
{
    [Required]
    public int Id { get; set; }

    [Required]
    public int Year { get; set; }

    [Required]
    public int Day { get; set; }

    [Required]
    public string Input { get; set; } = string.Empty;

    public string? Name { get; set; }

    public IEnumerable<Submission>? Submissions { get; set; }
}
