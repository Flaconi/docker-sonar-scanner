FROM debian:stretch-slim
MAINTAINER "Patrick Plocke" <patrick.plocke@flaconi.de>


ENV BUILD_DEPS \
	curl \
	unzip \
	xz-utils

ENV RUN_DEPS \
	ca-certificates \
	jq


###
### Depenencies
###
RUN set -ex \
	&& DEBIAN_FRONTEND=noninteractive \
	&& apt-get update -qq \
	&& apt-get install -qq -y --no-install-recommends --no-install-suggests -y \
		${BUILD_DEPS} \
		${RUN_DEPS} \
	&& DEBIAN_FRONTEND=noninteractive apt-get purge -qq -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
	&& rm -rf /var/lib/apt/lists/*


###
### NodeJS
###
ENV NODE_DOWNLOAD_URL="https://nodejs.org/en/download/"
RUN set -ex \
	&& NODE_DOWNLOAD_XS="$( \
		curl -sSL https://nodejs.org/en/download/ \
			| grep -Eo 'https://.+node-v[.0-9]+-linux-x64\.tar\.xz' \
	)" \
	&& curl -sS "${NODE_DOWNLOAD_XS}" > /tmp/node.tar.xz \
	&& cd /tmp \
	&& tar -xf node.tar.xz \
	&& rm node.tar.xz \
	&& mv node* /usr/local/node \
	&& ln -s /usr/local/node/bin/node /usr/local/bin/node \
	&& ln -s /usr/local/node/bin/npm /usr/local/bin/npm \
	&& ln -s /usr/local/node/bin/npx /usr/local/bin/npx



###
### Sonar Scanner
###
ENV SONAR_DOWNLOAD_URL="https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner"
RUN set -ex \
	&& SONAR_DOWNLOAD_ZIP="$( \
		curl -sSL  https://docs.sonarqube.org/display/SCAN/Analyzing+with+SonarQube+Scanner \
		| grep -Eo 'https://.*?sonar-scanner-cli-[.0-9]+-linux\.zip' \
	)" \
	&& curl -sSL "${SONAR_DOWNLOAD_ZIP}" > /tmp/sonar-scanner-cli.zip \
	&& cd /tmp \
	&& unzip sonar-scanner-cli.zip \
	&& rm sonar-scanner-cli.zip \
	&& mv /tmp/sonar-scanner-* /usr/local/sonar-scanner \
	&& ln -s /usr/local/sonar-scanner/bin/sonar-scanner /usr/local/bin/sonar-scanner


###
### SonarCube Result fetcher
###
COPY data/sonar-result /usr/local/bin/sonar-result


###
### Volume & Workdir
###
VOLUME /sonar
WORKDIR /sonar


###
### Default entrypoint
###
CMD ["--version"]
ENTRYPOINT ["sonar-scanner"]
