FROM debian:buster

# base packages
RUN apt-get -y update && apt-get install -y jupyter curl software-properties-common git jq

# base packages requiring pip install
RUN python3 -m pip install bash_kernel && python3 -m bash_kernel.install
RUN python3 -m pip install datalad datalad-container

# docker client installation
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
RUN add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
RUN apt-get -y update && apt-get install -y docker-ce-cli

# neurodebian and git-annex-standalone (for git annex version above git-annex package)
RUN curl http://neuro.debian.net/lists/buster.us-nh.libre | tee /etc/apt/sources.list.d/neurodebian.sources.list
RUN apt-key adv --recv-keys --keyserver hkp://pool.sks-keyservers.net:80 0xA5D32F012649A5A9
RUN apt-get -y update
RUN apt-get install -y git-annex-standalone

RUN git config --global user.name 'ReproNim Example User'
RUN git config --global user.email repronim@example.com

COPY anat.nii.gz /anat.nii.gz
COPY how-would-repronim-vol-1.ipynb /how-would-repronim-vol-1.ipynb
COPY how-would-repronim-vol-1.sh /how-would-repronim-vol-1.sh

EXPOSE 8888
ENTRYPOINT ["/how-would-repronim-vol-1.sh"]

# eof
