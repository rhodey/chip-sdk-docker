# chip-sdk-docker
An alternative [CHIP-SDK](https://github.com/NextThingCo/CHIP-SDK) environment based on docker instead of Vagrant. Everything about this repo is basically the same as the original except there's now no need to setup VirtualBox or Vagrant. Because of this the README for this repo is rather short and you should refer to the README of the original git repo for full documentation.

## Build
```
$ docker build -t chip-sdk .
```

## Run
### docker --privileged
You should **always be suspicious** when something asks you to use the `--privileged` option, here it is necessary and I'll explain why but you might also want to [read the documentation](https://docs.docker.com/engine/reference/run/#runtime-privilege-and-linux-capabilities). So, here we use the `--privileged` option to allow container access to your CHIP via USB. Normally USB access is provided to a specific device by using the `--device` option, problem is that throughout the flashing process your CHIP actually reconnects to USB multiple times.

Every time CHIP reconnects it is mounted as a different device and sometimes even has different USB `vendor` and `product` identifiers. Using `--privileged` allows access to all USB devices, use it like this:
```
$ docker run \
    --privileged \
    --rm -it chip-sdk \
    ./chip-update-firmware.sh -p
```

### docker --volume
The docker `--volume` option can be used to share files and directories between containers and your host machine. When using the tools in [CHIP-tools](https://github.com/NextThingCo/CHIP-tools) it is common that images are downloaded for flashing to your CHIP, we can use the `--volume` option here to cache these downloads:
```
$ docker run \
    --privileged \
    --volume $(pwd)/downloads:/root/CHIP-tools/.dl:rw \
    --volume $(pwd)/images:/root/CHIP-tools/.new:rw \
    --rm -it chip-sdk \
    ./chip-update-firmware.sh -p
```

## Connect
Just a quick note on connecting to your CHIP over tty/usb. The CHIP-SDK repo recommends installing the program [screen](https://wiki.archlinux.org/index.php/GNU_Screen) but you can actually just use [BusyBox](https://www.busybox.net/) which you're more likely to already have installed:
```
$ busybox microcom -t 115200 /dev/ttyACM0
```

## License
Copyright 2017 Rhodey Orbits, GPLv3.
