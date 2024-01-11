# This is the dockerfile for building a small image for the toolchain.
# The versions of ghostscript and imagemagick are the ones that come with the specific
# distro.
FROM ubuntu:20.04

RUN apt-get update -qq && apt-get install -y --no-install-recommends \
  ghostscript \
  libgs-dev \
  python \
  ruby \
  openjdk-8-jre \
  sudo \
  zip \
  && rm -rf /var/lib/apt/lists/*

# imagemagick needs all the things
RUN apt-get update -qq && apt-get install -y \
  imagemagick \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Extra security for the user that runs the build
RUN useradd -m runner && echo "runner:runner" | chpasswd && adduser runner sudo

# inject KindleGen
COPY PerBook/util/docker_build/vendor/kindlegen/kindlegen /usr/local/bin/kindlegen

# add build script
COPY PerBook/util/docker_build/bin/build.sh /home/runner/build
RUN chmod +x /home/runner/build

# add book files
COPY Common/backmatter /home/runner/Common/backmatter
COPY Common/bin /home/runner/Common/bin
COPY Common/css /home/runner/Common/css
COPY Common/fonts /home/runner/Common/fonts
COPY Common/preprocessor_library /home/runner/Common/preprocessor_library
COPY Common/rake /home/runner/Common/rake
COPY Common/templates /home/runner/Common/templates
COPY Common/ThirdPartyTools/epubcheck-4.2.6 /home/runner/Common/ThirdPartyTools/epubcheck-4.2.6
COPY Common/ThirdPartyTools/jruby-1.7.22/bin /home/runner/Common/ThirdPartyTools/jruby-1.7.22/bin
COPY Common/ThirdPartyTools/jruby-1.7.22/lib /home/runner/Common/ThirdPartyTools/jruby-1.7.22/lib
COPY Common/ThirdPartyTools/saxon /home/runner/Common/ThirdPartyTools/saxon
COPY Common/ThirdPartyTools/SVGMath-0.3.3 /home/runner/Common/ThirdPartyTools/SVGMath-0.3.3
COPY Common/ThirdPartyTools/xalan /home/runner/Common/ThirdPartyTools/xalan
COPY Common/ThirdPartyTools/XEP /home/runner/Common/ThirdPartyTools/XEP
COPY Common/ThirdPartyTools/Gemfile /home/runner/Common/ThirdPartyTools/Gemfile
COPY Common/ThirdPartyTools/Gemfile.lock /home/runner/Common/ThirdPartyTools/Gemfile.lock
COPY Common/xml /home/runner/Common/xml


COPY PerBook/bibliography /home/runner/PerBook/bibliography
COPY PerBook/util/bibtools /home/runner/PerBook/util/bibtools
COPY PerBook/util/bin /home/runner/PerBook/util/bin
COPY PerBook/util/images /home/runner/PerBook/util/images
COPY PerBook/util/indextools /home/runner/PerBook/util/indextools
COPY PerBook/util/rake /home/runner/PerBook/util/rake
COPY PerBook/util/third_party /home/runner/PerBook/util/third_party
COPY PerBook/util/xml /home/runner/PerBook/util/xml

# imagemagick restricts GS files. Fix it
RUN sed -Ei \
  's$<policy domain="coder" rights="none" pattern="PDF" />$<policy domain="coder" rights="read|write" pattern="PDF" />$' \
  /etc/ImageMagick-6/policy.xml

USER runner
WORKDIR /home/runner

# entrypoint
CMD ["/bin/bash"]




































































