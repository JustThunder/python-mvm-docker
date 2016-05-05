# VERSION 0.1.5

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries.
FROM gcr.io/google_appengine/python-compat-multicore

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
  virtualenv /env -p python2.7 && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate. This ensures the application is executed within
# the context of the virtualenv and will have access to its dependencies.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

# Install dependencies.
ADD requirements.txt /app/requirements.txt
# Add the default gunicorn configuration file to the app directory. This
# default file will be overridden if the user adds a file called
# "gunicorn.conf.py" to their app's root directory.
ADD gunicorn.conf.py /app/gunicorn.conf.py

RUN pip install --no-cache-dir -r /app/requirements.txt
    

EXPOSE 8080
RUN ln -s /home/vmagent/app /app
WORKDIR /app
