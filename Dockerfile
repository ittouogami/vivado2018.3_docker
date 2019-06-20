FROM ubuntu16
LABEL maintainer "ittou <VYG07066@gmail.com>"

ENV VIVADO_VER=2018.3
ARG URIS=smb://192.168.103.223/Share/Vivado2018.3/
ARG VIVADO_MAIN=Xilinx_Vivado_SDK_2018.3_1207_2324.tar.gz
ARG VIVADO_UPDATE1=Xilinx_Vivado_SDx_Update_2018.3.1_0326_0329.tar.gz
COPY install_config_main.txt /VIVADO-INSTALLER/
COPY install_config_up1.txt /VIVADO-INSTALLER_UP1/
RUN \
  dpkg --add-architecture i386 && \
  apt-get update && \
  apt-get -y --no-install-recommends install \
    build-essential binutils ncurses-dev u-boot-tools file tofrodos iproute2 && \
  apt-get autoclean && \
  apt-get autoremove && \
  rm -rf /var/lib/apt/lists/* && \
# Main
  curl -u guest ${URIS}${VIVADO_MAIN} | tar zx --strip-components=1 -C /VIVADO-INSTALLER && \
  /VIVADO-INSTALLER/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER/install_config_main.txt && \
  rm -rf /VIVADO-INSTALLER && \
# /root/.Xilinx generated
# Update 1
  curl -u guest ${URIS}${VIVADO_UPDATE1} | tar zx --strip-components=1 -C /VIVADO-INSTALLER_UP1 && \
  /VIVADO-INSTALLER_UP1/xsetup \
    --agree 3rdPartyEULA,WebTalkTerms,XilinxEULA \
    --batch Install \
    --config /VIVADO-INSTALLER_UP1/install_config_up1.txt && \
  rm -rf /VIVADO-INSTALLER_UP1
# /root/.Xilinx generated

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["/bin/bash", "-l"]

