using System.Collections.Generic;
using System.Linq;

namespace Advent.Ornaments;

public static class StackExtensions
{
    /// <summary>
    /// Get a reverse copy of the current stack.
    /// </summary>
    /// <typeparam name="T">The stacked item type.</typeparam>
    /// <param name="self">The stack.</param>
    /// <returns>A new stack representing the inverse of the original.</returns>
    public static Stack<T> Reverse<T>(this Stack<T> self)
    {
        var reversed = new Stack<T>();
        while (self.Any()) { reversed.Push(self.Pop()); }
        return reversed;
    }
}
