#
# jbliesener/sphinx-doc-portuguese
#
# A Docker image for the Sphinx documentation builder (http://sphinx-doc.org).
#
# docker build -t jbliesener/sphinx-doc-portuguese .

FROM       python:3.9.0-buster
MAINTAINER Jorg Neves Bliesener

RUN export DEBIAN_FRONTEND=noninteractive \
 && wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
 && add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ \
 && apt-get update

RUN wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - \
    && apt-get update && sudo apt-get install adoptopenjdk-8-hotspot \
    && apt-get install -y -q --no-install-recommends dvipng graphviz adoptopenjdk-8-hotspot sudo texlive texlive-lang-french texlive-latex-extra

RUN gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && curl -o /usr/local/bin/gosu     -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture)" \
 && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-$(dpkg --print-architecture).asc" \
 && gpg --verify /usr/local/bin/gosu.asc \
 && rm /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu \
 && apt-get autoremove -y -q

RUN apt-get upgrade -y -q
RUN apt-get install -y -q texlive-lang-portuguese latexmk

RUN rm -rf /var/cache/* \
 && rm -rf /var/lib/apt/lists/*

RUN pip install --upgrade pip \
 && pip install 'Sphinx                        == 1.8.5'  \
                'alabaster                     == 0.7.11' \
                'recommonmark                  == 0.4.0'  \
                'sphinx-autobuild              == 0.7.1'  \
                'sphinx-bootstrap-theme        == 0.6.5'  \
                'sphinx-prompt                 == 1.0.0'  \
                'sphinx_rtd_theme              == 0.4.1'  \
                'sphinxcontrib-actdiag         == 0.8.5'  \
                'sphinxcontrib-blockdiag       == 1.5.5'  \
                'sphinxcontrib-exceltable      == 0.2.2'  \
                'sphinxcontrib-googleanalytics == 0.1'    \
                'sphinxcontrib-googlechart     == 0.2.1'  \
                'sphinxcontrib-googlemaps      == 0.1.0'  \
                'sphinxcontrib-nwdiag          == 0.9.5'  \
                'sphinxcontrib-plantuml        == 0.12'   \
                'sphinxcontrib-seqdiag         == 0.8.5'  \
                'livereload                    == 2.5.2'

RUN pip install 'docxbuilder[math] == 1.2.0'

# RUN pip install sphinxcontrib-libreoffice == 0.2  # doesn't work

COPY files/opt/plantuml/*  /opt/plantuml/
COPY files/usr/local/bin/* /usr/local/bin/

RUN chown root:root /usr/local/bin/* \
 && chmod 755 /usr/local/bin/*

ENV DATA_DIR=/doc \
    JAVA_HOME=/usr/lib/jvm/java-8-oracle

WORKDIR $DATA_DIR

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
