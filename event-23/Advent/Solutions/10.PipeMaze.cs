using Ornaments.Solutions;

namespace Advent.Solutions;

[RegisterOrnament("Pipe Maze", 2023, 10)]
internal sealed partial class PipeMaze : ISolution
{
    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var map = solutionContext.As<char[,]>();
        var dictionary = new Dictionary<(int, int), (int, int)[]>();
        var start = (0, 0);
        for (var y = 0; y < map.GetLength(1); ++y)
        {
            for (var x = 0; x < map.GetLength(0); ++x)
            {
                var cell = map[x, y];
                if (cell == '.')
                {
                    continue;
                }
                if (cell == 'S')
                {
                    start = (x, y);
                    continue;
                }

                var offsets = ConnectionsFrom(cell);
                dictionary.Add((x, y), offsets.Select(offset => (x + offset.Item1, y + offset.Item2)).ToArray());
            }
        }

        var connectionsFromStart = dictionary.Where(kvp => kvp.Value.Contains(start)).Select(kvp => kvp.Key).ToArray();
        dictionary.Add(start, connectionsFromStart);

        var distances = BreadthFirstSearch(dictionary, start);
        return await Task.FromResult(distances.Values.Max());
    }

    public Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        throw new NotImplementedException();
    }

    public bool TryParse(string input, out object parsed)
    {
        var temp = input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(line => line.ToCharArray())
            .ToArray();
        var grid = new char[temp.Length,temp[0].Length];
        for (var y = 0; y < temp.Length; y++)
        {
            for (var x = 0; x < temp[y].Length; x++)
            {
                grid[x, y] = temp[y][x];
            }
        }
        parsed = grid;
        return true;
    }

    private (int, int)[] ConnectionsFrom(char input)
    {
        return input switch
        {
            '|' => new[] { (0, 1), (0, -1) },  // down, up
            '-' => new[] { (1, 0), (-1, 0) },  // right, left
            'L' => new[] { (1, 0), (0, -1) },  // right, up
            'J' => new[] { (0, -1), (-1, 0) }, // up, left
            '7' => new[] { (-1, 0), (0, 1) },  // left, down
            'F' => new[] { (0, 1), (1, 0) },   // down, right
            _ => throw new ArgumentOutOfRangeException(nameof(input), input, null)
        };
    }

    public Dictionary<(int, int), int> BreadthFirstSearch(Dictionary<(int, int), (int, int)[]> dictionary, (int, int) start)
    {
        var distances = new Dictionary<(int, int), int>();
        var queue = new Queue<(int, int)>();

        distances[start] = 0;
        queue.Enqueue(start);

        while (queue.Count > 0)
        {
            var current = queue.Dequeue();
            var currentDistance = distances[current];

            foreach (var neighbor in dictionary[current])
            {
                if (!distances.ContainsKey(neighbor))
                {
                    distances[neighbor] = currentDistance + 1;
                    queue.Enqueue(neighbor);
                }
            }
        }

        return distances;
    }
}
