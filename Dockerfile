FROM jupyter/r-notebook:7a0c7325e470

# Get the latest image tag at:
# https://hub.docker.com/r/jupyter/minimal-notebook/tags/
# Inspect the Dockerfile at:
# https://github.com/jupyter/docker-stacks/tree/master/minimal-notebook/Dockerfile
# install additional package...

ENV NB_UID=1000
ENV GRANT_SUDO=yes
#RUN conda update --quiet --yes -n base conda
#RUN conda install --quiet --yes geocoder lxml terminado numpy scipy requests pandas matplotlib html5lib rise folium pillow ipywidgets pip wheel
#RUN conda install -c plotly chart-studio
#RUN conda update --update-all

USER root
RUN apt-get update -y &&  apt-get install -y curl 
RUN ln -s /opt/conda/bin/pip /usr/bin/pip
RUN pip install okpy nbgitpuller
RUN jupyter serverextension enable nbgitpuller --sys-prefix
RUN groupadd -g 1000 jovyan
RUN usermod -G jovyan jovyan 
RUN mkdir /home/jovyan/library
RUN rm -fr /home/jovyan/work
RUN chown -R jovyan:jovyan /home/jovyan
RUN chmod -R 777 /home/jovyan/
RUN sed -i 's/env_reset/env_keep="http_proxy ftp_proxy https_proxy no_proxy"/g' /etc/sudoers
RUN echo 'jovyan    ALL=(ALL:ALL) NOPASSWD:ALL' >> /etc/sudoers
COPY *.sh /opt/
RUN chmod 777 /opt/*.sh

USER jovyan
RUN mkdir -p /opt/ipython
ENV IPYTHONDIR=/opt/ipython 
RUN ipython profile create default 
RUN sed -i 's/#c.HistoryAccessor.enabled = True/c.HistoryAccessor.enabled = False/g' /opt/ipython/profile_default/ipython_config.py
