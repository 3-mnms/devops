apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-festival.servicename" . }}
  labels:
    {{- include "api-festival.labels" . | nindent 4 }}
    {{- printf "%s: \"true\"" (include "api-festival.exposelabel" .) | nindent 4 }}
spec:
  type: {{ .Values.apiFestival.service.type }}
  selector:
    app: {{ include "api-festival.fullname" . }}
  ports:
    - port: {{ .Values.apiFestival.service.port }}
      targetPort: {{ .Values.apiFestival.service.port }}