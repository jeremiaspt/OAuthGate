FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src
COPY ["source/OAuthGate/OAuthGate.csproj", "OAuthGate/"]
RUN dotnet restore "OAuthGate/OAuthGate.csproj"
COPY source/ .
WORKDIR "/src/OAuthGate"
RUN dotnet build "OAuthGate.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "OAuthGate.csproj" -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "OAuthGate.dll"]