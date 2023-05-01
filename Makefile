say_hello:
	echo "Hello World"

export CV_VERSION=4.7.0
export CV_SOURCE_DIR=`realpath opencv`
export CV_BUILD_DIR=${CV_SOURCE_DIR/build}
export GENERATOR_NAME="Unix Makefiles"
export BUILD_FOLDER=build

export arch=("linux_arm" "linux_arm64" "windows_64" "windows_32" "osx_64" "osx_arm64" "linux_64" "linux_32")

clean:
	 rm -fr opencv/ opencv_contrib/

clone: clean
	git clone --branch ${CV_VERSION} --depth 1 https://github.com/opencv/opencv.git opencv
	git clone --branch ${CV_VERSION} --depth 1 https://github.com/opencv/opencv_contrib.git opencv_contrib

clean: clone
	rm -fr ${CV_BUILD_DIR}
	mkdir -p ${CV_BUILD_DIR}
	echo "${CV_BUILD_DIR} clean" 

cmake_nix: 
	cd ${CV_BUILD_DIR}
	echo ${CV_BUILD_DIR}
	cmake \
	-D CMAKE_BUILD_TYPE=RELEASE \
	-G "${GENERATOR_NAME}" \
	--build ${CV_BUILD_DIR} \
	-D OPENCV_EXTRA_MODULES_PATH=${CV_SOURCE_DIR}/../opencv_contrib/modules \
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
	-D WITH_FFMPEG=OFF \
	-D WITH_GDAL=OFF \
	-D WITH_GPHOTO2=OFF \
	-D WITH_GIGEAPI=ON \
	-D WITH_GSTREAMER=OFF \
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
	-D WITH_PTHREADS_PF=ON \
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

build:
	cd ${CV_BUILD_DIR}
	# make -j $(($(nproc) + 1))
	make -j 4  

native-jar:
	for i in "${arch[@]}"
	do
		echo "building $i"
		jar cvf ${BUILD_FOLDER}/opencv-native-$i.jar natives/$i
	done
	jar cvf ${BUILD_FOLDER}/opencv-native.jar natives/*