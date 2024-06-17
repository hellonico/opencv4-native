# regular course

```
# first time building 

. build.sh && linux-deps

# update version in build.sh
. build.sh && do_clone 
. build.sh && do_clean 
# make sure of java version
. build.sh && do_cmake_nix
# for a minimal opencv library file ...
# . build.sh && do_cmake_arm 
# for a jetson
# . build.sh && do_cmake_cuda
. build.sh && do_make
```

# install or deploy core from local build
```
. build.sh && install_core 4.9.0-0
. build.sh && deploy_core 4.9.0-0
```

# build and deploy all native jars from natives folder

```
. build.sh && build_native_jars
. build.sh && install_native_jar 4.9.0-0
. build.sh && deploy_native 4.9.0-0
```


# with make

```
make clean
make clone
make cmake_nix
make do_make
```