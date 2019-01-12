FROM jupyterhub/singleuser

ARG NB_UID="1000"

# Update pip
RUN pip install --upgrade pip

#Create Exchange directory for nbgrader and make sure all users have permission
USER root
RUN cd /srv
RUN mkdir nbgrader
RUN cd nbgrader
RUN mkdir exchange
RUN cd..
RUN chmod -R ugo+rw nbgrader
USER $NB_ID

# Install nbgrader
RUN pip install nbgrader

# Create nbgrader profile and add nbgrader config
ADD nbgrader_config.py /etc/jupyter/nbgrader_config.py

# Install the nbgrader extensions
RUN jupyter nbextension install --sys-prefix --py nbgrader
RUN jupyter nbextension enable --sys-prefix --py nbgrader
RUN jupyter serverextension enable --sys-prefix --py nbgrader

RUN jupyter nbextension disable --sys-prefix create_assignment/main
RUN jupyter nbextension disable --sys-prefix formgrader/main --section=tree
RUN jupyter serverextension disable --sys-prefix nbgrader.server_extensions.formgrader

USER root
# Configure container startup
CMD ["start-singleuser.sh"]

USER $NB_ID
