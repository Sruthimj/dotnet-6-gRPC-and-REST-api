FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443
EXPOSE 6000

FROM mcr.microsoft.com/dotnet/sdk:6.0-bullseye-slim AS build
WORKDIR /src
COPY ["grpc_rest_api.csproj", "./"]
RUN dotnet restore "grpc_rest_api.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "grpc_rest_api.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "grpc_rest_api.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "grpc_rest_api.dll"]
