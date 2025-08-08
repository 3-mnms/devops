apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: {{ include "kafka.fullname" . }}
  labels:
    app: {{ include "kafka.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  serviceName: {{ include "kafka.headlessfullname" . }} 
  replicas: {{ .Values.kafka.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "kafka.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "kafka.name" . }}
    spec: 
      # 모든 설정 파일 생성 및 권한 설정 로직을 하나의 initContainer로 통합합니다.
      initContainers:
        - name: configure-kafka
          image: busybox:latest # 작은 이미지 사용 (셸 스크립트 실행용)
          command: ["sh", "-c"]
          args:
            - |
              echo "Configuring Kafka server.properties and log4j files..."
              
              CONFIG_DIR="/opt/bitnami/kafka/config"
              FINAL_SERVER_PROPERTIES_PATH="${CONFIG_DIR}/server.properties"
              LOG4J_PROPERTIES_PATH="${CONFIG_DIR}/log4j.properties"
              TOOLS_LOG4J_PROPERTIES_PATH="${CONFIG_DIR}/tools-log4j.properties"
              
              # 설정 디렉토리가 없으면 생성합니다.
              mkdir -p ${CONFIG_DIR}
              
              # 1. server.properties 파일 생성
              NODE_ID=$(hostname -s | awk -F'-' '{print $NF}')
              ADVERTISED_LISTENERS="PLAINTEXT://{{ include "kafka.fullname" . }}-${NODE_ID}.{{ include "kafka.servicename" . }}.{{ .Release.Namespace }}.svc.cluster.local:{{ .Values.kafka.service.port }}"
              
              cat /config-template/server.properties.template | \
              sed "s|__NODE_ID__|${NODE_ID}|g" | \
              sed "s|__ADVERTISED_LISTENERS__|${ADVERTISED_LISTENERS}|g" \
              > ${FINAL_SERVER_PROPERTIES_PATH}
              
              echo "Generated server.properties content:"
              cat ${FINAL_SERVER_PROPERTIES_PATH}
              
              # 2. log4j.properties 파일 생성
              cat <<EOF > ${LOG4J_PROPERTIES_PATH}
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
              EOF
              
              echo "Generated log4j.properties content:"
              cat ${LOG4J_PROPERTIES_PATH}
              
              # 3. tools-log4j.properties 파일 생성
              cat <<EOF > ${TOOLS_LOG4J_PROPERTIES_PATH}
              log4j.rootLogger=WARN, stdout
              log4j.appender.stdout=org.apache.log4j.ConsoleAppender
              log4j.appender.stdout.layout=org.apache.log4j.PatternLayout
              log4j.appender.stdout.layout.ConversionPattern=%d{yyyy-MM-dd HH:mm:ss,SSS} %-5p %c{1}:%L - %m%n
              log4j.logger.kafka.tools=INFO
              log4j.logger.org.apache.kafka=INFO
              EOF
              
              echo "Generated tools-log4j.properties content:"
              cat ${TOOLS_LOG4J_PROPERTIES_PATH}
              
              # 4. 생성된 모든 파일의 권한 설정
              chmod 644 ${FINAL_SERVER_PROPERTIES_PATH} ${LOG4J_PROPERTIES_PATH} ${TOOLS_LOG4J_PROPERTIES_PATH}
              chown 1001:1001 ${FINAL_SERVER_PROPERTIES_PATH} ${LOG4J_PROPERTIES_PATH} ${TOOLS_LOG4J_PROPERTIES_PATH}
              
              echo "All configuration files created and permissions set."

          volumeMounts:
            # ConfigMap 템플릿을 읽기 전용으로 마운트합니다.
            - name: config-template-volume
              mountPath: /config-template
              readOnly: true
            # initContainer가 생성한 최종 설정 파일들을 저장할 공유 볼륨을 마운트합니다.
            - name: dynamic-config-volume
              mountPath: /opt/bitnami/kafka/config # Kafka가 설정 파일을 찾는 경로

      containers:
        - name: kafka
          image: "{{ .Values.kafka.image.repository }}:{{ .Values.kafka.image.tag }}"
          imagePullPolicy: {{ .Values.kafka.image.pullPolicy }}
          ports:
            - name: broker
              containerPort: {{ .Values.kafka.service.port }}
            - name: controller
              containerPort: {{ .Values.kafka.service.headlessPort }}
          env:
            # Bitnami Kafka에게 initContainer가 생성한 server.properties 파일의 경로를 알려줍니다.
            - name: KAFKA_CFG_SERVER_PROPERTIES_FILE
              value: "/opt/bitnami/kafka/config/server.properties"
            
            # Bitnami 시작 스크립트가 찾을 수 있도록 이 환경 변수를 명시적으로 설정합니다.
            - name: KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP
              value: "PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT"
            
            # Kafka 클러스터 ID 설정 (values.yaml에서 가져옴)
            - name: KAFKA_KRAFT_CLUSTER_ID
              value: {{ .Values.kafka.kafkaGlobalClusterId | default "pYdR4Xe6T9K7zTArYtR9XA" | quote }}
            
            # log4j 설정 파일 경로를 Kafka JVM에 명시적으로 전달합니다.
            # 파일들이 /opt/bitnami/kafka/config/ 에 직접 생성되므로 경로를 그렇게 지정합니다.
            - name: KAFKA_OPTS
              value: "-Dlog4j.configuration=file:/opt/bitnami/kafka/config/log4j.properties -Dtools.log4j.configuration=file:/opt/bitnami/kafka/config/tools-log4j.properties"

          resources:
            {{ toYaml .Values.kafka.resources | nindent 12 }}
          nodeSelector:
            {{ toYaml .Values.kafka.nodeSelector | nindent 12 }}
          tolerations:
            {{ toYaml .Values.kafka.tolerations | nindent 12 }}
          affinity:
            {{ toYaml .Values.kafka.affinity | nindent 12 }}
          volumeMounts:
            # initContainer가 생성한 동적 설정 파일들을 마운트합니다.
            - name: dynamic-config-volume
              mountPath: /opt/bitnami/kafka/config
            - name: data
              mountPath: /bitnami/kafka/data 
            - name: kraft-metadata
              mountPath: /bitnami/kafka/kraft-metadata 
      volumes: 
        - name: config-template-volume
          configMap:
            name: {{ include "kafka.fullname" . }}-config # server.properties.template를 포함하는 ConfigMap
        - name: dynamic-config-volume
          emptyDir: {} # initContainer와 메인 컨테이너가 설정 파일을 공유할 emptyDir 볼륨
  volumeClaimTemplates: 
    - metadata:
        name: data
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: {{ .Values.kafka.persistence.storageClass }}
        resources:
          requests:
            storage: {{ .Values.kafka.persistence.size }}
    - metadata:
        name: kraft-metadata 
      spec:
        accessModes: ["ReadWriteOnce"]
        storageClassName: {{ .Values.kafka.kraftPersistence.storageClass | default .Values.kafka.persistence.storageClass }}
        resources:
          requests:
            storage: {{ .Values.kafka.kraftPersistence.size }}
