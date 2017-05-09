#
# jbliesener/sphinx-doc-portuguese
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t jbliesener/sphinx-doc-portuguese .

FROM       ddidier/sphinx-doc
MAINTAINER Jorg Neves Bliesener

RUN apt-get update \
    && apt-get install texlive-lang-portuguese
