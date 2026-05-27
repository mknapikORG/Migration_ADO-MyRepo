using HelloWorld.Api;

namespace HelloWorld.Api.Tests;

public class HelloWorldMessageTests
{
    [Fact]
    public void Value_ReturnsExpectedGreeting()
    {
        Assert.Equal("Hello World from Azure App Service from ...1", HelloWorldMessage.Value);
    }
}
