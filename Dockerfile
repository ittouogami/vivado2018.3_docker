FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"

RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential binutils ncurses-dev u-boot-tools file tofrodos iproute2
RUN \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/*

ARG VIVADO_TAR_URI=smb://192.168.103.223/Share/Vivado2018.3/Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz
# Main
COPY install_config_main.txt /vivado-installer/
RUN \
  curl -u guest ${VIVADO_TAR_URI} | tar zx --strip-components=1 -C /vivado-installer && \
  /vivado-installer/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /vivado-installer/install_config_main.txt && \
  rm -rf /vivado-installer
# /root/.Xilinx generated

# Update 1
ARG VIVADO_TAR_URI2=smb://192.168.103.223/Share/Vivado2018.3/Xilinx_Vivado_SDx_Update_2018.3.1_0326_0329.tar.gz
COPY install_config_up1.txt /vivado-installer/
RUN \
  curl -u guest ${VIVADO_TAR_URI2} | tar zx --strip-components=1 -C /vivado-installer && \
  /vivado-installer/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /vivado-installer/install_config_up1.txt && \
  rm -rf /vivado-installer
# /root/.Xilinx generated

RUN bash -c '/opt/Xilinx/Vivado/2018.3/settings64.sh'

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

