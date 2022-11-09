ARG BASE_IMAGE=jupyterhub/singleuser
FROM $BASE_IMAGE

USER root
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ARG DEBIAN_FRONTEND="noninteractive"
ENV TZ="Europe/Berlin"


# system and R pre-requisites
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc \
    git \
    ssh \
    nano \
    cron \
    mc \
    vim \
    htop \
    less \
    tcpdump \
    && rm -rf /var/lib/apt/lists/*

# set timezone in container
RUN echo "Europe/Berlin" > /etc/timezone
RUN ln -sf /usr/share/zoneinfo/Europe/Berlin /etc/localtime


# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar


RUN echo jovyan  ALL = NOPASSWD: ALL > /etc/sudoers.d/jovyan \
    && echo Defaults        secure_path="/opt/conda/bin:/home/jovyan/perl5/bin:/home/jovyan/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" >> /etc/sudoers.d/jovyan \
    && mkdir -p /usr/local/share/jupyter/kernels

USER $NB_UID

# R Dockerfile parts from
# https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile
# R packages and kernel
RUN conda update --all \
    && conda install --quiet --yes \
    'r-base' \
    'r-rcpp' \
    'r-caret' \
    'r-crayon*' \
    'r-devtools' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-randomforest' \
    'r-rcurl' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-tidyverse' \
    'unixodbc' \
    'r-tidymodels' \
    'r-plotly' \
    'r-e1071' \
    && conda clean --all -f -y \
    && fix-permissions "${CONDA_DIR}"


# go kernel
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
    golang
RUN env GO111MODULE=on go install github.com/gopherdata/gophernotes@v0.7.5 \
    && mkdir -p ~/.local/share/jupyter/kernels/gophernotes \
    && cd ~/.local/share/jupyter/kernels/gophernotes \
    && cp "$(go env GOPATH)"/pkg/mod/github.com/gopherdata/gophernotes@v0.7.5/kernel/*  "." \
    && chmod +w ./kernel.json \
    && sed "s|gophernotes|$(go env GOPATH)/bin/gophernotes|" < kernel.json.in > kernel.json \
    && sudo mv /home/jovyan/.local/share/jupyter/kernels/gophernotes /usr/local/share/jupyter/kernels
ENV GOPATH=/home/jovyan/go


# perl5 kernel
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
    libzmq3-dev \
    libczmq-dev \
    libzmq5 \
    cpanminus
ENV PERL5LIB=/home/jovyan/perl5/lib/perl5
RUN cpanm --notest Devel::IPerl namespace::autoclean Moo MooX::HandlesVia Import::Into Data::OptList Sub::Name MRO::Compat Sub::Exporter Params::Validate HTML::Entities \
    && /home/jovyan/perl5/bin/iperl kernelspec list \
    && sudo mv /home/jovyan/.local/share/jupyter/kernels/iperl /usr/local/share/jupyter/kernels


# JavaScript kernel
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
    build-essential
RUN sudo npm install -g --unsafe-perm ijavascript
RUN sudo ijsinstall --install=global

# ruby kernel
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
    libtool \
    libffi-dev \
    make \
    ruby \
    ruby-dev \
    libzmq3-dev \
    libczmq-dev
RUN sudo gem install ffi-rzmq bundler cztop
RUN sudo gem install iruby --pre
RUN sudo iruby register --force
RUN sudo cp -r /root/.local/share/jupyter/kernels/ruby /usr/local/share/jupyter/kernels


# Fortran kernel
# conda-forge fortran_kernel not compatible with python > 3.9.x
# RUN conda install -c conda-forge fortran_kernel
ENV FC=/usr/bin/gfortran
ENV CC=/usr/bin/gcc
RUN sudo apt-get update \
    && sudo apt-get install -y --no-install-recommends \
    cmake libcoarrays-dev libcoarrays-mpich-dev libcoarrays-openmpi-dev mpich libmpich-dev libopenmpi-dev \
    && mkdir /home/jovyan/src/ \
    && cd /home/jovyan/src/ \
    && git clone https://github.com/sourceryinstitute/OpenCoarrays.git \
    && cd OpenCoarrays \
    && git checkout -b OpenCoarrays_2.9.2 2.9.2 \
    && mkdir opencoarrays-build \
    && cd opencoarrays-build \
    && cmake /home/jovyan/src/OpenCoarrays -DCMAKE_INSTALL_PREFIX=/usr/local \
    && make \
    && sudo make install \
    && cd /home/jovyan/src/ \
    && git clone https://github.com/sourceryinstitute/jupyter-CAF-kernel \
    && cd jupyter-CAF-kernel/ \
    && pip install -e prebuild/jupyter-caf-kernel \
    && sudo jupyter-kernelspec install prebuild/jupyter-caf-kernel/Coarray-Fortran/



RUN conda update --all
RUN pip install pip --upgrade
RUN conda install -y -c conda-forge jupyterlab-git jupyter_contrib_nbextensions ipython numpy matplotlib scipy sympy nose numba pandas ipysheet ipywidgets jupyterlab-geojson papermill gspread oauth2client selenium s3fs boto3 wget
RUN jupyter labextension install @jupyter-widgets/jupyterlab-manager @jupyterlab/geojson-extension
# not yet compatible
# RUN jupyter labextension install @jupyterlab/metadata-extension @jupyterlab/dataregistry-extension @jupyterlab/commenting-extension
# does not work, enable in GUI
# RUN jupyter labextension install ipysheet
RUN jupyter lab clean && jupyter lab build --dev-build=False --minimize=False

RUN sudo chown -R jovyan /opt/conda/share/jupyter/lab \
    && sudo bash -c 'echo PATH="/opt/conda/bin:/home/jovyan/perl5/bin:/home/jovyan/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" > /etc/environment' \
    && sudo ln -s /opt/conda/bin/python /usr/bin/python \
    && sudo ln -s /opt/conda/bin/papermill /usr/bin/papermill \
    && rm -f ~/.bash_history

ENV PATH="/opt/conda/bin:/home/jovyan/perl5/bin:/home/jovyan/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin"
ENV USER=jovyan

# script to properly startup and register with jupyterhub
COPY start.sh start-from-jupyterhub.sh /usr/local/bin/
CMD ["start-from-jupyterhub.sh"]


WORKDIR /home

# Expose port to host
EXPOSE 8888
