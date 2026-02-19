
.DEFAULT_GOAL := release

CV_VERSION := 4.13.0
ORIGAMI_EXTRA_VERSION := 1
FINAL_VERSION := $(CV_VERSION)-$(ORIGAMI_EXTRA_VERSION)

CV_SOURCE_DIR := opencv
CV_BUILD_DIR := opencv/build
BUILD_FOLDER := build
NATIVES_FOLDER := natives

# Detect OS and Arch
UNAME_S := $(shell uname -s)
UNAME_M := $(shell uname -m)

# Map to our arch names
CURRENT_ARCH := unknown
LIB_EXT := so

ifeq ($(UNAME_S),Darwin)
    ifeq ($(UNAME_M),arm64)
        CURRENT_ARCH := osx_arm64
    else
        CURRENT_ARCH := osx_64
    endif
    LIB_EXT := dylib
else ifeq ($(UNAME_S),Linux)
    ifeq ($(UNAME_M),x86_64)
        CURRENT_ARCH := linux_64
    else ifeq ($(UNAME_M),aarch64)
        CURRENT_ARCH := linux_arm64
    endif
    LIB_EXT := so
endif

URL := https://repository.hellonico.info/repository/hellonico/
REPOSITORYID := vendredi

.PHONY: release clean deep-clean clone configure build package deploy

release: deep-clean clone configure build harvest deploy-core deploy-natives
	@echo "RELEASE $(FINAL_VERSION) COMPLETED"

# Only release natives (assumes core is already done)
release-natives: harvest deploy-natives

# Shortcut for building native lib from scratch (Clean -> Clone -> Build -> Harvest)
package-native: deep-clean clone configure build harvest
	@echo "Native library built and placed in $(NATIVES_FOLDER)/$(CURRENT_ARCH)"

# Shortcut for building on old/legacy systems (delegates to script)
package-native-legacy:
	chmod +x build_on_debian.sh
	./build_on_debian.sh

deep-clean:
	rm -fr $(CV_SOURCE_DIR) opencv_contrib $(BUILD_FOLDER)
	# We do NOT remove $(NATIVES_FOLDER) as it holds the accumulated binaries

clean:
	rm -fr $(CV_BUILD_DIR) $(BUILD_FOLDER)

clone:
	git clone --branch $(CV_VERSION) --depth 1 https://github.com/opencv/opencv.git $(CV_SOURCE_DIR)
	git clone --branch $(CV_VERSION) --depth 1 https://github.com/opencv/opencv_contrib.git opencv_contrib
	mkdir -p $(CV_BUILD_DIR)

configure:
	cd $(CV_BUILD_DIR) && cmake \
	-D CMAKE_BUILD_TYPE=RELEASE \
	-D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
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
	..

build:
	cd $(CV_BUILD_DIR) && make -j4

harvest:
	mkdir -p $(BUILD_FOLDER)
	mkdir -p $(NATIVES_FOLDER)/$(CURRENT_ARCH)
	# Copy native lib to the staging area (this is what you commit)
	find $(CV_BUILD_DIR)/lib -name "libopencv_java*.$(LIB_EXT)" -exec cp {} $(NATIVES_FOLDER)/$(CURRENT_ARCH)/ \;
	# Copy java jar to build folder
	find $(CV_BUILD_DIR)/bin -name "opencv-*.jar" -exec cp {} $(BUILD_FOLDER)/opencv.jar \;

deploy-core:
	@echo "Deploying Core to $(REPOSITORYID)"
	mvn deploy:deploy-file \
	  -DgroupId=opencv \
	  -DartifactId=opencv \
	  -Dversion=$(FINAL_VERSION) \
	  -Dpackaging=jar \
	  -Dfile=$(BUILD_FOLDER)/opencv.jar \
	  -DrepositoryId=$(REPOSITORYID) \
	  -Durl=$(URL) \
	  -DgeneratePom=true

deploy-natives:
	@echo "Deploying Natives to $(REPOSITORYID)"
	mkdir -p $(BUILD_FOLDER)
	# Create aggregate jar from ALL content in natives/
	jar cvf $(BUILD_FOLDER)/opencv-native.jar -C $(NATIVES_FOLDER) .
	
	# Create individual jars for each populated arch in natives/
	$(foreach arch,$(shell ls $(NATIVES_FOLDER)),\
		jar cvf $(BUILD_FOLDER)/opencv-native-$(arch).jar -C $(NATIVES_FOLDER)/$(arch) . ;)
	
	# Deploy the aggregate jar
	# constructing the classifiers string dynamically is hard in simple make
	# so we iterate and deploy what we have found, but really we should deploy one artifact with classifiers.
	# For simplicity/robustness, we will deploy the aggregate as the main artifact
	# And then try to attach others? No, maven deploy-file is tricky with dynamic classifiers.
	# Let's stick to deploying the aggregate 'opencv-native' artifact which contains everything.
	
	mvn deploy:deploy-file \
	  -DgroupId=opencv \
	  -DartifactId=opencv-native \
	  -Dversion=$(FINAL_VERSION) \
	  -Dpackaging=jar \
	  -Dfile=$(BUILD_FOLDER)/opencv-native.jar \
	  -DrepositoryId=$(REPOSITORYID) \
	  -Durl=$(URL) \
	  -DgeneratePom=true
