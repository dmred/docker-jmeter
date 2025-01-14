# inspired by https://github.com/hauptmedia/docker-jmeter  and
# https://github.com/hhcordero/docker-jmeter-server/blob/master/Dockerfile
FROM alpine:3.9

MAINTAINER Dima Red<dmredchenko@gmail.com>

ARG JMETER_VERSION="5.1.1"
ENV JMETER_HOME /opt
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://downloader.disk.yandex.ru/disk/4a0986947bc9308a3ec3aac0e43351672eec3ef48a611bea0ae38a4de21642a7/5d2c75dd/Y8oQKoPBEd1laduvNXhFJWv-y-Qle2B0QWfQWRyWmm9ekO6y2Z1QBBNQ1W3eVYmR97IxxjoUyHX5i28wxogcYw%3D%3D?uid=842923925&filename=apache-jmeter-5.1.1.zip&disposition=attachment&hash=&limit=0&content_type=application%2Fzip&owner_uid=842923925&fsize=71465975&hid=f2acc16170ab55c268d1dde29ba84c47&media_type=compressed&tknv=v2&etag=ffd35724d56e8232529538d77d213693

# Install extra packages
# See https://github.com/gliderlabs/docker-alpine/issues/136#issuecomment-272703023
# Change TimeZone TODO: TZ still is not set!
ARG TZ="Europe/Moscow"
RUN    apk update \
	&& apk upgrade \
	&& apk add ca-certificates \
	&& update-ca-certificates \
	&& apk add --update openjdk8-jre tzdata curl unzip bash \
	&& apk add --no-cache nss \
	&& rm -rf /var/cache/apk/* \
	&& mkdir -p /tmp/dependencies  \
	&& cd /tmp/dependencies \
	&& wget -O jmeter.zip ${JMETER_DOWNLOAD_URL} \
	# && mkdir -p /opt  \
	&& unzip /tmp/dependencies/jmeter -d ${JMETER_HOME} \
	&& rm -rf /tmp/dependencies

# TODO: plugins (later)
# && unzip -oq "/tmp/dependencies/JMeterPlugins-*.zip" -d $JMETER_HOME

# Set global PATH such that "jmeter" command is found
ENV PATH ${PATH}:${JMETER_BIN}

# Entrypoint has same signature as "jmeter" command
COPY entrypoint.sh /

WORKDIR	${JMETER_HOME}

ENTRYPOINT ["/entrypoint.sh"]
