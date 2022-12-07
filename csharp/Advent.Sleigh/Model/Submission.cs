using Advent.Ornaments;
using System.ComponentModel.DataAnnotations;

namespace Advent.Sleigh.Model;

public class Submission
{
    [Required]
    public int Id { get; set; }

    [Required]
    public Stage ForStage { get; set; }

    [Required]
    public string Value { get; set; } = string.Empty;

    [Required]
    public Response Response { get; set; }

    [Required]
    public Challenge? Challenge { get; set; }
}
