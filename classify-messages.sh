broker=`dcos kafka --name=kafka endpoints broker-tls | grep kafka-0-broker | cut -d\" -f2`
dcos spark run --submit-args="\
--kerberos-principal=hdfs/name-0-node.hdfs.autoip.dcos.thisdcos.directory@MESOS.LAB \
--conf spark.mesos.containerizer=mesos \
--conf spark.mesos.principal=spark \
--conf spark.mesos.driverEnv.SPARK_USER=root \
--keytab-secret-path=keytab \
--keystore-secret-path=keystore \
--keystore-password=changeit \
--private-key-password=changeit \
--truststore-secret-path=truststore \
--truststore-password=changeit \
--executor-auth-secret=/spark-auth-secret \
--conf spark.cores.max=4 \
--conf spark.mesos.driver.secret.names=truststore-ca \
--conf spark.mesos.driver.secret.filenames=trust-ca.jks \
--conf spark.mesos.executor.secret.names=truststore-ca \
--conf spark.mesos.executor.secret.filenames=trust-ca.jks \
--conf spark.mesos.uris=http://s3-eu-west-1.amazonaws.com/djannot1/SMSSpamCollection.txt,https://s3-eu-west-1.amazonaws.com/djannot1/JAAS_ARTIFACT.conf \
--conf spark.driver.extraJavaOptions=-Djava.security.auth.login.config=/mnt/mesos/sandbox/JAAS_ARTIFACT.conf \
--conf spark.executor.extraJavaOptions=-Djava.security.auth.login.config=/mnt/mesos/sandbox/JAAS_ARTIFACT.conf \
--class SpamHamStreamingClassifier https://djannot1.s3.amazonaws.com/dcos-spark-scala-tests-assembly-0.1-SNAPSHOT.jar top1 $broker hdfs:///nb_model true" \
--name=spark
