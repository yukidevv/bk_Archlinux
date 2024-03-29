#dotfilesのテスト用に
FROM archlinux:latest

ARG USERNAME=yuki
ARG PASSWORD=hogehoge
ARG HOME_DIR=/home/${USERNAME}
ENV HOME /home/${USERNAME}

RUN pacman -Syu --noconfirm
RUN pacman -S base base-devel --noconfirm

RUN echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
RUN locale-gen
RUN export LANG=C
RUN echo LANG=ja_JP.UTF-8 > /etc/locale.conf

RUN useradd -m -r -G wheel -s /bin/bash ${USERNAME}
RUN echo "root:${PASSWORD}" | chpasswd
RUN echo "${USERNAME}:${PASSWORD}" | chpasswd
RUN echo '%wheel ALL=(ALL) ALL' | EDITOR='tee -a' visudo

RUN pacman -Syy
RUN pacman -S xdg-user-dirs --noconfirm
RUN pacman -S git --noconfirm
RUN pacman -S wget --noconfirm

#ENV HOME /home/${USERNAME}
WORKDIR /home/${USERNAME}
USER ${USERNAME}
#ディレクトリ名は英語に
RUN LANG=C xdg-user-dirs-update --force

USER ${USERNAME}
WORKDIR /tmp
RUN wget https://github.com/Jguer/yay/releases/download/v10.2.3/yay_10.2.3_x86_64.tar.gz &&\
	tar xzvf yay_10.2.3_x86_64.tar.gz
USER root
RUN cp /tmp/yay_10.2.3_x86_64/yay /usr/bin/yay
USER ${USERNAME}
WORKDIR ${HOME_DIR}
#RUN git clone
