
FROM quay.io/redhattraining/flamel as base

RUN dnf update -y && dnf install -y git perl ruby

FROM base as pre-commit 

RUN curl https://pre-commit.com/install-local.py | python3 - && \
    ln -s /root/bin/pre-commit /usr/bin/pre-commit

FROM pre-commit

ARG BOOKDIR="/tmp/coursebook"

RUN mkdir /root/.ssh 

ADD pre-commitw.sh /

ENV LANG="en_US.utf-8" 

ENTRYPOINT ["/pre-commitw.sh"]

WORKDIR ${BOOKDIR}

CMD ["run","-a"]
