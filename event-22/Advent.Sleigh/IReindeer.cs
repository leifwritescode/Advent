using Advent.Ornaments;
using Advent.Sleigh.Model;

namespace Advent.Sleigh;

public interface IReindeer
{
    Task<Challenge?> GetChallengeAsync(int year, int day);

    Task<Response> PutResponseAsync(Challenge challenge, Stage stage, string response);
}
