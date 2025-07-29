
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "kafka.fullname" . }}-config
  labels:
    app: {{ include "kafka.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
data:
  server.properties.template: |
    process.roles=broker,controller
    node.id=__NODE_ID__ 
    controller.quorum.voters={{ include "kafka.controllerQuorumVoters" . }}
    controller.listener.names=CONTROLLER
    listeners=PLAINTEXT://:{{ .Values.service.port }},CONTROLLER://:{{ .Values.service.headlessPort }}
    advertised.listeners=__ADVERTISED_LISTENERS__
    inter.broker.listener.name=PLAINTEXT
    log.dirs=/bitnami/kafka/data
    metadata.log.dir=/bitnami/kafka/kraft-metadata
    num.network.threads=3
    num.io.threads=8
    socket.send.buffer.bytes=102400
    socket.receive.buffer.bytes=102400
    socket.request.max.bytes=104857600
    log.retention.hours=168
    log.segment.bytes=1073741824
    log.retention.check.interval.ms=300000
    num.partitions=1
    default.replication.factor=1
    min.insync.replicas=1
    offsets.topic.replication.factor=1
    transaction.state.log.replication.factor=1
    transaction.state.log.min.isr=1
    group.initial.rebalance.delay.ms=0
    auto.create.topics.enable=false

  # Kafka Broker log4j configuration 파일 추가
  log4j.properties: |
    log4j.rootLogger=INFO, stdout
    log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p %c{1}:%L - %m%n
    log4j.logger.kafka.server.LogDirFailureChannel=WARN
    log4j.logger.kafka.controller=TRACE
    log4j.logger.kafka.zk.KafkaZkClient=INFO
    log4j.logger.kafka.client.NetworkClient=INFO
    log4j.logger.org.apache.zookeeper=INFO
    log4j.logger.org.apache.kafka=INFO
    log4j.logger.org.apache.kafka.clients.consumer.internals.ConsumerCoordinator=INFO
    log4j.logger.org.apache.kafka.clients.producer.internals.ProducerBatch=INFO
    log4j.logger.org.apache.kafka.clients.producer.KafkaProducer=INFO
    log4j.logger.org.apache.kafka.common.network.Selector=INFO
    log4j.logger.org.apache.kafka.common.metrics.Metrics=INFO
    log4j.logger.org.apache.kafka.common.utils.AppInfoParser=INFO
    log4j.logger.org.apache.kafka.metadata=INFO
    log4j.logger.org.apache.kafka.metadata.bootstrap=INFO
    log4j.logger.org.apache.kafka.server=INFO
    log4j.logger.org.apache.kafka.storage=INFO
    log4j.logger.org.apache.kafka.streams=INFO
    log4j.logger.org.apache.kafka.streams.processor.internals=INFO
    log4j.logger.org.apache.kafka.streams.processor.internals.StreamThread=INFO
    log4j.logger.org.reflections.Reflections=WARN

  # Kafka Tools log4j configuration 파일 추가
  tools-log4j.properties: |
    log4j.rootLogger=WARN, stdout
    log4j.appender.stdout=org.apache.log4j.ConsoleAppender
    log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
    log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p %c{1}:%L - %m%n
    log4j.logger.kafka.tools=INFO
    log4j.logger.org.apache.kafka=INFO