if [ $# -eq 0 ]
  then
    echo "Specify OpenCV Top folder"
    exit 1;
fi

export BUILD_FOLDER=$1/build
cd $BUILD_FOLDER

make -j $(($(nproc) + 1))