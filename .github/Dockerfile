FROM mcr.microsoft.com/dotnet/aspnet:5.0-focal AS base 
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0-focal AS build

# SET WORKSPACE
WORKDIR /app

# DOWNLOAD AND UNTAR LATEST CODEQL BUNDLE
RUN echo $REPO
RUN wget -q https://github.com/github/codeql-action/releases/latest/download/codeql-bundle-linux64.tar.gz
RUN tar xzf ./codeql-bundle-linux64.tar.gz

# FETCH DEPENDENCIES AND CHECKOUT/COPY SRC
COPY . .

# CREATE CODEQL DATABASE
RUN /app/codeql/codeql database create /app/codeql-database --language=csharp --command="dotnet clean && dotnet restore --configfile \"./NuGet.Config" "src/something/.csproj\" && dotnet build \"src/something/.csproj\" /app/build --no-restore"

# ANALYZE CODEQL DATABASE
RUN mkdir codeql-sarif && touch codeql-sarif/code-scanning-alerts.sarif
RUN /app/codeql/codeql database analyze /app/codeql-database /app/codeql/qlpacks/codeql-csharp/codeql-suites/csharp-code-scanning.qls --format=sarif-latest --output=/app/codeql-sarif/code-scanning-alerts.sarif

# UPLOAD CODEQL SARIF RESULTS TO CODE SCANNING ALERTS PAGE ON GITHUB
RUN /app/codeql/codeql github upload-results --repository=<org-name/repository-name> --ref=<example ref such as refs/pull/1/merge> --commit=<commit-sha> --sarif=/app/codeql-sarif/code-scanning-alerts.sarif --github-auth-stdin=<GITHUB_ACCESS_TOKEN> -v

FROM base AS final
ENTRYPOINT ["dotnet", "Api.dll"]
