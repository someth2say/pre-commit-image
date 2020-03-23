
FROM quay.io/flozanorht/flamel:0.3-7 as pre-commit

RUN curl https://pre-commit.com/install-local.py | python - & \
    ln -s /root/bin/pre-commit /usr/bin/pre-commit & \
    dnf install -y perl ruby

FROM pre-commit

ARG BOOKDIR="/tmp/coursebook"

ENV LANG="en_US.utf-8" 

ENTRYPOINT ["pre-commit"]

WORKDIR ${BOOKDIR}

CMD ["run","-a"]
