using Advent.Ornaments;
using Advent.Sleigh.Model;
using Microsoft.EntityFrameworkCore;
using System.Net;
using System.Net.Http.Headers;
using System.Text.RegularExpressions;

namespace Advent.Sleigh;

public class Reindeer : IReindeer
{
    private static readonly Regex rightAnswer = new(@"That's the", RegexOptions.Compiled);
    private static readonly Regex wrongAnswer = new(@"That's not", RegexOptions.Compiled);

    private readonly AdventContext adventContext;
    private readonly HttpClient httpClient;

    public Reindeer(AdventContext adventContext, IHttpClientFactory httpClientFactory)
    {
        this.adventContext = adventContext;

        // ensure migrated
        adventContext.Database.Migrate();

        httpClient = httpClientFactory.CreateClient(nameof(Reindeer));
    }

    public async Task<Challenge?> GetChallengeAsync(int year, int day)
    {
        var existing = adventContext.Challenges.FirstOrDefault(x => x.Year == year && x.Day == day);
        if (existing is not null)
        {
            return existing;
        }

        using var response = await httpClient.GetAsync($"{year}/day/{day}/input");
        if (response.StatusCode != HttpStatusCode.OK)
        {
            return null;
        }

        var input = await response.Content.ReadAsStringAsync();
        var challenge = new Challenge()
        {
            Year = year,
            Day = day,
            Name = "TestNameForNow",
            Input = input
        };

        adventContext.Challenges.Add(challenge);
        await adventContext.SaveChangesAsync();
        return challenge;
    }

    public async Task<Response> PutResponseAsync(Challenge challenge, Stage stage, string answer)
    {
        var existing = adventContext.Submissions.FirstOrDefault(x => x.Challenge == challenge && x.Value == answer);
        if (existing is not null)
        {
            return existing.Response;
        }

        var payload = $"level={stage.GetDescription()}&answer={answer}";
        using var response = await httpClient.PostAsync($"{challenge.Year}/day/{challenge.Day}/answer", new StringContent(payload, MediaTypeHeaderValue.Parse("application/x-www-form-urlencoded")));
        if (response.StatusCode != HttpStatusCode.OK)
        {
            return Response.CatastrophicError;
        }

        var content = await response.Content.ReadAsStringAsync();

        var outcome = Response.NeedToWait;
        if (rightAnswer.IsMatch(content))
        {
            outcome = Response.Correct;
        }
        else if (wrongAnswer.IsMatch(content))
        {
            outcome = Response.Incorrect;
        }
        else
        {
            return outcome;
        }

        var submission = new Submission()
        {
            Challenge = challenge,
            ForStage = stage,
            Value = answer,
            Response = outcome
        };

        adventContext.Submissions.Add(submission);
        await adventContext.SaveChangesAsync();
        return outcome;
    }
}
