apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-booking.servicename" . }}
  labels:
    {{- include "api-booking.labels" . | nindent 4 }}
    {{- printf "%s: \"true\"" (include "api-booking.exposelabel" .) | nindent 4 }}
spec:
  type: {{ .Values.apiBooking.service.type }}
  selector:
    app: {{ include "api-booking.fullname" . }}
  ports:
    - port: {{ .Values.apiBooking.service.port }}
      targetPort: {{ .Values.apiBooking.service.port }}