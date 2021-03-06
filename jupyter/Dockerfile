ARG BASE_IMAGE=jupyterhub/singleuser
FROM $BASE_IMAGE


# R Dockerfile parts from
# https://github.com/jupyter/docker-stacks/blob/master/r-notebook/Dockerfile

USER root

# system and R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
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
    && rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

USER $NB_UID

# R packages
RUN conda install --quiet --yes \
    'r-base=4.0.0' \
    'r-caret=6.*' \
    'r-crayon=1.3*' \
    'r-devtools=2.3*' \
    'r-forecast=8.12*' \
    'r-hexbin=1.28*' \
    'r-htmltools=0.4*' \
    'r-htmlwidgets=1.5*' \
    'r-irkernel=1.1*' \
    'r-nycflights13=1.0*' \
    'r-randomforest=4.6*' \
    'r-rcurl=1.98*' \
    'r-rmarkdown=2.2*' \
    'r-rodbc=1.3*' \
    'r-rsqlite=2.2*' \
    'r-shiny=1.4*' \
    'r-tidyverse=1.3*' \
    'unixodbc=2.3.*' \
    'r-tidymodels=0.1*' \
    'r-plotly=4.*' \
    && \
    conda clean --all -f -y && \
    fix-permissions "${CONDA_DIR}"

# Install e1071 R package (dependency of the caret R package)
RUN conda install --quiet --yes r-e1071



# JavaScript kernel
USER root
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential
RUN npm install -g --unsafe-perm ijavascript
RUN ijsinstall --install=global

# ruby kernel
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    libtool \
    libffi-dev \
    make \
    ruby \
    ruby-dev \
    libzmq3-dev \
    libczmq-dev
RUN gem install ffi-rzmq bundler cztop
RUN gem install iruby --pre
RUN iruby register --force
RUN cp -r /home/jovyan/.local/share/jupyter/kernels/ruby /usr/local/share/jupyter/kernels

# Fortran kernel
RUN conda install -c conda-forge fortran_kernel


# install extensions and rebuild jupyter lab
# arcgis leads to conflicts
#    && conda install -y -c esri arcgis \
RUN conda update -n base conda \
    && pip install pip --upgrade \
    && pip install jupyterlab_scheduler papermill datawrapper gspread oauth2client gspread_dataframe selenium s3fs boto3 wget \
    && conda install -y -c conda-forge \
       jupyterlab-git jupyter_contrib_nbextensions \
       ipython numpy matplotlib scipy sympy nose numba pandas ipysheet ipywidgets \
    && jupyter lab build \
    && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
    && jupyter labextension install @jupyterlab/github \
    && jupyter labextension install ipysheet

RUN chown -R jovyan /opt/conda/share/jupyter/lab \
    && echo jovyan  ALL = NOPASSWD: ALL > /etc/sudoers.d/jovyan \
    && echo Defaults        secure_path="/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" >> /etc/sudoers.d/jovyan \
    && echo PATH="/opt/conda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin" > /etc/environment \
    && ln -s /opt/conda/bin/python /usr/bin/python \
    && ln -s /opt/conda/bin/papermill /usr/bin/papermill


ENV USER=jovyan

USER $NB_UID

# script to properly startup and register with jupyterhub
COPY start.sh start-from-jupyterhub.sh /usr/local/bin/
CMD ["start-from-jupyterhub.sh"]


WORKDIR /home
RUN pwd

# Expose port to host
EXPOSE 8888
