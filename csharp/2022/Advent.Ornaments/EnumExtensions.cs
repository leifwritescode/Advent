using System;
using System.ComponentModel;
using System.Linq;
using System.Reflection;

namespace Advent.Ornaments;

public static class EnumExtensions
{
    public static string GetDescription(this Enum value)
    {
        FieldInfo? fi = value.GetType().GetField(value.ToString());

        return fi?.GetCustomAttributes(typeof(DescriptionAttribute), false) is DescriptionAttribute[] attributes && attributes.Any()
            ? attributes.First().Description
            : throw new InvalidEnumArgumentException(value.ToString());
    }
}
