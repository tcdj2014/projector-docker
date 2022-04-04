FROM debian:10

RUN true \
# Any command which returns non-zero exit code will cause this shell script to exit immediately:
   && set -e \
# Activate debugging to show execution details: all commands will be printed before execution
   && set -x \
# install packages:
    && apt-get update \
# packages for sdkman:
    && apt-get install curl zip unzip -y \
# clean apt to reduce image size:
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

ENV PROJECTOR_USER_NAME projector-user

RUN true \
# Any command which returns non-zero exit code will cause this shell script to exit immediately:
    && set -e \
# Activate debugging to show execution details: all commands will be printed before execution
    && set -x \
    && useradd -d /home/$PROJECTOR_USER_NAME -s /bin/bash -G sudo $PROJECTOR_USER_NAME \
    && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
    && mkdir -p /home/$PROJECTOR_USER_NAME \
    && chown $PROJECTOR_USER_NAME:$PROJECTOR_USER_NAME -R /home/$PROJECTOR_USER_NAME
   
USER $PROJECTOR_USER_NAME
ENV HOME /home/$PROJECTOR_USER_NAME

# 安装开发环境
RUN curl -s "https://get.sdkman.io" | bash

ARG GIT_NAME
ARG GIT_EMAIL

RUN true \
    && set -e \
    && set -x \
    && exec bash

RUN true \
    && set -e \
    && set -x \
    && cd /home/projector-user/.sdkman/bin/ \
    && ls -lh \
    && /bin/bash source sdkman-init.sh \
    && sdk version \
    && sdk install java 8.0.322-zulu \
    && sdk install gradle 6.8

EXPOSE 8887 8080 9001

CMD ["bash", "-c", "/run.sh"]
