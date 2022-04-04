FROM debian:10

RUN true \
# Any command which returns non-zero exit code will cause this shell script to exit immediately:
   && set -e \
# Activate debugging to show execution details: all commands will be printed before execution
   && set -x \
# install packages:
    && apt-get update \
# packages for awt:
    && apt-get install libxext6 libxrender1 libxtst6 libxi6 libfreetype6 -y \
# packages for user convenience:
    && apt-get install git bash-completion sudo -y \
# packages for IDEA (to disable warnings):
    && apt-get install procps -y \
# packages for sdkman:
    && apt-get install curl zip unzip -y \
# packages for nodejs:
    && apt-get install lsb-release gnupg gcc g++ make -y \
# clean apt to reduce image size:
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/cache/apt

# nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -

RUN true \
    && set -e \
    && set -x \
    && apt-get update \
    && apt-get install -y nodejs \
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
    && sudo -i \
    && su $PROJECTOR_USER_NAME \
    && /bin/bash source "$HOME/.sdkman/bin/sdkman-init.sh" \
    && sdk version \
    && sdk install java 8.0.322-zulu \
    && sdk install gradle 6.8 \
    && npm install -g coffee-script \
    && npm install -g stylus \
    && git config --global user.name  $GIT_NAME \
    && git config --global user.email  $GIT_EMAIL \
    && git config --list

EXPOSE 8887 8080 9001

CMD ["bash", "-c", "/run.sh"]
