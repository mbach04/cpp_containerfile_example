FROM ubi8/ubi AS base

USER 0


RUN yum groupinstall "Development Tools" -y

RUN INSTALL_PKGS="git llvm-toolset" && \
	yum install -y --setopt=tsflags=nodocs $INSTALL_PKGS && \
	rpm -V $INSTALL_PKGS && \
	yum clean all

RUN mkdir -p /opt/app-root && chown -R 1001:0 /opt/app-root

WORKDIR /opt/app-root

COPY hello.cpp .

RUN gcc hello.cpp -lstdc++ && \
    mv a.out hello-world


FROM ubi8/ubi-minimal

ENV HOME=/opt/app-root

RUN mkdir -p ${HOME}
WORKDIR ${HOME}
COPY --from=base /opt/app-root/hello-world /opt/app-root/

USER 1001
CMD ["./hello-world"]
