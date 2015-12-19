# VERSION 0.1.4

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
FROM gcr.io/google_appengine/base

MAINTAINER Eric Higgins <erichiggins@gmail.com>

# Create a virtualenv for the application dependencies.
# If you want to use Python 3, add the -p python3.4 flag.
RUN apt-get -q update && \
  apt-get install --no-install-recommends -y -q \
    build-essential python2.7 python2.7-dev python-pip git mercurial \
    unzip \
    python-numpy && \
  pip install -U pip && \
  pip install virtualenv && \
  virtualenv /env && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate. This ensures the application is executed within
# the context of the virtualenv and will have access to its dependencies.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

COPY appengine-python-vm-runtime-0.2.tar.gz /home/vmagent/python-runtime.tar.gz
# Install dependencies.
ADD requirements.txt /app/requirements.txt

RUN pip install --no-cache-dir /home/vmagent/python-runtime.tar.gz && \
    pip install --no-cache-dir -r /app/requirements.txt
    

EXPOSE 8080
RUN ln -s /home/vmagent/app /app
WORKDIR /app

# Configure the entrypoint with Managed VMs-essential configuration like "bind",
# but leave the rest up to the config file.
ENTRYPOINT ["/usr/bin/env", "gunicorn", "-b", "0.0.0.0:8080", "google.appengine.vmruntime.wsgi:meta_app", "--log-file=-", "-c", "gunicorn.conf.py"]
