#!/bin/bash

: ${HADOOP_PREFIX:=/usr/local/hadoop}

${HADOOP_PREFIX}/etc/hadoop/hadoop-env.sh

rm /tmp/*.pid

# installing libraries if any - (resource urls added comma separated to the ACP system variable)
cd ${HADOOP_PREFIX}/share/hadoop/common ; for cp in ${ACP//,/ }; do  echo == $cp; curl -LO $cp ; done; cd -

# altering the core-site configuration
sed s/HOSTNAME/$HOSTNAME/ /usr/local/hadoop/etc/hadoop/core-site.xml.template > /usr/local/hadoop/etc/hadoop/core-site.xml

# setting spark defaults
cp ${SPARK_HOME}/conf/metrics.properties.template ${SPARK_HOME}/conf/metrics.properties

if [ ! -e /tmp/spark-events ]
then
 mkdir -p /tmp/spark-events
fi 

HADOOP_CONF_DIR=$HADOOP_PREFIX/etc/hadoop
HADOOP_YARN_HOME=$HADOOP_PREFIX

service sshd start
$HADOOP_PREFIX/sbin/hadoop-daemon.sh --config $HADOOP_CONF_DIR --script hdfs start namenode
$HADOOP_PREFIX/sbin/hadoop-daemons.sh --config $HADOOP_CONF_DIR --script hdfs start datanode
$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start resourcemanager
$HADOOP_YARN_HOME/sbin/yarn-daemon.sh --config $HADOOP_CONF_DIR start proxyserve$HADOOP_PREFIX/sbin/mr-jobhistory-daemon.sh --config $HADOOP_CONF_DIR start historyserverr

#${HADOOP_PREFIX}/sbin/start-dfs.sh
#${HADOOP_PREFIX}/sbin/start-yarn.sh

#${SPARK_HOME}/sbin/start-master.sh
${SPARK_HOME}/sbin/start-history-server.sh

${SPARK_HOME}/bin/spark-class org.apache.spark.deploy.master.Master&

jupyter lab
