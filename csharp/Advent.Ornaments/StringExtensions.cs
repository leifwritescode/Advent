using System;

namespace Advent.Ornaments;

public static class StringExtensions
{
    public static int ToInt(this string s)
    {
        return int.Parse(s);
    }

    public static string[] PreProcessLines(this string s, bool trim = true)
    {
        var n = s;
        if (trim)
            n = n.Trim();

        return n.ReplaceLineEndings().Split(Environment.NewLine);
    }
}
