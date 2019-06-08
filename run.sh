#!/bin/bash
export HADOOP_PREFIX=/opt/hadoop
export HIVE_HOME=/opt/hive
export HADOOP_CONF_DIR=/etc/hadoop
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -format
$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode &
$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode &
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager &
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR nodemanager &

$HADOOP_PREFIX/bin/hdfs dfs -mkdir /tmp
$HADOOP_PREFIX/bin/hdfs dfs -mkdir /user
$HADOOP_PREFIX/bin/hdfs dfs -mkdir /user/hive
$HADOOP_PREFIX/bin/hdfs dfs -mkdir /user/hive/warehouse
$HADOOP_PREFIX/bin/hdfs dfs -chmod g+w /tmp
$HADOOP_PREFIX/bin/hdfs dfs -chmod g+w /user/hive/warehouse
export HADOOP_USER_CLASSPATH_FIRST=true
$HIVE_HOME/bin/hiveserver2 &

while sleep 60; do
  ps aux |grep nodemanager|grep -q -v grep
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    exit 1
  fi
done
