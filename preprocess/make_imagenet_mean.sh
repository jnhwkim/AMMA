#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

DATA=data/
TOOLS=../caffe/build/tools

$TOOLS/compute_image_mean $DATA/Pororo_ENGLISH3_1_train_lmdb \
  $DATA/Pororo_ENGLISH3_1_mean.binaryproto

echo "Done."
