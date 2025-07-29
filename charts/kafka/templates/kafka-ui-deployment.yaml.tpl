# my-kafka-chart/templates/deployment-kafka-ui.yaml
{{- if .Values.ui.enabled }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "kafka.fullname" . }}-ui
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
          image: "{{ .Values.ui.image.repository }}:{{ .Values.ui.image.tag }}"
          imagePullPolicy: {{ .Values.ui.image.pullPolicy }}
          ports:
            - name: http
              containerPort: {{ .Values.ui.service.port }}
          env:
            - name: KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS
              value: {{ include "kafka.bootstrapServers" . | quote }}
            - name: KAFKA_CLUSTER_0_NAME
              value: "{{ .Values.ui.clusterName }}"
{{- with .Values.resources }}
          resources:
{{ toYaml . | nindent 12 }}
{{- end }}
{{- end }}