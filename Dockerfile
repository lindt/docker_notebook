FROM alpine
MAINTAINER think@hotmail.de

# TODO: combine steps
RUN apk add --no-cache python3
RUN apk add --no-cache --virtual=build-dependencies
RUN apk add --no-cache --virtual=ca-certificates
RUN apk add --no-cache --virtual=gcc wget
RUN apk add --no-cache --virtual=linux-headers
RUN apk add --no-cache --virtual=python3-dev
RUN apk add --no-cache --virtual=glibc-dev
RUN apk add --no-cache --virtual=g++
RUN apk add --no-cache --virtual=texlive
RUN  wget "https://bootstrap.pypa.io/get-pip.py" -O /dev/stdout | python3 
RUN  pip3 install --no-cache-dir notebook ipywidgets pandoc
RUN apk add --no-cache --virtual=curl

# TODO: RUN  apk del build-dependencies gcc ca-certificates g++ python3-dev

RUN echo "#!/bin/sh\npython3 -m pandoc $@" > /usr/bin/pandoc && chmod +x /usr/bin/pandoc

RUN \
  # Notebook - TOC
  mkdir -p $(ipython locate)/profile_default/static/custom && \
  touch $(ipython locate)/profile_default/static/custom/custom.js && \
  touch $(ipython locate)/profile_default/static/custom/custom.css && \
  curl -L https://rawgithub.com/minrk/ipython_extensions/master/nbextensions/toc.js > $(ipython locate)/nbextensions/toc.js && \
  curl -L https://rawgithub.com/minrk/ipython_extensions/master/nbextensions/toc.css > $(ipython locate)/nbextensions/toc.css && \
  echo '$([IPython.events]).on("app_initialized.NotebookApp", function () { IPython.load_extensions("toc"); });' >> $(ipython locate)/profile_default/static/custom/custom.js && \
  echo 'require(["components/codemirror/addon/display/rulers"]); var clsname = "ipynb_ruler"; var rulers = [{column: 79, className: clsname},               {column: 99, className: clsname}]; IPython.Cell.options_default.cm_config.rulers = rulers;' >> $(ipython locate)/profile_default/static/custom/custom.js

# Notebook - Notify \
#  curl -L https://raw.github.com/sjpfenninger/ipython-extensions/master/nbextensions/notify.js > $(ipython locate)/nbextensions/notify.js && \
#  echo '$([IPython.events]).on("app_initialized.NotebookApp", function () { IPython.load_extensions('notify'); });' >> $(ipython locate)/profile_default/static/custom/custom.js
#   && \

RUN \
  ipython install-nbextension https://raw.githubusercontent.com/ipython-contrib/IPython-notebook-extensions/master/nbextensions/usability/dragdrop/main.js

ADD examples /notebook

CMD \
  ["jupyter", "notebook", "--ip", "0.0.0.0", "/notebook"]
