FROM ubuntu:14.04

COPY cudatoolkit_4.0.17_linux_64_ubuntu10.10.run /home/
COPY .bashrc /home/

RUN apt-get update -qq && apt-get install -y gcc-4.4 g++-4.4 git build-essential xutils-dev bison zlib1g-dev flex libglu1-mesa-dev doxygen graphviz libxi-dev libxmu-dev freeglut3-dev git-core vim gdb
RUN cd /home && printf "\n" | sh cudatoolkit_4.0.17_linux_64_ubuntu10.10.run 
RUN ln -s /usr/bin/gcc-4.4 /usr/local/cuda/bin/gcc && ln -s /usr/bin/g++-4.4 /usr/local/cuda/bin/g++
RUN rm -rf /var/lib/apt/lists/*

CMD ["/bin/bash"]
