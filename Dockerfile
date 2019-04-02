FROM ubuntu:16.04

MAINTAINER mattone.m@gmail.com

RUN apt update && apt install -y wget libcanberra-gtk-module unzip 
RUN 
wget -O - http://download.opensuse.org/repositories/devel:/languages:/pharo:/stable/xUbuntu_16.04/Release.key | apt-key add - && \
    echo "deb http://download.opensuse.org/repositories/devel:/languages:/pharo:/stable/xUbuntu_16.04/ ./" > /etc/apt/sources.list.d/pharo.list && \
    apt update && apt install -y pharo6-64-ui build-essential  && \
    apt-get clean 
RUN wget -O- get.pharo.org/61+vm | bash
COPY update.st update.st
RUN ./pharo Pharo.image eval "(FileStream fileNamed: './update.st') fileIn."
EXPOSE 8080
ENTRYPOINT ["/pharo", "Pharo.image", "--no-quit"]
