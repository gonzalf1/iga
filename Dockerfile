FROM poad/docker-spark-amazon:2.2
MAINTAINER gonzalf1

ENV SPARK_HOME /usr/local/spark

RUN yum install -y python27-devel gcc pandoc python35-devel python35-libs python35-setuptools && \
    yum clean all

RUN /usr/bin/easy_install-3.5 pip &&\
    pip3 install --upgrade pip

RUN curl -s https://bootstrap.pypa.io/get-pip.py | python
RUN pip install jupyter && \
    pip install notebook && \
    pip install jupyterlab && \
    pip --no-cache-dir install pandas pyspark && \
    pip install py4j jupyter-spark lxml && \
    pip install --upgrade beautifulsoup4 html5lib && \
    jupyter nbextension install --py jupyter_spark && \
    jupyter serverextension enable --py jupyter_spark && \
    jupyter nbextension enable --py jupyter_spark && \
    jupyter nbextension enable --py widgetsnbextension

RUN jupyter notebook --generate-config --allow-root
COPY jupyter_notebook_config.py /root/.jupyter/jupyter_notebook_config.py

RUN pip install scipy scikit-learn pygments && \
    pip3 install scipy scikit-learn pygments pandas pyspark ipykernel ipython

#install R
RUN rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm && \
    yum -y install R
RUN rm -rf /var/cache/yum/* && \
    yum clean all

COPY bootstrap.sh /etc/bootstrap.sh

RUN chown root.root /etc/bootstrap.sh
RUN chmod 700 /etc/bootstrap.sh

EXPOSE 18080 7077 8888

ENTRYPOINT ["/etc/bootstrap.sh"]

