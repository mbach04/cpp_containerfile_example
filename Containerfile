FROM ubi8/ubi AS base

USER 0


RUN yum groupinstall "Development Tools" -y

RUN INSTALL_PKGS="git llvm-toolset" && \
	yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
	rpm -V $INSTALL_PKGS && \
	yum clean all

RUN mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root

COPY hello.cpp /opt/app-root/

RUN cd /opt/app-root/ && \
    gcc hello.cpp -lstdc++ && \
    mv a.out hello-world

FROM ubi8/ubi-minimal

ENV HOME=/opt/app-root

RUN mkdir -p ${HOME}

COPY --from=base ${HOME}/hello-world ${HOME}/

USER 1001
WORKDIR ${HOME}
CMD ["./hello-world"]
