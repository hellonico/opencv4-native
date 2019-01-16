export BUILD_FOLDER=build
export URL=http://hellonico.info:8081/repository/hellonico/
export REPOSITORYID=vendredi
export CV_VERSION=4.0.0

arch=("linux_arm" "linux_arm64" "windows_64" "windows_32" "osx_64" "linux_64" "linux_32")

function create_tree() {    
    for i in "${arch[@]}"
    do
        echo "$i"
        mkdir -p natives/$i
    done
}


function realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

export CV_SOURCE_DIR=`realpath opencv`
export CV_BUILD_DIR=$CV_SOURCE_DIR/build
export GENERATOR_NAME="Unix Makefiles"

function build_make() {
    cd $CV_BUILD_DIR
    make -j $(($(nproc) + 1))
}

function do_clone() {
    git clone --branch $CV_VERSION --depth 1 https://github.com/opencv/opencv.git opencv
    git clone --branch $CV_VERSION --depth 1 https://github.com/opencv/opencv_contrib.git opencv_contrib
}

function do_clean() {
    rm -fr $CV_BUILD_DIR
    mkdir -p $CV_BUILD_DIR
    echo $CV_BUILD_DIR
}

function install_clj() {
    clj_version="1.9.0.397"
    script_file="linux-install-$clj_version.sh"
    curl -O "https://download.clojure.org/install/$script_file"
    chmod +x $script_file
    sudo ./$script_file
    rm $script_file
    sudo apt install rlwrap
}

function build_cmake() {
cd $CV_BUILD_DIR
echo $CV_BUILD_DIR
cmake \
-D CMAKE_BUILD_TYPE=RELEASE \
-G "${GENERATOR_NAME}" \
--build ${BUILD_DIR} \
-D OPENCV_EXTRA_MODULES_PATH=$CV_SOURCE_DIR/../opencv_contrib/modules/xfeatures2d \
-D OPENCV_ENABLE_NONFREE=ON \
-D BUILD_CUDA_STUBS=OFF \
-D BUILD_DOCS=ON \
-D BUILD_EXAMPLES=OFF \
-D BUILD_JASPER=ON \
-D BUILD_JPEG=ON \
-D BUILD_OPENEXR=ON \
-D BUILD_PACKAGE=ON \
-D BUILD_PERF_TESTS=OFF \
-D BUILD_PNG=ON \
-D BUILD_SHARED_LIBS=OFF \
-D BUILD_TBB=OFF \
-D BUILD_TESTS=OFF \
-D BUILD_TIFF=OFF \
-D BUILD_WITH_DEBUG_INFO=OFF \
-D BUILD_ZLIB=OFF \
-D BUILD_WEBP=OFF \
-D BUILD_opencv_apps=ON \
-D BUILD_opencv_calib3d=ON \
-D BUILD_opencv_core=ON \
-D BUILD_opencv_cudaarithm=OFF \
-D BUILD_opencv_cudabgsegm=OFF \
-D BUILD_opencv_cudacodec=OFF \
-D BUILD_opencv_cudafeatures2d=OFF \
-D BUILD_opencv_cudafilters=OFF \
-D BUILD_opencv_cudaimgproc=OFF \
-D BUILD_opencv_cudalegacy=OFF \
-D BUILD_opencv_cudaobjdetect=OFF \
-D BUILD_opencv_cudaoptflow=OFF \
-D BUILD_opencv_cudastereo=OFF \
-D BUILD_opencv_cudawarping=OFF \
-D BUILD_opencv_cudev=OFF \
-D BUILD_opencv_features2d=ON \
-D BUILD_opencv_flann=ON \
-D BUILD_opencv_highgui=ON \
-D BUILD_opencv_imgcodecs=ON \
-D BUILD_opencv_imgproc=ON \
-D BUILD_opencv_java=ON \
-D BUILD_opencv_ml=ON \
-D BUILD_opencv_objdetect=ON \
-D BUILD_opencv_photo=ON \
-D BUILD_opencv_python2=OFF \
-D BUILD_opencv_python3=ON \
-D BUILD_opencv_shape=ON \
-D BUILD_opencv_stitching=ON \
-D BUILD_opencv_superres=ON \
-D BUILD_opencv_ts=ON \
-D BUILD_opencv_video=ON \
-D BUILD_opencv_videoio=ON \
-D BUILD_opencv_videostab=ON \
-D BUILD_opencv_viz=ON \
-D BUILD_opencv_world=OFF \
-D CMAKE_BUILD_TYPE=RELEASE \
-D WITH_1394=ON \
-D WITH_CUBLAS=OFF \
-D WITH_CUDA=OFF \
-D WITH_CUFFT=OFF \
-D WITH_EIGEN=ON \
-D WITH_FFMPEG=OFF \
-D WITH_GDAL=OFF \
-D WITH_GPHOTO2=OFF \
-D WITH_GIGEAPI=ON \
-D WITH_GSTREAMER=ON \
-D WITH_GTK=ON \
-D WITH_INTELPERC=OFF \
-D WITH_IPP=ON \
-D WITH_IPP_A=OFF \
-D WITH_JASPER=ON \
-D WITH_JPEG=ON \
-D WITH_LIBV4L=ON \
-D WITH_OPENCL=ON \
-D WITH_OPENCLAMDBLAS=OFF \
-D WITH_OPENCLAMDFFT=OFF \
-D WITH_OPENCL_SVM=OFF \
-D WITH_OPENEXR=ON \
-D WITH_OPENGL=ON \
-D WITH_OPENMP=OFF \
-D WITH_OPENNI=OFF \
-D WITH_PNG=ON \
-D WITH_PTHREADS_PF=OFF \
-D WITH_PVAPI=ON \
-D WITH_QT=OFF \
-D WITH_TBB=OFF \
-D WITH_TIFF=OFF \
-D WITH_UNICAP=OFF \
-D WITH_V4L=ON \
-D WITH_VTK=OFF \
-D WITH_WEBP=OFF \
-D WITH_XIMEA=OFF \
-D WITH_XINE=OFF \
${CV_SOURCE_DIR}


cd ../..
}

