apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "api-booking.fullname" . }}-config
data:
  application.properties: |
{{ include "api-booking.applicationProperties" . | nindent 4}}