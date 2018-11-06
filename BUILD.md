# regular course

```
. build.sh && linux-deps
. build.sh && do_clone 
. build.sh && build_cmake
. build.sh && build_make
```

# deploy core from local build
```
. build.sh && deploy_core
```

# deploy all natives jar from natives folder
```
. build.sh && deploy_native
```

# install native jar from local .so
```
. build.sh && install_so_from_build
```
or
```
. build.sh && install_so ~/libopencv_java400.so ubuntu16 linux_64 4.0.0-beta
```

. build.sh && install_so sos/libopencv_2_19.so libc_2_19 linux_64 4.0.0-beta

# build and deploy all native jars from natives folder

```
. build.sh && build_native_jars
. build.sh && deploy_native 4.0.0-beta1
. build.sh && deploy_core 4.0.0-beta1
```

# deploy one jar
```
. build.sh && deploy_one_jar build/opencv-native-ubuntu16.jar ubuntu16-noffmpeg 4.0.0-beta
```