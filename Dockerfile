FROM ghcr.io/linuxserver/baseimage-ubuntu:bionic

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

# package versions
ARG WEBGRAB_VER="3.2.1"
ARG WGUPDATE_VER=""

# environment variables.
ARG DEBIAN_FRONTEND="noninteractive"
ENV HOME /config

RUN \
 echo "**** add mono repository ****" && \
 apt-get update && \
 apt-get install -y \
	gnupg && \
 apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
 echo "deb https://download.mono-project.com/repo/ubuntu bionic main" | tee /etc/apt/sources.list.d/mono-official.list && \
 echo "**** install packages ****" && \
 apt-get update && \
 apt-get install -y \
	cron \
	libmono-system-data4.0-cil \
	libmono-system-net-http-webrequest4.0-cil \
	libmono-system-web4.0-cil \
	mono-devel \
	mono-runtime \
	unzip && \
 echo "**** install webgrabplus ****" && \
 WEBGRAB_BRANCH=${WEBGRAB_VER%.*} && \
 mkdir -p \
	/app/wg++ && \
 curl -o /tmp/wg++.tar.gz -L \
	"http://www.webgrabplus.com/sites/default/files/download/SW/V${WEBGRAB_VER}/WebGrabPlus_V${WEBGRAB_VER}_beta_install.tar.gz" && \
 tar xzf \
 /tmp/wg++.tar.gz -C \
	/app/wg++ --strip-components=1 && \
 if [ ! -z "$WGUPDATE_ver" ]; then \
 	WGUPDATE_BRANCH=${WGUPDATE_VER%%_*} && \
 	curl -o \
 	/tmp/update.tar.gz -L \
		"http://www.webgrabplus.com/sites/default/files/download/SW/V${WGUPDATE_BRANCH}/WebGrabPlus_V${WGUPDATE_VER}_install.tar.gz" && \
 	tar xf \
 	/tmp/update.tar.gz -C \
		/app/wg++/bin/ --strip-components=2; \
 fi && \
 echo "**** download siteini.pack ****" && \
 curl -o \
 /tmp/ini.zip -L \
	http://www.webgrabplus.com/sites/default/files/download/ini/SiteIniPack_current.zip && \
 unzip -q /tmp/ini.zip -d /defaults/ini/ && \
 echo "**** cleanup ****" && \
 rm -rf \
	/tmp/* \
	/var/lib/apt/lists/* \
	/var/tmp/*

# copy files
COPY root/ /

# ports and volumes
VOLUME /config /data
