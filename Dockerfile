FROM debian:9

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
      openjdk-8-jdk \
      net-tools \
      curl \
      netcat \
      gnupg \
      procps \
      python
      
ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64/
ENV HADOOP_VERSION 2.6.5
ENV HADOOP_URL https://www.apache.org/dist/hadoop/common/hadoop-$HADOOP_VERSION/hadoop-$HADOOP_VERSION.tar.gz
ENV HIVE_HOME /opt/hive
ENV HIVE_VERSION 1.2.2 
ENV HIVE_URL https://www.apache.org/dist/hive/hive-$HIVE_VERSION/apache-hive-$HIVE_VERSION-bin.tar.gz
ENV SPARK_VERSION 1.6.0
ENV SPARK_URL https://archive.apache.org/dist/spark/spark-$SPARK_VERSION/spark-$SPARK_VERSION-bin-without-hadoop.tgz
ENV HADOOP_USER_CLASSPATH_FIRST true

RUN set -x \
    && curl -fSL "$HADOOP_URL" -o /tmp/hadoop.tar.gz \
    && tar -xvf /tmp/hadoop.tar.gz -C /opt/ \
    && rm /tmp/hadoop.tar.gz \
    && curl -fSL "$SPARK_URL" -o /tmp/spark.tar.gz \
    && tar -xvf /tmp/spark.tar.gz -C /opt/ \
    && rm /tmp/spark.tar.gz \
    && curl -fSL "$HIVE_URL" -o /tmp/hive.tar.gz \
    && tar -xvf /tmp/hive.tar.gz -C /opt/ \
    && rm /tmp/hive.tar.gz \
    && mkdir -p /etc/spark/conf \
    && mkdir /tmp/spark-events

RUN ln -s /opt/hadoop-$HADOOP_VERSION/etc/hadoop /etc/hadoop
RUN mkdir /opt/hadoop-$HADOOP_VERSION/logs
RUN ln -s /opt/hadoop-$HADOOP_VERSION /opt/hadoop
RUN ln -s /opt/apache-hive-$HIVE_VERSION-bin /opt/hive
RUN ln -s /opt/spark-$SPARK_VERSION-bin-without-hadoop /opt/spark

ENV HADOOP_PREFIX=/opt/hadoop-$HADOOP_VERSION
ENV HADOOP_CONF_DIR=/etc/hadoop
ENV SPARK_CONF_DIR=/etc/spark/conf
ENV USER=root
ENV PATH /opt/hadoop/bin/:/opt/spark/bin:/opt/hive/bin:$PATH

ADD conf/core-site.xml /etc/hadoop/core-site.xml
ADD conf/hdfs-site.xml /etc/hadoop/hdfs-site.xml
ADD conf/yarn-site.xml /etc/hadoop/yarn-site.xml
ADD conf/httpfs-site.xml /etc/hadoop/httpfs-site.xml
ADD conf/kms-site.xml /etc/hadoop/kms-site.xml
ADD conf/mapred-site.xml /etc/hadoop/mapred-site.xml
ADD conf/capacity-scheduler.xml /etc/hadoop/capacity-scheduler.xml
ADD conf/spark-defaults.conf /etc/spark/conf/spark-defaults.conf

ADD run.sh /run.sh
RUN chmod a+x /run.sh

ADD bashrc /root/.bashrc

EXPOSE 9000
EXPOSE 50020
EXPOSE 50070
EXPOSE 50075
EXPOSE 9870
EXPOSE 8088
EXPOSE 8032
EXPOSE 8042
EXPOSE 10000

CMD ["/run.sh"]
ENTRYPOINT ["/run.sh"]

