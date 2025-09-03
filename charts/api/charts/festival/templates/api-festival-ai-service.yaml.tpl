apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-festival-ai.servicename" . }}
  labels:
    {{- include "api-festival-ai.labels" . | nindent 4 }}
spec:
  type: {{ .Values.apiFestivalAi.service.type }}
  selector:
    app: {{ include "api-festival-ai.fullname" . }}
  ports:
    - port: {{ .Values.apiFestivalAi.service.port }}
      targetPort: {{ .Values.apiFestivalAi.service.port }}