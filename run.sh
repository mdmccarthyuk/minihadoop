#!/bin/bash
export SPARK_DIST_CLASSPATH=`$HADOOP_PREFIX/bin/hadoop classpath`

$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode -format
$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR namenode &
$HADOOP_PREFIX/bin/hdfs --config $HADOOP_CONF_DIR datanode &
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR resourcemanager &
$HADOOP_PREFIX/bin/yarn --config $HADOOP_CONF_DIR nodemanager &

# Because /tmp wasn't always being created due to the service not being up
sleep 5

$HADOOP_PREFIX/bin/hdfs dfs -mkdir /tmp
$HADOOP_PREFIX/bin/hdfs dfs -mkdir /user
$HADOOP_PREFIX/bin/hdfs dfs -mkdir /user/hive
$HADOOP_PREFIX/bin/hdfs dfs -mkdir /user/hive/warehouse
$HADOOP_PREFIX/bin/hdfs dfs -chmod g+w /tmp
$HADOOP_PREFIX/bin/hdfs dfs -chmod g+w /user/hive/warehouse
$HIVE_HOME/bin/hiveserver2 &

while sleep 60; do
  ps aux |grep nodemanager|grep -q -v grep
  STATUS=$?
  if [ $STATUS -ne 0 ]; then
    exit 1
  fi
done
