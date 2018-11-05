export BUILD_FOLDER=build
export URL=http://hellonico.info:8081/repository/hellonico/
export REPOSITORYID=vendredi
export VERSION=4.0.0-beta
arch=("linux_arm" "linux_arm64" "windows_64" "windows_32" "osx_64" "linux_64" "linux_32")


function realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

export CV_SOURCE_DIR=`realpath opencv`
export CV_BUILD_DIR=$CV_SOURCE_DIR/build
export GENERATOR_NAME="Unix Makefiles"

function do_clone() {
    git clone --branch $VERSION --depth 1 https://github.com/opencv/opencv.git opencv
}

function do_clean() {
    rm -fr $CV_BUILD_DIR
    mkdir -p $CV_BUILD_DIR
    echo $CV_BUILD_DIR
}

function create_tree() {    
    for i in "${arch[@]}"
    do
        echo "$i"
        mkdir -p natives/$i
    done
}

function version() {
    GLIBVERSION=$(ldd --version | head -n1 | rev | cut -d" " -f1 | rev)
    ARCH=`uname -m`
    OS=`uname | tr '[:upper:]' '[:lower:]'`
    # BUILD_FOLDER=$OS-$ARCH-$GLIBVERSION
    echo "$OS-$ARCH-$GLIBVERSION"
}

function linux-deps() {
    apt update
    apt install ant build-essential cmake git libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev libswscale-dev
    # python-dev python-numpy libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libjasper-dev libdc1394-22-dev
}

function installone() {
    path_to_so=`find opencv/build/ -name lib*.so`
    ARCH="linux_64"
    target_file=$BUILD_FOLDER/opencv-native-$ARCH.jar
    vers=4.0.0-beta
    
    echo $path_to_so
    echo $ARCH
    cp $path_to_so natives/$ARCH/
    jar cvf $target_file natives/$ARCH

    mvn install:install-file \
    -DgroupId=opencv \
    -DartifactId=opencv-native-$ARCH \
    -Dversion=$vers \
    -Dpackaging=jar \
    -Dfile=$target_file
    
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
    mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv \
    -Dversion=$VERSION \
    -Dpackaging=jar \
    -Dfile=$path_to_jar \
    -DrepositoryId=$REPOSITORYID \
    -Durl=$URL
}

function deploy_native() {
    # -Dclassifiers=osx,linux,windows,raspberry \
    # -Dfiles=$BUILD_FOLDER/opencv-native-macosx.jar,$BUILD_FOLDER/opencv-native-linux.jar,$BUILD_FOLDER/opencv-native-windows.jar,$BUILD_FOLDER/opencv-native-raspberry.jar \
    # -Dtypes=jar,jar,jar,jar \
    mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv-native \
    -Dversion=$VERSION \
    -Dfile=$BUILD_FOLDER/opencv-native.jar \
    -Dclassifiers=osx_64,linux_64,windows_64 \
    -Dfiles=$BUILD_FOLDER/opencv-native-osx_64.jar,$BUILD_FOLDER/opencv-native-linux_64.jar,$BUILD_FOLDER/opencv-native-windows_64.jar \
    -Dtypes=jar,jar,jar \
    -Dpackaging=jar \
    -DrepositoryId=$REPOSITORYID \
    -Durl=$URL
}

function deploy_2_19() {
        # path_to_so=`find opencv/build/ -name lib*.so`
    ARCH="linux_64"
    target_file=$BUILD_FOLDER/opencv-native-$ARCH.jar
    vers=4.0.0-beta
    
    # echo $path_to_so
    echo $target_file
    # cp $path_to_so natives/$ARCH/
    # jar cvf $target_file natives/$ARCH

    mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv-native-$ARCH \
    -Dversion=$vers \
    -Dfile=$target_file \
    -Dpackaging=jar \
    -DrepositoryId=$REPOSITORYID \
    -Durl=$URL
}
