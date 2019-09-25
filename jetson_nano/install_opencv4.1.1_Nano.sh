#!/bin/bash
#
# OpenCV 4.4.1 on Jetson Nano
#
#   One command to compile opencv-4.1.1 from source.
#
# Fork of AastaNV
# https://github.com/AastaNV/JEP/blob/master/script/install_opencv4.0.0_Nano.sh
#
CURRENT_PATH=($PWD)
echo 'This will compile opencv-4.1.1 for the jetson-nano'
echo '** ** ** ** ** ** ** ** ** ** **'

echo "** Setting Jetson Nano to 10W performance mode, and spin da fan"
sudo nvpmodel -m 0
sudo jetson_clocks

echo "** Remove OpenCV3.3 first"
sudo apt-get remove python3-opencv
sudo apt-get purge *libopencv*
sudo apt-get autoremove

echo "** Install requirements"
sudo apt-get update
sudo apt-get install -y build-essential ccache cmake unzip pkg-config
sudo apt-get install -y flake8 pylint -y
sudo apt-get install -y libgflags-dev libhdf5-dev libhdf5-serial-dev hdf5-tools liblmdb-dev libleveldb-dev
sudo apt-get install -y libgtk2.0-dev libcanberra-gtk-module
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libtbb-dev libeigen3-dev liblapacke-dev libblas-dev libopenblas-dev libatlas-base-dev gfortran
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev libgstreamer-plugins-bad1.0-0
sudo apt-get install -y python2.7-dev python3.6-dev python-dev python-numpy python3-numpy
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
sudo apt-get install -y libv4l-dev v4l-utils qv4l2 v4l2ucp
sudo apt-get install ffmpeg libxvidcore-dev libx264-dev -y
sudo apt-get install -y curl

# May not find
sudo apt-get install -y libjasper-dev

sudo apt-get update
sudo apt-get autoremove

echo "** Download opencv-4.1.1"
cd /opt/OpenCV
curl -L https://github.com/opencv/opencv/archive/4.1.1.zip -o opencv-4.1.1.zip
curl -L https://github.com/opencv/opencv_contrib/archive/4.1.1.zip -o opencv_contrib-4.1.1.zip
unzip opencv-4.1.1.zip 
unzip opencv_contrib-4.1.1.zip 
cd opencv-4.1.1/

echo "** Building..."
mkdir build
cd build/
cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D ENABLE_FAST_MATH=1 \
    -D WITH_CUBLAS=1 \
    -D WITH_CUDA=ON \
    -D CUDA_ARCH_BIN="7.5" \
    -D CUDA_ARCH_PTX="" \
    -D CUDA_FAST_MATH=ON \
    -D OPENCV_ENABLE_NONFREE=ON \
    -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib-4.1.1/modules \
    -D WITH_GSTREAMER=ON \
    -D WITH_LIBV4L=ON \
    -D BUILD_opencv_cudacodec=OFF \
    -D BUILD_opencv_python2=OFF \
    -D BUILD_opencv_python3=ON \
    -D BUILD_TESTS=OFF \
    -D BUILD_PERF_TESTS=OFF \
    -D CMAKE_INSTALL_PREFIX=/usr/local ..
    -D CMAKE_CXX_FLAGS="" ..
#    -D BUILD_PROTOBUF=ON \
#    -D BUILD_opencv_world=ON \
#    -D BUILD_EXAMPLES=ON \

# Disabled: python2 world
# Unavailable: cnn_3dobj cvv java js matlab ovis sfm ts viz
# Not found : jasper libavresample protobuf glog tesseract gtk3+ vfpv3

make -j3
sudo make install

echo "** Install python3 binding"
cd python_loader
workon cv
sudo python3 setup.py install
pip3 install numpy

sudo ldconfig
cd ~/.virtualenvs/cv/lib/python3.6/site-packages/
ln -s /usr/local/lib/python3.6/dist-packages/cv2 cv2
cd ~

echo "** OpenCV-4.1.1 successfully installed"
echo "** Bye :)"

