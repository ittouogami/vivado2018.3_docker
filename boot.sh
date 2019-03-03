docker run -it --rm \
    --net host \
    -e LOCAL_UID=$(id -u $USER) \
    -e LOCAL_GID=$(id -g $USER) \
    -e USER=$USER \
    -e UART_GROUP_ID=20 \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    -v /home/hara/docker/hara:/home/hara \
    -w /home/hara \
    -v $HOME/.Xauthority:/root/Xauthority \
    vivado2018.3 /bin/bash
