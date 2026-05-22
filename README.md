# Migration ADO Sample

Small ASP.NET Core sample used to test Azure DevOps to GitHub repository migration while keeping Azure DevOps pipeline YAML available.

## Contents

- `src/HelloWorld.Api` - minimal ASP.NET Core app returning a hello world response.
- `tests/HelloWorld.Api.Tests` - sample xUnit test project.
- `infra/main.bicep` - Azure App Service Plan and Linux Web App infrastructure.
- `azure-pipelines-ci.yml` - CI pipeline for restore, build, and tests.
- `azure-pipelines-cd.yml` - CD pipeline for build, publish, Bicep deployment, and App Service deployment.
- `.pipelines/templates` - reusable Azure DevOps pipeline step templates.

## Local commands

```powershell
dotnet restore
dotnet build --configuration Release
dotnet test --configuration Release --no-build
dotnet run --project src/HelloWorld.Api
```

## Azure DevOps setup

Before running `azure-pipelines-cd.yml`, update these variables:

- `azureServiceConnection` - name of an Azure Resource Manager service connection.
- `appName` - globally unique Azure App Service name.
- `resourceGroupName`, `location`, and `skuName` if you want different Azure settings.

The CD pipeline creates the resource group if needed, builds the Bicep template, deploys the infrastructure, then deploys the published ZIP package to Azure App Service.

## CD selection parameters

`azure-pipelines-cd.yml` has runtime parameters for selecting apps and Bicep templates:

```yaml
parameters:
  - name: Apps
    type: object
    default:
      - name: HelloWorld.Api
        project: src/HelloWorld.Api/HelloWorld.Api.csproj
        artifactName: hello-world-api
        appServiceName: '$(appName)'

  - name: Templates
    type: object
    default:
      - name: main
        templateFile: infra/main.bicep
        appName: '$(appName)'
        skuName: '$(skuName)'
```

Use `[]` for either parameter when you want to skip app publishing/deployment or infrastructure deployment for a run.
