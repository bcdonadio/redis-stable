FROM centos:7

RUN yum -y update &&\
    yum -y install epel-release &&\
    yum -y install wget yum-utils rpmdevtools make gcc gcc-c++ &&\
    yum-builddep -y redis

RUN echo -e '#!/bin/bash\nwhile true; do sleep 1; done' \
    >/docker-entrypoint.sh &&\
    chmod +x /docker-entrypoint.sh

RUN useradd builder

WORKDIR /home/builder/rpmbuild
COPY SOURCES/ /home/builder/rpmbuild/SOURCES
COPY SPECS/ /home/builder/rpmbuild/SPECS
RUN chown -R builder.builder /home/builder/rpmbuild

USER builder
RUN spectool -g -R SPECS/redis.spec
RUN rpmbuild -ba SPECS/redis.spec
