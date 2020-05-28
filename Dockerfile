FROM python:3.8.2

LABEL maintainer="ernestoe@gmail.com"

# Allow apt to work with https-based sources
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  apt-transport-https && rm -rf /var/lib/apt/lists/*

# Ensure we install an up-to-date version of Node
# See https://github.com/yarnpkg/yarn/issues/2888
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -

# Install packages
RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  r-base \
  httpie \
  jq \
  jo \
  tmux \
  vim \
  postgresql-client-11 \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Python packages
COPY requirements.txt .
RUN pip install --upgrade pip
RUN pip install -r requirements.txt
RUN python -m bash_kernel.install

# R Setup
RUN R -e "install.packages('IRkernel')"
RUN R -e "IRkernel::installspec(user = FALSE)"

# Setup with predetermined password
# COPY jupyter_notebook_config.json /root/.jupyter/

# Local project
COPY . .

# Default command - choose one
# CMD ["bash", "-l"]
# CMD ["jupyter", "notebook", "--notebook-dir=/usr/src/app/lab_app", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
CMD ["jupyter", "lab", "--notebook-dir=/usr/src/app/lab_app", "--port=8888", "--no-browser", "--ip=0.0.0.0", "--allow-root"]
