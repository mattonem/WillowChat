FROM mattonem/pharodockerfile:pharo70 

MAINTAINER mattone.m@gmail.com

COPY update.st update.st
RUN ./pharo Pharo.image eval "(FileStream fileNamed: './update.st') fileIn."
EXPOSE 8080
ENTRYPOINT ["/pharo", "Pharo.image", "--no-quit"]
