FROM jupyterhub/jupyterhub:latest

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN apt-get update --fix-missing
RUN apt-get full-upgrade -y
RUN apt-get install -y wget bzip2 ca-certificates \
    libglib2.0-0 libxext6 libsm6 libxrender1 \
    curl grep sed dpkg git mercurial subversion mc procps net-tools iproute2

# set timezone in container
RUN echo "Europe/Berlin" > /etc/timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime

RUN pip install pip --upgrade
RUN pip install dockerspawner
RUN pip install oauthenticator
