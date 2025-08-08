# my-kafka-chart/templates/deployment-kafka-ui.yaml
{{- if .Values.kafka.ui.enabled }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "kafka.ui.servicename" . }}
  labels:
    app: kafka-ui
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app: kafka-ui
  template:
    metadata:
      labels:
        app: kafka-ui
    spec:
      containers:
        - name: kafka-ui
          image: "{{ .Values.kafka.ui.image.repository }}:{{ .Values.kafka.ui.image.tag }}"
          imagePullPolicy: {{ .Values.kafka.ui.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.kafka.ui.service.port }}
          env:
            - name: KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS
              value: {{ include "kafka.bootstrapServers" . | quote }}
            - name: KAFKA_CLUSTER_0_NAME
              value: "{{ .Values.kafka.ui.clusterName }}"
{{- with .Values.kafka.resources }}
          resources:
{{ toYaml . | nindent 12 }}
{{- end }}
{{- end }}