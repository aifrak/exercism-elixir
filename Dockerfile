# —————————————————————————————————————————————— #
#                      base                      #
# —————————————————————————————————————————————— #

FROM ubuntu:jammy-20220815 as base

USER root

# Required packages:
#   - for erlang: libodbc1, libssl1, libsctp1
RUN set -e \
  && export DEBIAN_FRONTEND=noninteractive \
  && echo "--- Install packages ---" \
  && apt-get update -qq \
  && apt-get install -y -qq --no-install-recommends \
    git=1:2.34.1-* \
    libodbc1=2.3.9-* \
    libssl3=3.0.2-* \
    libsctp1=1.0.19+* \
    locales=2.35-* \
  && echo "--- Add locales ---" \
  && sed -i "/en_US.UTF-8/s/^# //g" /etc/locale.gen \
  && locale-gen "en_US.UTF-8" \
  && echo "--- Clean ---" \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/*

ENV USERNAME=app-user
ARG GROUPNAME=${USERNAME}
ARG USER_UID=1000
ARG USER_GID=${USER_UID}

ENV HOME=/home/${USERNAME}
ENV APP_DIR=/app

# 1. Add username and groupname
# 2. Create project directory and add ownership
RUN set -e \
  && echo "--- Add username and groupname ---" \
  && groupadd --gid ${USER_GID} ${GROUPNAME} \
  && useradd --uid ${USER_UID} --gid ${USER_GID} --shell /bin/bash \
    --create-home ${USERNAME} \
  && echo "--- Create project directory and add ownership ---" \
  && mkdir ${APP_DIR} \
  && chown ${USERNAME}: ${APP_DIR}

USER ${USERNAME}

WORKDIR ${APP_DIR}

CMD [ "bash" ]

# —————————————————————————————————————————————— #
#                       ci                       #
# —————————————————————————————————————————————— #

FROM mvdan/shfmt:v3.4.3 as shfmt
FROM hadolint/hadolint:v2.10.0 as hadolint
FROM hexpm/elixir:1.14.5-erlang-25.3.2.2-ubuntu-jammy-20230126 as elixir
# Install hex and rebar
RUN set -e \
  && mix local.hex --force \
  && mix local.rebar --force

FROM base as ci

USER root

# Add shfmt
COPY --from=shfmt --chown=root /bin/shfmt /usr/local/bin/

# Add hadolint
COPY --from=hadolint --chown=root /bin/hadolint /usr/local/bin/

# Add erlang and elixir
COPY --from=elixir --chown=root /usr/local/bin /usr/local/bin
COPY --from=elixir --chown=root /usr/local/lib /usr/local/lib
COPY --from=elixir --chown=root /usr/local/sbin /usr/local/sbin
COPY --from=elixir --chown=${USERNAME} /root/.mix ${HOME}/.mix

USER ${USERNAME}

# —————————————————————————————————————————————— #
#                       dev                      #
# —————————————————————————————————————————————— #

FROM ci as dev

USER root

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN set -e \
  && export DEBIAN_FRONTEND=noninteractive \
  && echo "--- Install packages ---" \
  && apt-get update -qq \
  && apt-get install -y -qq --no-install-recommends \
    ca-certificates=* \
    gnupg2=* \
    openssh-client=* \
    sudo=* \
    wget=* \
  && echo "--- Give sudo rights to 'USERNAME' ---" \
  && echo "${USERNAME}" ALL=\(root\) NOPASSWD:ALL >/etc/sudoers.d/"${USERNAME}" \
  && chmod 0440 /etc/sudoers.d/"${USERNAME}" \
  && echo "--- Clean ---" \
  && apt-get clean \
  && apt-get autoremove \
  && rm -rf /var/lib/apt/lists/*

# Add exercism cli
RUN set -e \
  && EXERCISM_VERSION="3.1.0" \
  && TARGET_DIR="/usr/local/bin" \
  && ARCHIVE_NAME="exercism.tgz" \
  && EXERCISM_DOWNLOAD_SHA256="97ba90d7d83a9e8de57066be4d42319c33165a355c7072f535ba37c00aedf432" \
  && wget -nv -O ${ARCHIVE_NAME} https://github.com/exercism/cli/releases/download/v${EXERCISM_VERSION}/exercism-${EXERCISM_VERSION}-linux-x86_64.tar.gz \
  && echo "$EXERCISM_DOWNLOAD_SHA256 ${ARCHIVE_NAME}" | sha256sum -c - \
  && mkdir -p ${TARGET_DIR} \
  && tar zxvf ${ARCHIVE_NAME} --directory ${TARGET_DIR} \
  && rm ${ARCHIVE_NAME}

USER ${USERNAME}

# —————————————————————————————————————————————— #
#                     vscode                     #
# —————————————————————————————————————————————— #

FROM dev as vscode

WORKDIR ${HOME}

RUN set -e \
  && mkdir -p .vscode-server/extensions \
    .vscode-server-insiders/extensions

WORKDIR ${APP_DIR}
