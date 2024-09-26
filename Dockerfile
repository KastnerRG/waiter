FROM ubuntu:24.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y openssh-server sudo ubuntu-server python3 python3-pip python3-venv util-linux-extra

RUN useradd -m waiter-admin
RUN adduser waiter-admin sudo
RUN echo "waiter-admin ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sudoers

RUN groupadd docker


RUN service ssh start
EXPOSE 22

USER waiter-admin

RUN mkdir /home/waiter-admin/waiter
COPY . /home/waiter-admin/waiter/
WORKDIR /home/waiter-admin/waiter
USER root
RUN chown waiter-admin:waiter-admin -R .
USER waiter-admin
ENV VIRTUAL_ENV=/home/waiter-admin/waiter/.venv
RUN python3.12 -m venv ${VIRTUAL_ENV}
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"
RUN python -m pip install --upgrade pip poetry
RUN poetry install
RUN ./cron_cd.sh