# -D BUILD_opencv_flann=OFF \
#     -D BUILD_opencv_video=OFF \
#     -D BUILD_opencv_videoio=OFF \
#     -D BUILD_opencv_dnn=OFF \
function build_cmake2() {
    cd $CV_BUILD_DIR
    echo $CV_BUILD_DIR
    cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -G "${GENERATOR_NAME}" \
    --build ${BUILD_DIR} \
    -D BUILD_SHARED_LIBS=OFF \
    -D WITH_1394=OFF \
    -D WITH_CUBLAS=OFF \
    -D WITH_CUDA=OFF \
    -D WITH_CUFFT=OFF \
    -D WITH_EIGEN=OFF \
    -D WITH_FFMPEG=OFF \
    -D WITH_GDAL=OFF \
    -D WITH_GPHOTO2=OFF \
    -D WITH_GIGEAPI=OFF \
    -D WITH_GSTREAMER=OFF \
    -D WITH_GTK=OFF \
    -D WITH_INTELPERC=OFF \
    -D WITH_IPP=OFF \
    -D WITH_IPP_A=OFF \
    -D WITH_JASPER=OFF \
    -D WITH_JPEG=ON \
    -D WITH_LIBV4L=OFF \
    -D WITH_OPENCL=OFF \
    -D WITH_OPENCLAMDBLAS=OFF \
    -D WITH_OPENCLAMDFFT=OFF \
    -D WITH_OPENCL_SVM=OFF \
    -D WITH_OPENEXR=OFF \
    -D WITH_OPENGL=OFF \
    -D WITH_OPENMP=OFF \
    -D WITH_OPENNI=OFF \
    -D WITH_PNG=ON \
    -D WITH_PTHREADS_PF=OFF \
    -D WITH_PVAPI=OFF \
    -D WITH_QT=OFF \
    -D WITH_TBB=OFF \
    -D WITH_TIFF=OFF \
    -D WITH_UNICAP=OFF \
    -D WITH_V4L=OFF \
    -D WITH_VTK=OFF \
    -D WITH_WEBP=OFF \
    -D WITH_XIMEA=OFF \
    -D WITH_XINE=OFF \
    -D BUILD_opencv_apps=OFF \
    -D BUILD_opencv_highgui=OFF \
    -D BUILD_opencv_python_bindings_generator=OFF \
    -D ENABLE_CXX=1 \
    ${CV_SOURCE_DIR}

    cd ../..
}

