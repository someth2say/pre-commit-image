FROM registry.fedoraproject.org/fedora:30 as flamel

MAINTAINER Fernando Lozano <flozano@redhat.com>

# Adding "-subrelease" to packages, such as SLIDES="-1.2.0-1", breaks the build.
# Having the dash as part of each version string allows installing whatever is latest by default, or forcing the build to use a fixed release

ARG CURRICULUM="-22-1"
ARG BRANDING
ARG FLAMEL
ARG SLIDES
ARG BOOKDIR="/tmp/coursebook"

# Make sure we get English error messages to share with the team.

ENV LANG="en_US.utf-8" \
    BOOK="${BOOKDIR}" 

RUN curl http://wiki.gls.redhat.com/curriculum-repos/fedora/30/x86_64/curriculum-release-fedora${CURRICULUM}.fc30.noarch.rpm -o /tmp/curriculum-release-fedora${CURRICULUM}.fc30.noarch.rpm \
  && dnf -y install /tmp/*rpm \
  && rm -f /tmp/*rpm \
  && dnf --nodocs -y install \
    publican-gls-redhat-new redhat-training-xsl${BRANDING} reveal-js-slide-generator${SLIDES} \
    interstate-fonts overpass-fonts flamel${FLAMEL} git \
  && dnf clean all \
  && mkdir -p ${BOOK}

COPY check-gls-packages.sh /tmp

VOLUME ${BOOK}

WORKDIR ${BOOK}/guides

# Install pre-commit in a separate container.

FROM flamel as pre-commit

RUN pip install --upgrade pip &&\
    pip install --upgrade wheel setuptools &&\
    pip install pre-commit

# Install additional packages and interpreters
FROM pre-commit as pre-commit-hooks

RUN dnf install -y perl ruby

# Setup ssh identities
FROM pre-commit-hooks

RUN mkdir /root/.ssh
#COPY ssh /root/.ssh
RUN  chmod 0400 /root/.ssh/*
WORKDIR ${BOOK}

CMD ["pre-commit","run","-a"]