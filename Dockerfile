# VERSION 0.1.3

# The Google App Engine python runtime is Debian Jessie with Python installed
# and various os-level packages to allow installation of popular Python
# libraries. The source is on github at:
#   https://github.com/GoogleCloudPlatform/python-docker
FROM gcr.io/google_appengine/python

MAINTAINER Eric Higgins <erichiggins@gmail.com>

# Create a virtualenv for the application dependencies.
# If you want to use Python 3, add the -p python3.4 flag.
RUN apt-get -q update && \
  apt-get install --no-install-recommends -y -q \
    unzip \
    python-numpy && \
  virtualenv /env && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Set virtualenv environment variables. This is equivalent to running
# source /env/bin/activate. This ensures the application is executed within
# the context of the virtualenv and will have access to its dependencies.
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH
# GAE Python SDK.
ENV SDK_VERSION 1.9.30
ENV SDK_URL https://storage.googleapis.com/appengine-sdks/featured/google_appengine_${SDK_VERSION}.zip
ENV PKG_PATH ${VIRTUAL_ENV}/local/lib/python2.7/site-packages/

# Install dependencies.
ADD $SDK_URL /google_appengine.zip
ADD requirements.txt /app/requirements.txt
ADD google_appengine.pth $PKG_PATH

RUN pip install --no-cache-dir -r /app/requirements.txt && \
    unzip -q /google_appengine.zip -d / && \
    rm -rf /google_appengine.zip && \
    ls -al /
