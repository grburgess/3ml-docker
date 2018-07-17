FROM centos

RUN yum install -y epel-release

RUN yum -y install gcc git curl make zlib-devel bzip2 bzip2-devel \
                   readline-devel sqlite sqlite-devel openssl \
                   openssl-devel patch libjpeg libpng12 libX11 \
                   which libXpm libXext curlftpfs wget libgfortran file \
                   ruby-devel fpm rpm-build \
                   ncurses-devel \
                   libXt-devel \
                   gcc gcc-c++ gcc-gfortran \
                   perl-ExtUtils-MakeMaker \
                   net-tools strace sshfs sudo iptables

RUN yum install -y git cmake gcc-c++ gcc binutils libX11-devel libXpm-devel libXft-devel libXext-devel gcc-gfortran openssl-devel pcre-devel mesa-libGL-devel mesa-libGLU-devel glew-devel ftgl-devel mysql-devel fftw-devel cfitsio-devel graphviz-devel avahi-compat-libdns_sd-devel libldap-dev python-devel libxml2-devel gsl-static
RUN yum install -y  compat-gcc-44 compat-gcc-44-c++ compat-gcc-44-c++.gfortran python-pip atlas-devel lapack-devel blas-devel


WORKDIR /opt/

ENV ROOTSYS="/opt/root/"
ENV PATH="$ROOTSYS/bin:$PATH"
ENV LD_LIBRARY_PATH="$ROOTSYS/lib:$LD_LIBRARY_PATH"



RUN cd /opt && wget https://root.cern.ch/download/root_v5.34.36.source.tar.gz &&\
    tar xvzf root_v5.34.36.source.tar.gz &&\
    rm -f root_v5.34.36.source.tar.gz
RUN cd root && mkdir root_build
WORKDIR /opt/root_build
RUN cmake -Dpython=ON -Droofit=OFF -Dxrootd=OFF -Dminuit2=ON -Dtmva=OFF -Dpythia8=OFF -DCMAKE_INSTALL_PREFIX:PATH=/opt/root  ../root &&\
     make && make install 


ENV PATH=$ROOTSYS/bin:$PATH
ENV PYTHONDIR=$ROOTSYS
ENV LD_LIBRARY_PATH=$ROOTSYS/lib:$PYTHONDIR/lib:$ROOTSYS/bindings/pyroot:$LD_LIBRARY_PATH
ENV PYTHONPATH=$ROOTSYS/lib:$PYTHONPATH:$ROOTSYS/bindings/pyroot

ENV LD_LIBRARY_PATH="/opt/MultiNest/lib:$LD_LIBRARY_PATH"
ENV MULTINEST=/opt/MultiNest


WORKDIR /opt

COPY installMultiNest.sh /opt/

RUN /bin/bash /opt/installMultiNest.sh

RUN pip install --upgrade pip && \
    pip install numpy scipy ipython jupyter pymultinest matplotlib h5py  seaborn pandas root_numpy  astropy==2.0.6 --ignore-installed six


RUN git clone https://github.com/giacomov/astromodels.git &&\
    cd astromodels && python setup.py install &&\
    cd ../ && rm -rf astromodels


#RUN source /opt/root/bin/thisroot.sh


# RUN cd /opt/

RUN git  clone https://github.com/giacomov/3ML.git &&\
    cd 3ML && git checkout polar  &&  python setup.py install &&\
    cd ../



WORKDIR /
RUN cd /

RUN mkdir /workdir

ADD init.sh init.sh
#CMD source /opt/root/bin/thisroot.sh && python -c 'import ROOT'
CMD ["usleep 10 && jupyter notebook --notebook-dir=/workdir --ip='*' --port=8888 --no-browser --allow-root"]
ENTRYPOINT ["/bin/bash","--login","-c"]




#RUN pip install scipy
