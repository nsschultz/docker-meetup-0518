# Milwaukee Docker Meetup 05/31/2018

Here are the steps for the SonarQube/MSBuild walkthrough.

1. Start SonarQube server:
```
docker run \
  --name sonarqube \
  -p 9000:9000 \
  -p 9092:9092 \
  -d sonarqube:7.0-alpine
``` 

2. View the SonarQube server by opening a browser and going to http://localhost:9000.

3. Create a file named ```Dockerfile``` in this directory.

4. Add the base image to your ```Dockerfile``` to install .NET Core:
```
FROM microsoft/dotnet:2.1-sdk-alpine
```

5. Add these lines to your ```Dockerfile``` to Install Java 8:
```
RUN apk add --update openjdk8
ENV JAVA_HOME /usr/lib/jvm/java-1.8-openjdk/jre
```

6. Build the image by running the follow command from this directory:
```
docker build -t sonar-scanner-msbuild .
```

7. Add this line to your ```Dockerfile``` to Install Mono
```
RUN apk add --no-cache mono --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing
```

8. Build the image by running the follow command from this directory:
```
docker build -t sonar-scanner-msbuild .
```

9. Replace the line where you installed Java 8 in the ```Dockerfile``` with the following to install curl and unzip:
```
RUN apk add --update curl curl-dev unzip openjdk8
```

10. Add the following lines to the ```Dockerfile``` to install the SonarQube Scanner:
```
RUN curl -LO https://github.com/SonarSource/sonar-scanner-msbuild/releases/download/4.0.2.892/sonar-scanner-msbuild-4.0.2.892.zip \
&& mkdir /etc/sonar-scanner-msbuild \
&& unzip sonar-scanner-msbuild-4.0.2.892.zip -d /etc/sonar-scanner-msbuild \
&& chmod +x /etc/sonar-scanner-msbuild/sonar-scanner-3.0.3.778/bin/sonar-scanner \
&& rm sonar-scanner-msbuild-4.0.2.892.zip
```

11. Build the image by running the follow command from this directory:
```
docker build -t sonar-scanner-msbuild .
```

12. Add the following lines to the ```Dockerfile``` to setup some default values for the environment variables:
```
ENV SONAR_URL="http://sonarqube:9000" \
    PROJECT_KEY="DefaultProject" \
    VERSION_NO="0.0.0"
```

13. Add the following lines to the ```Dockerfile``` to copy in the ```scan.sh``` file and set it up to run:
```
COPY ./scan.sh /scan.sh
RUN chmod +x /scan.sh
CMD /scan.sh
```

14. Build the image by running the follow command from this directory:
```
docker build -t sonar-scanner-msbuild .
```

15. Download some .NET Core code.  You can download some from here: https://github.com/nsschultz/cleaning-code-example.

16. From the directory that you downloaded the .NET Core code to, run this command to scan the code:
```
docker run \
  -e SONAR_URL="http://localhost:9000" \
  -e PROJECT_KEY="MyProject" \
  -e VERSION_NO="1.0.0" \
  -v ${PWD}:/app \
  sonar-scanner-msbuild
```

17. Run the following command to create the network:
```
docker network create sonarqube-network
```

18. Run the following command to add the network to running container:
```
docker network connect sonarqube-network sonarqube
```

19. From the directory that you downloaded the .NET Core code to, run this command to scan the code:
```
docker run \
  --network sonarqube-network \
  -e SONAR_URL="http://sonarqube:9000" \
  -e PROJECT_KEY="MyProject" \
  -e VERSION_NO="1.0.0" \
  -v ${PWD}:/app \
  sonar-scanner-msbuild
```

20. View the SonarQube server by opening a browser and going to http://localhost:9000.
