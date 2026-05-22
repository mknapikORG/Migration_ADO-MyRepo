var builder = WebApplication.CreateBuilder(args);
var app = builder.Build();

app.MapGet("/", () => HelloWorld.Api.HelloWorldMessage.Value);
app.MapGet("/health", () => Results.Ok(new { status = "Healthy" }));

app.Run();
