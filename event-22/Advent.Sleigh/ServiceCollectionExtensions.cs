using Microsoft.Extensions.DependencyInjection;
using System.Net;
using System.Net.Http.Headers;

namespace Advent.Sleigh;

public static class ServiceCollectionExtensions
{
    public static IServiceCollection AddSleigh(this IServiceCollection services, string token)
    {
        ArgumentException.ThrowIfNullOrEmpty(token);

        var adventCookie = new Cookie("session", token)
        {
            Domain = "adventofcode.com"
        };

        var cookieContainer = new CookieContainer();
        cookieContainer.Add(adventCookie);

        services.AddHttpClient(nameof(Reindeer))
            .ConfigureHttpClient(config =>
            {
                var productValue = new ProductInfoHeaderValue("Sleigh", "1.0");
                var commentValue = new ProductInfoHeaderValue("(+github.com/leifwritescode/advent; see csharp/advent.sleigh/reindeer.cs; contact hei@lwg.no)");

                config.DefaultRequestHeaders.UserAgent.Add(productValue);
                config.DefaultRequestHeaders.UserAgent.Add(commentValue);
                config.BaseAddress = new Uri("https://adventofcode.com/");
            })
            .ConfigurePrimaryHttpMessageHandler(() => new HttpClientHandler()
            {
                CookieContainer = cookieContainer
            });

        services.AddDbContext<AdventContext>()
            .AddTransient<IReindeer, Reindeer>();

        return services;
    }
}
