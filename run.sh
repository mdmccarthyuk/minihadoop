#!/bin/bash
export HADOOP_PREFIX=/opt/hadoop/
export HADOOP_CONF_DIR=/etc/hadoop
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -format
$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode &
$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode &
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager &
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR nodemanager &

while sleep 60; do
  ps aux |grep nodemanager|grep -q -v grep
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    exit 1
  fi
done
