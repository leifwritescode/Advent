using System;
using System.ComponentModel;

namespace Advent.Ornaments;

[Flags]
public enum Stage
{
    [Description("1")]
    One,
    [Description("2")]
    Two,
}
