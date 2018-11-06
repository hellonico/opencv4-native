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

# deploy one jar
```
. build.sh && deploy_one_jar build/opencv-native-ubuntu16.jar ubuntu16 4.0.0-beta
```