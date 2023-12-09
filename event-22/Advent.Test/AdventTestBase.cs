using Advent.Contracts;
using Advent.Ornaments;
using Moq.AutoMock;
using NUnit.Framework;

namespace Advent.Test;

internal abstract class AdventTestBase<TChallenge> where TChallenge : ISolution
{
    public static IEnumerable<IAdventTestCaseSource> ChallengeTestCaseSources()
    {
        return Enumerable.Empty<IAdventTestCaseSource>();
    }

    [Test]
    [TestCaseSource(nameof(ChallengeTestCaseSources))]
    public void CompliesWithExamples(IAdventTestCaseSource challengeTestCaseSource)
    {
        // Arrange
        var autoMocker = new AutoMocker();
        autoMocker.Use<IInstrument>(new FakeInstrument());
        var context = new FakeContext()
        {
            Input = challengeTestCaseSource.Input,
            Stages = Stage.One | Stage.Two
        };

        var subjectUnderTest = (ISolution)autoMocker.CreateInstance(typeof(TChallenge));

        // Act
        var results = subjectUnderTest.SolveAsync(context).ToBlockingEnumerable();

        // Assert
        foreach (var (actual, expected) in results.Zip(challengeTestCaseSource.Responses))
        {
            Assert.That(actual, Is.EqualTo(expected));
        }
    }
}
