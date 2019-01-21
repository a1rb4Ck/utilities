#!/bin/bash
#
# Deep Learning on Intel Skykake Celeron 3955U
#
#   One command to install all mandatory dependencies.
#
echo 'This will install Tensorflow in a "cv" virtualenv'
exho '  custom build from sources without AVX support.'
echo '** ** ** ** ** ** ** ** ** ** **'

workon CV
pip3 uninstall tensorflowjs -y
pip3 uninstall keras -y
pip3 uninstall tensorflow -y
# tensorflow no AVX wheel
# https://github.com/yaroslavvb/tensorflow-community-wheels
pip3 install https://github.com/Anacletus/tensorflow-wheels/raw/master/v11.0/tensorflow-1.11.0-cp36-cp36m-linux_x86_64.whl

pip3 install keras==2.2.2
pip3 install tensorflowjs==0.6.5

# Build from source
cd ~
workon CV
wget https://github.com/bazelbuild/bazel/releases/download/0.20.0/bazel-0.20.0-installer-linux-x86_64.sh
chmod +x bazel-0.20.0-installer-linux-x86_64.sh
./bazel-0.20.0-installer-linux-x86_64.sh --user
echo '' >> ~/.zshrc
echo 'export PATH=$PATH:$HOME/bin' >> ~/.zshrc


sudo apt-get install openmpi-bin libopenmpi-dev libhdf5-dev
workon CV
pip3 install mock
pip3 install keras_Applications==1.0.6 --no-deps
pip3 install keras_Preprocessing==1.0.5 --no-deps
cd ~
git clone https://github.com/tensorflow/tensorflow.git
cd tensorflow
git checkout -b v1.12.0
echo ''
echo '** Please build WITH Google Cloud GCP support to YES'
echo '**     but everything else to NO'
echo ''
./configure

bazel build --config=opt //tensorflow/tools/pip_package:build_pip_package
# --config=noaws --config=nogcp --config=nohdfs --config=noignite --config=nokafka

sudo ./tensorflow/tools/pip_package/build_pip_package.sh /tensorflow_pkg
pip3 install ./tensorflow_pkg/tensorflow-1.12.0-cp36-cp36m-linux_x86_64.whl

echo '** DONE'

