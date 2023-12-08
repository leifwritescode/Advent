using Ornaments.Solutions;

[RegisterOrnament("Camel Cards", 2023, 7)]
internal sealed partial class CamelCards : ISolution
{
    private static readonly char[] cards = new[] { '2', '3', '4', '5', '6', '7', '8', '9', 'T', 'J', 'Q', 'K', 'A' };

    public async Task<object> DoPartOneAsync(ISolutionContext solutionContext)
    {
        var hands = solutionContext.As<IEnumerable<(string, int)>>().ToArray();

        // bubble sort the hands because I'm a degenerate
        var swapped = true;
        var counter = 1;
        while (swapped)
        {
            Console.WriteLine($"Iteration {counter++}");

            swapped = false;
            for (var i = 1; i < hands.Length; ++i)
            {
                var (lhs, _) = hands[i - 1];
                var (rhs, _) = hands[i];

                // if lhs is higher rank than rhs, swap them
                if (CompareHands(lhs, rhs) == -1)
                {
                    (hands[i], hands[i - 1]) = (hands[i - 1], hands[i]);
                    swapped = true;
                }
            }
            counter++;
        }

        var result = 0;
        for (var rank = 0; rank < hands.Length; ++rank)
        {
            var hand = hands[rank];
            result += hand.Item2 * (rank + 1);
        }
        return await Task.FromResult(result);
    }

    public async Task<object> DoPartTwoAsync(ISolutionContext solutionContext)
    {
        return await Task.FromResult(-1);
    }

    public bool TryParse(string input, out object parsed)
    {
        parsed = input
            .Trim()
            .ReplaceLineEndings()
            .Split(Environment.NewLine)
            .Select(line => line.Split(' '))
            .Select(line => (line[0], int.Parse(line[1])));
        return true;
    }

    /// <summary>
    /// Compare two hands of camel cards.
    /// </summary>
    /// <param name="lhs">The left hand.</param>
    /// <param name="rhs">The right hand.</param>
    /// <returns>
    /// 1 if rhs is higher rank, -1 if lhs is higher rank, or 0 if they are identical.
    /// </returns>
    public int CompareHands(string lhs, string rhs)
    {
        // compute discriminant of each hand
        var lhsRank = ComputeDiscriminant(lhs);
        var rhsRank = ComputeDiscriminant(rhs);

        if (rhsRank > lhsRank)
        {
            return 1;
        }
        else if (lhsRank > rhsRank)
        {
            return -1;
        }
        else
        {
            return DeepCompareHands(lhs, rhs);
        }
        throw new NotImplementedException();
    }

    /// <summary>
    /// Compare two hands of camel cards, assuming they have the same discriminant.
    /// </summary>
    /// <param name="lhs">The left hand.</param>
    /// <param name="rhs">The right hand.</param>
    /// <returns>
    /// 1 if rhs is higher rank, -1 if lhs is higher rank, or 0 if they are identical.
    /// </returns>
    private int DeepCompareHands(string lhs, string rhs)
    {
        var lhsCards = lhs.ToCharArray();
        var rhsCards = rhs.ToCharArray();

        for (var i = 0; i < lhsCards.Length; i++)
        {
            var lhsRank = Array.IndexOf(cards, lhsCards[i]);
            var rhsRank = Array.IndexOf(cards, rhsCards[i]);
            if (lhsRank == rhsRank)
            {
                continue;
            }
            else if (rhsRank > lhsRank)
            {
                return 1;
            }
            else
            {
                return -1;
            }
        }

        // if we get here, the hands are identical
        return 0;
    }

    public int ComputeDiscriminant(string hand)
    {
        var cards = hand.ToCharArray();
        return hand.GroupBy(c => c).Max(g => g.Count()) - hand.Distinct().Count();
    }
}
