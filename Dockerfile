FROM openjdk:8-jdk

ADD . /src
ENV MAVEN_CONFIG=/src/.m2
RUN cd /src \
    && curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add - \
    && apt-get update \
    && apt-get install --no-install-recommends -y apt-transport-https \
    && echo 'deb https://deb.nodesource.com/node_7.x jessie main' | tee /etc/apt/sources.list.d/nodesource.list \
    && apt-get update \
    && apt-get install --no-install-recommends -y \
    maven \
    nodejs \
    scala \
    libcurl3-nss \
    && ln -sf /usr/bin/nodejs /usr/bin/node \
    && mvn -Dmaven.repo.local=/src/.m2 -Dmaven.test.skip=true clean package

FROM openjdk:8-jre-alpine
ENV PORT1=8080
COPY --from=0 /src/target/chronos.jar /chronos.jar
ADD bin/start.sh /start.sh
ENTRYPOINT ["/start.sh"]
