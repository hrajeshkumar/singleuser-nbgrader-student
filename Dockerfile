FROM jupyterhub/singleuser

# Update pip
RUN pip install --upgrade pip

# Install nbgrader
RUN pip install nbgrader

# Install the nbgrader extensions
#RUN nbgrader extension install

# Create nbgrader profile and add nbgrader config
ADD nbgrader_config.py /etc/jupyter/nbgrader_config.py

# Install the nbgrader extensions
RUN jupyter nbextension install --sys-prefix --py nbgrader
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader

ARG NB_UID="1000"

USER root
# Configure container startup
CMD ["start-singleuser.sh"]

USER $NB_ID
