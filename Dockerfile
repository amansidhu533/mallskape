# create the build instance 
FROM habib429/nestorbirdotnet123:sdk2.2 as build

WORKDIR /src                                                                    
COPY ./src ./

# restore solution
RUN dotnet restore NopCommerce.sln

WORKDIR /src/Presentation/Nop.Web   

# build and publish project   
RUN dotnet build Nop.Web.csproj -c Release -o /app                                         
RUN dotnet publish Nop.Web.csproj -c Release -o /app/published

# create the runtime instance 
FROM habib429/nestorbirdotnet123:2.2-aspnetcore-runtime-alpine AS runtime 

# add globalization support
RUN apk add --no-cache icu-libs
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=false

FROM habib429/nestorbirdotnet123:2.2-aspnetcore-runtime AS final

# Install the agent
RUN apt-get update && apt-get install -y wget ca-certificates gnupg \
&& echo 'deb http://apt.newrelic.com/debian/ newrelic non-free' | tee /etc/apt/sources.list.d/newrelic.list \
&& wget https://download.newrelic.com/548C16BF.gpg \
&& apt-key add 548C16BF.gpg \
&& apt-get update \
&& apt-get install -y newrelic-netcore20-agent

# Enable the agent
ENV CORECLR_ENABLE_PROFILING=1 \
CORECLR_PROFILER={36032161-FFC0-4B61-B559-F6C5D41BAE5A} \
CORECLR_NEWRELIC_HOME=/usr/local/newrelic-netcore20-agent \
CORECLR_PROFILER_PATH=/usr/local/newrelic-netcore20-agent/libNewRelicProfiler.so \
NEW_RELIC_LICENSE_KEY=a9cd2359fb94e9e4b4d096f229f0ae147731NRAL \
NEW_RELIC_APP_NAME=mallskape-webapp-dev




WORKDIR /app        
RUN mkdir bin
RUN mkdir logs  
                                                            
COPY --from=build /app/published .
COPY ./dataSettings.json /app/App_Data
COPY ./plugins.json /app/App_Data
COPY ./Plugins/ /app/Plugins/
COPY ./robots.custom.txt /app







                            
ENTRYPOINT ["dotnet", "Nop.Web.dll"]
