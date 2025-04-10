FROM ubuntu:22.04

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y && \
  apt-get install -y --no-install-recommends \
  curl bash tar gzip ca-certificates git openssl gnupg wget net-tools procps htop iperf3 default-mysql-client \
  build-essential libffi-dev rustc cargo libssl-dev \
  python3-full python3-pip python3-setuptools python3-dev python3-paramiko python3-wheel \
  screen vim dnsutils openssh-client rsync sshpass

RUN mkdir /install
WORKDIR /install

RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl
RUN mkdir /root/.kube

RUN sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.1.5/zsh-in-docker.sh)"
RUN chsh -s /usr/bin/zsh root

RUN ln -s /usr/bin/python3 /usr/bin/python
RUN pip install ansible pipenv

RUN rm -rf /var/lib/apt/lists/*

ENV HISTFILE /root/docker/.zsh_history_infra-manager
RUN mkdir /root/docker

RUN mkdir /app
WORKDIR /app

COPY docker/entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["default"]
