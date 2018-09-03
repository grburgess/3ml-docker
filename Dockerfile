FROM  grburgess/root5:finished

ENV LD_LIBRARY_PATH="/opt/MultiNest/lib:$LD_LIBRARY_PATH"
ENV MULTINEST=/opt/MultiNest

WORKDIR /opt

COPY installMultiNest.sh /opt/

RUN /bin/bash /opt/installMultiNest.sh

RUN pip install --upgrade pip && \
    pip install numpy scipy ipython jupyter pymultinest matplotlib h5py  seaborn pandas root_numpy pytest codecov  astropy==2.0.6 --ignore-installed six


RUN git clone https://github.com/giacomov/astromodels.git &&\
    cd astromodels  && python setup.py install &&\
    cd ../ && rm -rf astromodels


#RUN source /opt/root/bin/thisroot.sh


# RUN cd /opt/

RUN git clone https://github.com/giacomov/3ML.git &&\
    cd 3ML && python setup.py install &&\
    cd ../ && rm -rf 3ML


WORKDIR /
RUN cd /

RUN mkdir /workdir

ADD init.sh init.sh
#CMD source /opt/root/bin/thisroot.sh && python -c 'import ROOT'
# CMD ["usleep 10 && jupyter notebook --notebook-dir=/workdir --ip='*' --port=8888 --no-browser --allow-root"]
# ENTRYPOINT ["/bin/bash","--login","-c"]




#RUN pip install scipy
