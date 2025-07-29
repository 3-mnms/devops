apiVersion: v1
kind: Service
metadata:
  name: {{ include "kafka.headlessfullname" . }} 
  labels:
    app: {{ include "kafka.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: {{ .Values.service.type }} 
  clusterIP: None 
  ports:
    - name: broker
      port: {{ .Values.service.port }}
      targetPort: {{ .Values.service.port }}
    - name: controller
      port: {{ .Values.service.headlessPort }}
      targetPort: {{ .Values.service.headlessPort }}
  selector:
    app: {{ include "kafka.name" . }}

---
# kafka-ui
# my-kafka-chart/templates/service-kafka-ui.yaml
{{- if .Values.ui.enabled }}
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
  type: {{ .Values.ui.service.type }}
  ports:
    - port: {{ .Values.ui.service.port }}
      targetPort: http
      protocol: TCP
      name: http
  selector:
    app: kafka-ui
{{- end }}