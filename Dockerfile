FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"

RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential binutils ncurses-dev u-boot-tools file tofrodos iproute2 \
    gawk net-tools libncurses5-dev tftp tftpd-hpa zlib1g-dev libssl-dev flex bison libselinux1 \
    diffstat xvfb chrpath xterm libtool socat autoconf unzip texinfo gcc-multilib \
    libsdl1.2-dev libglib2.0-dev zlib1g:i386 libtool-bin cpio python python3 pkg-config \
    git gcc-multilib libc6-dev:i386 ocl-icd-opencl-dev libjpeg62-dev vim && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

COPY install_config.txt /vivado-installer/
ARG VIVADO_TAR_URI=smb://192.168.103.223/Share/Xilinx_SDx_2018.3_1207_2324.tar.gz
RUN \
  curl -u guest ${VIVADO_TAR_URI} | tar zx --strip-components=1 -C /vivado-installer && \
  /vivado-installer/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /vivado-installer/install_config.txt && \
  rm -rf /vivado-installer

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

