using Advent.Contracts;
using Advent.Ornaments;
using Microsoft.Extensions.Logging;
using System.Diagnostics.CodeAnalysis;
using System.Text.RegularExpressions;

namespace Advent.Solutions;

internal partial class NoSpaceLeftOnDevice : SolutionBase
{
    private static readonly Regex file = GeneratedFileRegex();

    public NoSpaceLeftOnDevice(ILogger<NoSpaceLeftOnDevice> logger, IInstrument instrument)
        : base(logger, instrument, 7)
    {
    }

    private static INode CreateTreeFromInput(string[] listing)
    {
        var enumerator = listing.GetEnumerator();
        DirectoryNode? pwd = default; // at end of execution, this will be the root
        while (enumerator.MoveNext())
        {
            var node = (string)enumerator.Current;
            if (node.StartsWith("$ cd "))
            {
                var where = node["$ cd ".Length..];
                switch (where) 
                {
                    case "..":
                        // we're traversing up to the parent
                        // parent is always a directory
                        ArgumentNullException.ThrowIfNull(pwd);
                        ArgumentNullException.ThrowIfNull(pwd.Parent);
                        pwd = pwd.Parent as DirectoryNode;
                        break;
                    default:
                        // we're traversing down, so change the current directory
                        // if this is the root directory, it's parent is null
                        var directory = new DirectoryNode(where, pwd!);
                        pwd?.Children.Add(directory);
                        pwd = directory;
                        break;
                }
            }
            else
            {
                var match = file.Match(node);
                if (!match.Success)
                {
                    continue;
                }

                var name = match.Groups["name"].Value;
                var size = match.Groups["size"].Value.ToInt();
                ArgumentNullException.ThrowIfNull(pwd);
                var child = new FileNode(name, size, pwd);
                pwd?.Children.Add(child);
            }
        }

        // quick traversal back to the top
        var result = pwd;
        while (result?.Parent is not null)
        {
            result = result.Parent as DirectoryNode;
        }

        ArgumentNullException.ThrowIfNull(result);
        return result;
    }

    private IEnumerable<INode> AllDirectoryNodesIn([NotNull] INode root)
    {
        IEnumerable<INode> result;
        if (root is DirectoryNode node)
        {
            result = node.Children.SelectMany(x => AllDirectoryNodesIn(x)).Append(node);
        }
        else
        {
            result = Enumerable.Empty<INode>();
        }
        return result;
    }

    protected override async Task<string> SolvePartOneAsync(IContext context)
    {
        var input = context.Input.PreProcessLines();
        var tree = CreateTreeFromInput(input);
        var directories = AllDirectoryNodesIn(tree);
        var result = directories.Where(x => x.SizeOnDisk <= 100000).Sum(x => x.SizeOnDisk);
        return await Task.FromResult($"{result}");
    }

    protected override async Task<string> SolvePartTwoAsync(IContext context)
    {
        var input = context.Input.PreProcessLines();

        var tree = CreateTreeFromInput(input);
        var directories = AllDirectoryNodesIn(tree);
        var delta = 30000000 - (70000000 - tree.SizeOnDisk);
        var result = directories.OrderBy(x => x.SizeOnDisk).First(x => x.SizeOnDisk > delta).SizeOnDisk;
        return await Task.FromResult($"{result}");
    }

    [GeneratedRegex("^(?<size>\\d+)\\s(?<name>[\\w\\.]+)$", RegexOptions.Compiled)]
    private static partial Regex GeneratedFileRegex();
}
