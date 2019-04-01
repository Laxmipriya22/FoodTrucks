# start from base
FROM ubuntu:18.04
MAINTAINER Anil Pemmaraju <akmaharshi@anilkumar.me>

# install system-wide deps for python and node
#RUN apt update
#RUN apt -yqq upgrade
#RUN apt -yqq install python-pip python-dev curl gnupg

RUN apt-get update --fix-missing \
    && apt-get upgrade -y \
    && apt-get install alien -y \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    python-pip \
    python2.7 \
    python2.7-dev \
    ssh \
    && apt-get autoremove \
    && apt-get clean

RUN pip install -U "setuptools==3.4.1"
RUN pip install -U "pip==1.5.4"
RUN pip install -U "Mercurial==2.9.1"
RUN pip install -U "virtualenv==1.11.4"

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash
RUN apt-get install -yq nodejs

# copy our application code
ADD flask-app /opt/flask-app
WORKDIR /opt/flask-app

# fetch app specific deps
RUN npm install
RUN npm run build
RUN pip install -r requirements.txt

# expose port
EXPOSE 5000

# start app
CMD [ "python", "./app.py" ]
