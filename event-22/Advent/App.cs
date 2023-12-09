using Advent.Contracts;
using Advent.Ornaments;
using Advent.Sleigh;
using Advent.Sleigh.Model;
using Microsoft.EntityFrameworkCore.Query.SqlExpressions;
using Microsoft.Extensions.Logging;

namespace Advent;

internal class App : IApp
{
    private readonly ILogger<IApp> logger;
    private readonly IEnumerable<ISolution> challenges;
    private readonly ContextFactory contextFactory;
    private readonly IReindeer reindeer;

    public App(ILogger<IApp> logger, IEnumerable<ISolution> challenges, ContextFactory contextFactory, IReindeer reindeer)
    {
        this.logger = logger;
        this.challenges = challenges;
        this.contextFactory = contextFactory;
        this.reindeer = reindeer;
    }

    public async Task RunAsync(IAdventOptions args)
    {
        logger.LogInformation("Advent of Code 2022 Solutions Runner (C) Leif Walker-Grant");
        
        var solution = challenges.SingleOrDefault(x => x.Day == args.Day);
        if (solution is null)
        {
            logger.LogError($"Challenge discovery failed for requested date (Date: {args.Day}/12/{args.Year})");
            return;
        }

        var challenge = await reindeer.GetChallengeAsync(args.Year, args.Day);
        if (challenge is null)
        {
            logger.LogError($"Something went horribly wrong requesting the challenge information (Date: {args.Day}/12/{args.Year})");
            return;
        }

        if (args.DryRun)
        {
            logger.LogWarning("This is a dry run");
        }

        var context = contextFactory(challenge.Input);
        context.Stages = args.Stages;

        var stages = Enum.GetValues<Stage>().GetEnumerator();
        await foreach (var response in solution.SolveAsync(context))
        {
            stages.MoveNext();

            if (string.IsNullOrEmpty(response))
            {
                logger.LogWarning($"(stage {stages.Current}) Response was empty: Cowardly assuming that the stage isn't implemented");
                continue;
            }
            else if (args.DryRun)
            {
                logger.LogInformation($"(stage {stages.Current}) Response was {response}");
            }
            else
            {
                logger.LogInformation($"(stage {stages.Current}) Response was {response}. Submitting to AOC...");
                var outcome = await reindeer.PutResponseAsync(challenge, (Stage)stages.Current, response);
                switch (outcome)
                {
                    case Response.CatastrophicError:
                        logger.LogError("Something went horribly wrong submitting the response.");
                        return; // no further processing
                    case Response.NeedToWait:
                        logger.LogWarning("The server asked us to wait a little. Trying again in a few minutes.");
                        return; // no further processing
                    case Response.Correct:
                        logger.LogInformation("The answer was correct!");
                        break;
                    case Response.Incorrect:
                    case Response.TooHigh:
                    case Response.TooLow:
                        logger.LogError($"The answer was wrong ({outcome}.)");
                        return; // no further processing
                }
            }
        }
    }
}
