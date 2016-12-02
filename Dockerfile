FROM ubuntu:latest
MAINTAINER "Denis Tulyakov" <dtulyakov@gmail.com>
ENV LC_ALL="C.UTF-8" \
    DEBIAN_FRONTEND="noninteractive" \
    RUBY_MAJOR="2.3" \
    RUBY_VERSION="2.3.3" \
    RUBY_DOWNLOAD_SHA256="241408c8c555b258846368830a06146e4849a1d58dcaf6b14a3b6a73058115b7" \
    RUBYGEMS_VERSION="2.6.8" \
    BUNDLER_VERSION="1.13.6"

RUN set -ex \
	&& { \
		echo 'install: --no-document'; \
		echo 'update: --no-document'; \
	} >> /etc/gemrc

WORKDIR /

RUN set -ex \
  && buildDeps=' \
     bison \
     libgdbm-dev \
     ruby2.3 \
     ruby2.3-dev \
     ' \
  && apt-get update -qq \
  && apt-get install -y --no-install-recommends $buildDeps \
  && apt-get clean \
  && apt-get autoremove -y \
  && rm -fr /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/apt/archives/*.deb \

RUN gem install bundler --version "$BUNDLER_VERSION"

# install things globally, for great justice
# and don't create ".bundle" in all our apps
ENV GEM_HOME /usr/local/bundle
ENV BUNDLE_PATH="$GEM_HOME" \
	BUNDLE_BIN="$GEM_HOME/bin" \
	BUNDLE_SILENCE_ROOT_WARNING=1 \
	BUNDLE_APP_CONFIG="$GEM_HOME"
ENV PATH $BUNDLE_BIN:$PATH
RUN mkdir -p "$GEM_HOME" "$BUNDLE_BIN" \
	&& chmod 777 "$GEM_HOME" "$BUNDLE_BIN"

CMD [ "irb" ]
