#!/bin/bash

echo "Compiling: " $1
rm /usr/local/bin/gcc
rm /usr/local/bin/g++
ln -s /usr/bin/gcc-4.4 /usr/local/bin/gcc
ln -s /usr/bin/g++-4.4 /usr/local/bin/g++
nvcc -keep $1
rm /usr/local/bin/gcc
rm /usr/local/bin/g++
ln -s /usr/bin/gcc-5 /usr/local/bin/gcc
ln -s /usr/bin/g++-5 /usr/local/bin/g++