function version() {
    GLIBVERSION=$(ldd --version | head -n1 | rev | cut -d" " -f1 | rev)
    ARCH=`uname -m`
    OS=`uname | tr '[:upper:]' '[:lower:]'`
    # BUILD_FOLDER=$OS-$ARCH-$GLIBVERSION
    echo "$OS-$ARCH-$GLIBVERSION"
}

function linux-deps() {
    sudo apt update
    sudo apt install ant build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
    # python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
}
function debian-video() {
    apt install libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good gstreamer1.0-libav
}

function so_to_jar() {
    path_to_so=$1
    custom=$2
    ARCH=$3
    target_file=$BUILD_FOLDER/opencv-native-$custom.jar
    vers=$4
    
    echo "SO:$path_to_so"
    echo "custom:$custom"
    echo "arch:$ARCH"
    echo "version:$vers"

    cp $path_to_so natives/$ARCH/libopencv_java400.so
    jar cvf $target_file natives/$ARCH
}

function install_so() {
    so_to_jar $1 $2 $3 $4
    
    mvn install:install-file \
    -DgroupId=opencv \
    -DartifactId=opencv-native-$custom \
    -Dversion=$vers \
    -Dpackaging=jar \
    -Dfile=$target_file

    outut_for_build opencv-native-$custom $vers
}

function outut_for_build() {
    custom=$1
    vers=$2
    echo "[opencv/$custom \"$vers\"]"
    echo "opencv/$custom {:mvn/version \"$vers\"}"
}

function install_so_from_build() {
    path_to_so=`find opencv/build/ -name lib*.so`
    ARCH="linux_64"
    target_file=$BUILD_FOLDER/opencv-native-$ARCH.jar
    vers=4.0.0-beta
    install_so $path_to_so $ARCH $ARCH $vers
}

function  check_so_lib() {
    readelf -d natives/linux_64/libopencv_java400.so 
    ldd natives/linux_64/libopencv_java400.so 
}

# build jars from structure in native folder
# store the jars in build/ folder
function build_native_jars() {
    for i in "${arch[@]}"
    do
      jar cvf $BUILD_FOLDER/opencv-native-$i.jar natives/$i
    done
    jar cvf $BUILD_FOLDER/opencv-native.jar natives/*
}

function install_core() {
    path_to_jar=`find opencv/build/bin -name *.jar`
    echo "> $path_to_jar"
    mvn install:install-file \
    -DgroupId=opencv \
    -DartifactId=opencv \
    -Dversion=$VERSION \
    -Dpackaging=jar \
    -Dfile=$path_to_jar
}

function deploy_core() {
    path_to_jar=`find opencv/build/bin -name *.jar`
    echo "> $path_to_jar"
    vers=$1
    mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv \
    -Dversion=$vers \
    -Dpackaging=jar \
    -Dfile=$path_to_jar \
    -DrepositoryId=$REPOSITORYID \
    -Durl=$URL
}

function deploy_native() {
    # -Dclassifiers=osx,linux,windows,raspberry \
    # -Dfiles=$BUILD_FOLDER/opencv-native-macosx.jar,$BUILD_FOLDER/opencv-native-linux.jar,$BUILD_FOLDER/opencv-native-windows.jar,$BUILD_FOLDER/opencv-native-raspberry.jar \
    # -Dtypes=jar,jar,jar,jar \
    vers=$1
    mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv-native \
    -Dversion=$vers \
    -Dfile=$BUILD_FOLDER/opencv-native.jar \
    -Dclassifiers=osx_64,linux_64,windows_64,linux_arm64 \
    -Dfiles=$BUILD_FOLDER/opencv-native-osx_64.jar,$BUILD_FOLDER/opencv-native-linux_64.jar,$BUILD_FOLDER/opencv-native-windows_64.jar,$BUILD_FOLDER/opencv-native-linux_arm64.jar \
    -Dtypes=jar,jar,jar,jar \
    -Dpackaging=jar \
    -DrepositoryId=$REPOSITORYID \
    -Durl=$URL
}

function deploy_one_jar() {    
    jar_file=$1
    arch=$2 
    vers=$3
    echo $jar_file

    mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv-native-$arch \
    -Dversion=$vers \
    -Dfile=$jar_file \
    -Dpackaging=jar \
    -DrepositoryId=$REPOSITORYID \
    -Durl=$URL

    outut_for_build opencv-native-$arch $vers

}