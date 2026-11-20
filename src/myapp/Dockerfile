FROM node:24-alpine AS client
WORKDIR /src/myapp.client
COPY myapp.client/package.json myapp.client/package-lock.json ./
RUN npm ci
COPY myapp.client/ ./
RUN npm run build

FROM mcr.microsoft.com/dotnet/sdk:10.0 AS server
WORKDIR /src
COPY MyApp.Server/MyApp.Server.csproj MyApp.Server/
RUN dotnet restore MyApp.Server/MyApp.Server.csproj
COPY MyApp.Server/ MyApp.Server/
RUN dotnet publish MyApp.Server/MyApp.Server.csproj -c Release -o /app --no-restore -p:SkipClientBuild=true

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final
WORKDIR /app
COPY --from=server /app ./
COPY --from=client /src/myapp.client/dist ./wwwroot
ENV ASPNETCORE_HTTP_PORTS=8080
EXPOSE 8080
USER $APP_UID
ENTRYPOINT ["dotnet", "MyApp.Server.dll"]
