apiVersion: v1
kind: Service
metadata:
  name: {{ include "kafka.headlessfullname" . }} 
  labels:
    app: {{ include "kafka.servicename" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: {{ .Values.kafka.service.type }} 
  clusterIP: None 
  ports:
    - name: broker
      port: {{ .Values.kafka.service.port }}
      targetPort: {{ .Values.kafka.service.port }}
    - name: controller
      port: {{ .Values.kafka.service.headlessPort }}
      targetPort: {{ .Values.kafka.service.headlessPort }}
  selector:
    app: {{ include "kafka.name" . }}

---
# kafka-ui
# my-kafka-chart/templates/service-kafka-ui.yaml
{{- if .Values.kafka.ui.enabled }}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "kafka.fullname" . }}-ui
  labels:
    app: kafka-ui
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: {{ .Values.kafka.ui.service.type }}
  ports:
    - port: {{ .Values.kafka.ui.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: kafka-ui
{{- end }}