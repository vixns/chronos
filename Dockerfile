FROM openjdk:8-jdk

ADD . /src
ENV MAVEN_CONFIG=/src/.m2 DEBIAN_FRONTEND=noninteractive
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
ENV PORT0=8080 PORT1=8081 DEBIAN_FRONTEND=noninteractive
RUN \
	apt-get update \
	&& apt-get install -y gnupg \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E56151BF \
    && echo "deb http://repos.mesosphere.com/debian jessie main" | tee -a /etc/apt/sources.list.d/mesosphere.list \
	&& apt-get update \
	&& apt-get install --no-install-recommends -y systemd curl iproute2 mesos \
	&& curl -s -o /tmp/libssl.dev http://ftp.de.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.2l-1~bpo8+1_amd64.deb \
	&& dpkg -i /tmp/libssl.dev \
	&& rm -rf /var/lib/apt/lists/* /tmp/*
COPY --from=0 /src/target/chronos.jar /chronos.jar
ADD bin/start.sh /start.sh
ENTRYPOINT ["/start.sh"]
