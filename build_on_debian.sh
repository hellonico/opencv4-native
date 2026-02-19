#!/bin/bash
set -e

echo "Build script started (APT-FREE MODE)..."

# Ensure we have a place for tools
TOOLS_DIR=$(pwd)/_tools
mkdir -p "$TOOLS_DIR"

# Check for download tool
if command -v wget &> /dev/null; then
    DL_CMD="wget -q -O"
elif command -v curl &> /dev/null; then
    DL_CMD="curl -L -o"
else
    echo "Error: Neither wget nor curl found. Cannot download tools."
    exit 1
fi
echo "Using downloader: $DL_CMD (binary)"



# Version comparison function (returns 0=equal, 1=ver1>ver2, 2=ver1<ver2)
vercomp () {
    if [[ $1 == $2 ]]; then return 0; fi
    local IFS=.
    local i ver1=($1) ver2=($2)
    # fill empty fields in ver1 with zeros
    for ((i=${#ver1[@]}; i<${#ver2[@]}; i++)); do ver1[i]=0; done
    for ((i=0; i<${#ver1[@]}; i++)); do
        if [[ -z ${ver2[i]} ]]; then ver2[i]=0; fi
        if ((10#${ver1[i]} > 10#${ver2[i]})); then return 1; fi
        if ((10#${ver1[i]} < 10#${ver2[i]})); then return 2; fi
    done
    return 0
}

# 2. Python Check (Crucial for OpenCV bindings)
if command -v python3 &> /dev/null; then
    PY_VER=$(python3 -c 'import sys; print("%d.%d" % (sys.version_info.major, sys.version_info.minor))')
    echo "Found Python: $PY_VER"
    vercomp $PY_VER "3.6"
    if [[ $? == 2 ]]; then
        echo "WARNING: Python $PY_VER is older than 3.6. OpenCV build scripts using f-strings WILL FAIL."
        echo "Attempting to continue, but 'gen_java.py' errors are expected."
    fi
else
    echo "WARNING: python3 not found. Build may fail."
fi



# --- 1. CMake Check ---
NEED_CMAKE=0
if ! command -v cmake &> /dev/null; then
    echo "CMake not found."
    NEED_CMAKE=1
else
    CMAKE_VERSION=$(cmake --version | head -n1 | awk '{print $3}')
    echo "Found CMake: $CMAKE_VERSION"
    
    # SAFE CALL: Capture return code without triggering set -e
    set +e
    vercomp $CMAKE_VERSION "3.7"
    RES=$?
    set -e
    
    if [[ $RES == 2 ]]; then
        echo "CMake is too old (< 3.7)."
        NEED_CMAKE=1
    fi
fi

if [[ $NEED_CMAKE == 1 ]]; then
    # Portable CMake 3.22
    if [ ! -d "$TOOLS_DIR/cmake-3.22.1-linux-x86_64" ]; then
        echo "Downloading portable CMake 3.22..."
        $DL_CMD "$TOOLS_DIR/cmake.tar.gz" https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.tar.gz
        tar -xzf "$TOOLS_DIR/cmake.tar.gz" -C "$TOOLS_DIR"
        rm "$TOOLS_DIR/cmake.tar.gz"
    fi
    export PATH=$TOOLS_DIR/cmake-3.22.1-linux-x86_64/bin:$PATH
    echo "Now using CMake: $(cmake --version | head -n1)"
fi

# --- 2. Ant Check (Required for Java bindings) ---
# Some older ants are fine, but let's ensure we have one.
if ! command -v ant &> /dev/null; then
    echo "Ant not found. Installing portable Apache Ant..."
    if [ ! -d "$TOOLS_DIR/apache-ant-1.10.12" ]; then
        echo "Downloading portable Ant..."
        $DL_CMD "$TOOLS_DIR/ant.tar.gz" https://archive.apache.org/dist/ant/binaries/apache-ant-1.10.12-bin.tar.gz
        tar -xzf "$TOOLS_DIR/ant.tar.gz" -C "$TOOLS_DIR"
        rm "$TOOLS_DIR/ant.tar.gz"
    fi
    export PATH=$TOOLS_DIR/apache-ant-1.10.12/bin:$PATH
    echo "Now using Ant: $(ant -version)"
else
    echo "Found Ant: $(ant -version | head -n1)"
fi

# --- 3. Java Check (Informational) ---
if ! command -v javac &> /dev/null; then
    echo "WARNING: 'javac' not found. OpenCV Java bindings will likely fail."
    echo "Please install a JDK (e.g. openjdk-8-jdk) if possible, or ensure JAVA_HOME is set."
else
    echo "Found Java: $(java -version 2>&1 | head -n1)"
fi

# --- 4. Make Check ---
if ! command -v make &> /dev/null; then
     echo "Error: 'make' not found. Please install build-essential."
     exit 1
fi

# --- 5. Build ---
echo "Starting Build Sequence..."

echo "[1/5] Cleaning..."
make deep-clean

echo "[2/5] Cloning OpenCV..."
make clone

echo "[3/5] Configuring (CMake) with REDUCED SET (Pi-style)..."

# Define paths for manual cmake
CV_SOURCE_DIR=$(pwd)/opencv
CV_BUILD_DIR=$(pwd)/opencv/build

# Create build dir if not exists (make configure usually did this via mkdir -p)
mkdir -p "$CV_BUILD_DIR"
cd "$CV_BUILD_DIR"

# Run CMake with "Reduced/Arm" configuration
cmake \
    -D CMAKE_BUILD_TYPE=RELEASE \
    -G "Unix Makefiles" \
    -B "$CV_BUILD_DIR" \
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
    -D WITH_ADE=OFF \
    -D BUILD_opencv_gapi=OFF \
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
    "$CV_SOURCE_DIR"

# Go back to root for next steps
cd ../..

echo "[4/5] Building (Compiling)..."
make build

echo "[5/5] Harvesting Natives..."
make harvest

echo "Build Complete! Check 'natives/' folder."
