#!/bin/bash
# 
# Based on the work of Johannes BUCHNER
# https://gist.github.com/JohannoesBuchner/6579476
#
# Modification by Laurent DOUCHY
#
# - Force install on /opt
# - Remove bridge to R and Rserve
# 

echo 'checking installed software requirements'
for c in cmake; do
  if ! hash $c; then echo "install '$c' first"; exit 1; fi
done
# echo 'checking python package requirements'
# for p in scipy numpy matplotlib.pyplot; do
#   echo "import $p"
# done | python || exit 1

cd /opt/
git clone https://github.com/JohannesBuchner/MultiNest.git
pushd MultiNest
mkdir -p build modules
pushd build
cmake .. && make || exit 1
popd

export MULTINEST=$PWD
[ -e $MULTINEST/lib/libmultinest.so ] || exit 1

popd

cd ../
