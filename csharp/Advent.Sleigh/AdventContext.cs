using Advent.Sleigh.Model;
using Microsoft.EntityFrameworkCore;

namespace Advent.Sleigh;

public class AdventContext : DbContext
{
    public DbSet<Challenge> Challenges { get; set; }
    public DbSet<Submission> Submissions { get; set; }

    public string DbPath { get; }

    public AdventContext()
    {
        var path = Directory.GetCurrentDirectory();
        DbPath = Path.Join(path, "jingle.bells");
    }

    protected override void OnConfiguring(DbContextOptionsBuilder options)
    {
        options.UseSqlite($"Data Source={DbPath}");
    }

    protected override void OnModelCreating(ModelBuilder modelBuilder)
    {
        modelBuilder.Entity<Challenge>()
            .HasMany(x => x.Submissions)
            .WithOne(x => x.Challenge);
    }
}
