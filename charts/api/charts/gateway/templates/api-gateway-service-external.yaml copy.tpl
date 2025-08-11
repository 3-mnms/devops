apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-gateway.servicename" . }}
  namespace: {{ include "api-gateway.infranamespace" . }}
  labels:
    app: {{ include "api-gateway.name" . }}
    {{- printf "%s: \"true\"" (include "api-gateway.exposelabel" .) | nindent 4 }}

spec:
  type: externalName
  ports:
    - port: {{ .Values.apiGateway.service.port }}