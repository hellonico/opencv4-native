
# install native jar from local .so
```
. build.sh && install_so_from_build
```
or
```
. build.sh && install_so ~/libopencv_java400.so ubuntu16 linux_64 4.0.0-beta
. build.sh && install_so sos/libopencv_2_19.so libc_2_19 linux_64 4.0.0-beta
. build.sh && install_so sos/libopencv_2_19_arm64.so 2_19_arm64 linux_64 4.0.0-beta

```

# deploy one jar
```
. build.sh && deploy_one_jar build/opencv-native-ubuntu16.jar ubuntu16-noffmpeg 4.0.0-beta
```

# trouble shotting

## Protocol "https" not supported or disabled in libcurl

```
sudo apt install libssl-dev 
```

## cmake on old debian

download from

https://cmake.org/files/v3.12/cmake-3.12.4.tar.gz

```
wget https://cmake.org/files/v3.12/cmake-3.12.4.tar.gz
tar xvfz cmake-3.12.4.tar.gz 
cd cmake-3.12.4/
./bootstrap
make
make install
```

## sdkman

```
sudo apt install zip unzip
curl -s "https://get.sdkman.io" | bash
source "/home/vagrant/.sdkman/bin/sdkman-init.sh"
sdk install java  8.0.191-oracle
```

## openjdk, java 

https://www.azul.com/downloads/zulu-embedded/

```
wget http://cdn.azul.com/zulu-embedded/bin/zulu8.31.1.122-jdk1.8.0_181-linux_aarch64.tar.gz 
tar xvfz zulu8.31.1.122-jdk1.8.0_181-linux_aarch64.tar.gz 
mv zulu8.31.1.122-jdk1.8.0_181-linux_aarch64 /opt/
ln -s /opt/zulu8.31.1.122-jdk1.8.0_181-linux_aarch64/ /opt/jdk


wget https://cdn.azul.com/zulu/bin/zulu8.31.0.1-jdk8.0.181-linux_x64.tar.gz
tar xvfz zulu8.31.0.1-jdk8.0.181-linux_x64.tar.gz
mv zulu8.31.0.1-jdk8.0.181-linux_x64 /opt/
ln -s /opt/zulu8.31.0.1-jdk8.0.181-linux_x64 /opt/jdk
```