
# gcc-s2i
FROM centos:centos7

MAINTAINER Kenneth D. Evensen <kevensen@redhat.com>

ENV BUILDER_VERSION=1.0 \
    GUAC_VERSION=0.9.9 \
    LC_ALL=en_US.UTF-8 \
    HOME=/opt/app-root

LABEL io.k8s.description="Platform for building a gcc based application" \
      io.k8s.display-name="gcc builder 0.0.1" \
      io.openshift.expose-services="8080:http,4822:tcp" \
      io.openshift.s2i.scripts-url="image:///usr/local/s2i" \
      io.openshift.tags="gcc,centos"

RUN yum clean all -y && \
    yum update -y && \
    yum -y install             \
        cairo-devel            \
        dejavu-sans-mono-fonts \
        freerdp-devel          \
        freerdp-plugins        \
        gcc                    \
        ghostscript            \
        libjpeg-turbo-devel    \
        libssh2-devel          \
        liberation-mono-fonts  \
        libtelnet-devel        \
        libtool                \
        libvorbis-devel        \
        libvncserver-devel     \
        libwebp-devel          \
        make                   \
        openssl		       \
        pango-devel            \
        pulseaudio-libs-devel  \
        tar                    \
        terminus-fonts         \
        uuid-devel             && \
    yum clean all -y && \
    rm -rf /var/cache/yum/*
         
COPY ./.s2i/bin/ /usr/local/s2i

RUN mkdir /opt/app-root && \
    useradd -u 1001 -r -g 0 -d ${HOME} -s /sbin/nologin -c "Default Application User" default && \
    chown -R 1001:0 $HOME && chmod -R og+rwx ${HOME} && \
    chmod g+w /usr/local/{lib,include,sbin} && \
    chmod g+w /usr/local/share/man/man{5,8} 

WORKDIR ${HOME}
USER 1001
EXPOSE 8080
EXPOSE 4822

# TODO: Drop the root user and make the content of /opt/app-root owned by user 1001
# RUN chown -R 1001:1001 /opt/app-root

# This default user is created in the openshift/base-centos7 image
USER 1001

# TODO: Set the default port for applications built using this image
# EXPOSE 8080

# TODO: Set the default CMD for the image
# CMD ["usage"]
