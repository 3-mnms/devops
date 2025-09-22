apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-payment.servicename" . }}
  labels:
    {{- include "api-payment.labels" . | nindent 4 }}
    {{- printf "%s: \"true\"" (include "api-payment.exposelabel" .) | nindent 4 }}
spec:
  type: {{ .Values.apiPayment.service.type }}
  selector:
    app: {{ include "api-payment.fullname" . }}
  ports:
    - port: {{ .Values.apiPayment.service.port }}
      targetPort: {{ .Values.apiPayment.service.port }}