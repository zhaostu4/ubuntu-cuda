#FROM zhaostu4/ubuntu-env:nvida-cuda-8.0-devel
FROM nvidia/cuda:8.0-cudnn6-devel-ubuntu16.04

COPY File/ /root/

<<<<<<< HEAD

=======
>>>>>>> d3ecc2222dd9aab2b7e80198011e3677fa2f22fb
RUN mkdir /root/.pip && \
    mv /root/pip.conf /root/.pip/pip.conf && \
    mv /root/sources.list /etc/apt/sources.list 

RUN apt-get update && \
    apt-get install -y git wget vim tmux unzip

RUN cd /root/ && \
    wget -c https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.0.0.1-Linux-x86_64.sh && \
    chmod 777 /root/Anaconda3-5.0.0.1-Linux-x86_64.sh && \
    /root/Anaconda3-5.0.0.1-Linux-x86_64.sh -b && \
    echo export PATH="/root/anaconda3/bin:$PATH" >> /root/.bashrc && \
    rm -rf /root/Anaconda3-5.0.0.1-Linux-x86_64.sh

#RUN cd /root/ && \
#    /root/Anaconda3-5.0.0.1-Linux-x86_64.sh -b && \
#    echo export PATH="/root/anaconda3/bin:$PATH" >> /root/.bashrc && \
#    rm -rf /root/Anaconda3-5.0.0.1-Linux-x86_64.sh

ENV PATH /root/anaconda3/bin:$PATH

RUN conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/ && \
    conda config --set show_channel_urls yes && \
    conda install python=3.5

RUN pip install -r /root/requirements.txt

RUN apt-get install -y libc6-dev \
	openssh-server \
	linux-libc-dev:amd64 \
	libfreetype6-dev \
	pkg-config \
	--reinstall build-essential

# set ssh server config
RUN sed -i 's/UsePAM yes/UsePAM no/g' /etc/ssh/sshd_config &&\
	sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config &&\
	mkdir /var/run/sshd && \
	echo "root:zhao"|chpasswd

# install cocoapi
RUN 	cd /root/coco/PythonAPI &&\
	python3 setup.py build_ext --inplace  &&\
	python3 setup.py build_ext install &&\
	cd /root/ && \
	rm -rf /root/coco

# set expose port
EXPOSE 22

# set run images shell
CMD ["/usr/sbin/sshd","-D"]
