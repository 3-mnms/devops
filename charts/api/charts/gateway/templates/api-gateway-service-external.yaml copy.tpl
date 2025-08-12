apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-gateway.servicename" . }}
  namespace: {{ include "api-gateway.infranamespace" . }}
  labels:
    app: {{ include "api-gateway.name" . }}

spec:
  type: ExternalName
  externalName: {{ printf "%s.%s.svc.cluster.local" (include "api-gateway.servicename" .) .Release.Namespace }}
  ports:
    - port: {{ .Values.apiGateway.service.port }}