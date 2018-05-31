#!/bin/sh
cp -R /app /sonarqube
cd /sonarqube
mono /etc/sonar-scanner-msbuild/SonarQube.Scanner.MSBuild.exe begin /k:$PROJECT_KEY /v:$VERSION_NO /d:sonar.host.url=$SONAR_URL /d:sonar.verbose=true /d:sonar.log.level=TRACE
dotnet restore
dotnet build
dotnet test
mono /etc/sonar-scanner-msbuild/SonarQube.Scanner.MSBuild.exe end