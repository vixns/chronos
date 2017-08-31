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

FROM openjdk:8-jre-slim
ENV PORT1=8081
RUN \
	apt-get update \
	&& apt-get install -y gnupg \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF \
    && echo "deb http://repos.mesosphere.com/debian jessie main" | tee -a /etc/apt/sources.list.d/mesosphere.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y systemd mesos \
	&& dpkg --purge systemd gnupg \
	&& rm -rf /var/lib/apt/lists/*
COPY --from=0 /src/target/chronos.jar /chronos.jar
ADD bin/start.sh /start.sh
ENTRYPOINT ["/start.sh"]
