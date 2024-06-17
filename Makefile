.DEFAULT_GOAL := hello

CV_VERSION := 4.9.0

ORIGAMI_EXTRA_VERSION=2
FINAL_VERSION=${CV_VERSION}-${ORIGAMI_EXTRA_VERSION}

CV_SOURCE_DIR := opencv
CV_BUILD_DIR := opencv/build
GENERATOR_NAME := "UnixMakefiles"
BUILD_FOLDER := build

ARCH = linux_arm linux_arm64 linux_arm64_nvidia windows_64 windows_32 osx_64 osx_arm64 linux_64 linux_32
URL = http://repository.hellonico.info/repository/hellonico/
REPOSITORYID=vendredi

deep-clean:
	rm -fr opencv/ opencv_contrib/
	echo "${CV_BUILD_DIR} clean"


clone: deep-clean
	git clone --branch ${CV_VERSION} --depth 1 https://github.com/opencv/opencv.git opencv
	git clone --branch ${CV_VERSION} --depth 1 https://github.com/opencv/opencv_contrib.git opencv_contrib
	mkdir -p ${CV_BUILD_DIR}
	echo "${CV_BUILD_DIR} clone"

clean:
	rm -fr ${CV_BUILD_DIR}

hello:
	echo $(CV_BUILD_DIR) 
	echo $(CV_SOURCE_DIR)
	echo $(GENERATOR_NAME)

cmake_osx:
	cd $(CV_BUILD_DIR)
	cmake \
	-D CMAKE_BUILD_TYPE=RELEASE \
	-B $(CV_BUILD_DIR) \
	-D OPENCV_EXTRA_MODULES_PATH=$(CV_SOURCE_DIR)/../opencv_contrib/modules \
	-D OPENCV_ENABLE_MODULES=calib3d,core,dnn,features2d,flann,gapi,highgui,imgcodecs,imgproc,java,java_bindings_generator,ml,objdetect,photo,stitching,ts,video,videoio,xfeature2d,xphoto \
	-D OPENCV_ENABLE_NONFREE=ON \
	-D BUILD_CUDA_STUBS=OFF \
	-D BUILD_DOCS=OFF \
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
	-D BUILD_TIFF=ON \
	-D BUILD_WITH_DEBUG_INFO=OFF \
	-D BUILD_ZLIB=OFF \
	-D BUILD_WEBP=ON \
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
	-D BUILD_opencv_python3=OFF \
	-D BUILD_opencv_shape=ON \
	-D BUILD_opencv_stitching=ON \
	-D BUILD_opencv_superres=ON \
	-D BUILD_opencv_ts=OFF \
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
	-D WITH_FFMPEG=ON \
	-D WITH_GDAL=OFF \
	-D WITH_GPHOTO2=OFF \
	-D WITH_GIGEAPI=ON \
	-D WITH_GSTREAMER=OFF \
	-D WITH_GTK=OFF \
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
	-D WITH_PTHREADS_PF=ON \
	-D WITH_PVAPI=ON \
	-D WITH_QT=ON \
	-D WITH_TBB=OFF \
	-D WITH_TIFF=ON \
	-D WITH_UNICAP=OFF \
	-D WITH_V4L=ON \
	-D WITH_VTK=OFF \
	-D WITH_WEBP=ON \
	-D WITH_XIMEA=OFF \
	-D WITH_XINE=OFF \
	$(CV_SOURCE_DIR)
	cd ../..


cmake_pi:
	cd ${CV_BUILD_DIR}
	echo ${CV_BUILD_DIR}
	echo ${GENERATOR_NAME}
	cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -B ${CV_BUILD_DIR} \
    -D BUILD_SHARED_LIBS=OFF \
    -D BUILD_CUDA_STUBS=OFF \
    -D BUILD_DOCS=OFF \
    -D BUILD_EXAMPLES=OFF \
    -D BUILD_JASPER=OFF \
    -D BUILD_JPEG=ON \
    -D BUILD_OPENEXR=OFF \
    -D BUILD_PACKAGE=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D BUILD_PNG=ON \
    -D BUILD_FFMPEG=ON \
    -D BUILD_TBB=OFF \
    -D BUILD_TESTS=OFF \
    -D BUILD_TIFF=OFF \
    -D BUILD_WITH_DEBUG_INFO=OFF \
    -D BUILD_ZLIB=OFF \
    -D BUILD_WEBP=OFF \
    -D WITH_1394=OFF \
    -D WITH_CUBLAS=OFF \
    -D WITH_CUDA=OFF \
    -D WITH_CUFFT=OFF \
    -D WITH_EIGEN=OFF \
    -D WITH_FFMPEG=ON \
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
    -D WITH_LIBV4L=ON \
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
    -D WITH_V4L=ON \
    -D WITH_VTK=OFF \
    -D WITH_WEBP=OFF \
    -D WITH_XIMEA=OFF \
    -D WITH_XINE=OFF \
    -D BUILD_opencv_apps=OFF \
    -D BUILD_opencv_highgui=ON \
    -D BUILD_opencv_python_bindings_generator=OFF \
    -D ENABLE_CXX=1 \
    ${CV_SOURCE_DIR}
	cd ../..


.PHONY: do_make
do_make:
	cd ${CV_BUILD_DIR} && make -j 4 

# opencv/build/lib/libopencv_java* 

# Define a target for each architecture
$(ARCH):
	@echo "Executing function for $@"
	mkdir -p natives/$@
	jar cvf ${BUILD_FOLDER}/opencv-native-$@.jar natives/$@

native_jars: $(ARCH)	
	jar cvf ${BUILD_FOLDER}/opencv-native.jar natives/*

.PHONY: deploy_native
# deploy_native_jars: native_jars
deploy_native_jars: 
	mvn deploy:deploy-file -DgroupId=opencv \
    -DartifactId=opencv-native \
    -Dversion=${FINAL_VERSION} \
    -Dfile=${BUILD_FOLDER}/opencv-native.jar \
    -Dclassifiers=osx_64,linux_64,windows_64,linux_arm64 \
    -Dfiles=${BUILD_FOLDER}/opencv-native-osx_64.jar,${BUILD_FOLDER}/opencv-native-linux_64.jar,${BUILD_FOLDER}/opencv-native-windows_64.jar,${BUILD_FOLDER}/opencv-native-linux_arm64.jar \
    -Dtypes=jar,jar,jar,jar \
    -Dpackaging=jar \
    -DrepositoryId=${REPOSITORYID} \
    -Durl=${URL}

# osx: clone cmake_nix do_make native_jars
