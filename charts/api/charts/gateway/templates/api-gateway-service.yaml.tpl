apiVersion: v1
kind: Service
metadata:
  name: {{ include "api-gateway.servicename" . }}
  labels:
    app: {{ include "api-gateway.name" . }}
    {{- printf "%s: \"true\"" (include "api-gateway.exposelabel" .) | nindent 4 }}
  
  {{- if eq .Values.apiGateway.ingress.mode "gce" }}
  annotations:
    {{- include "api-gateway-ingress.gce.annotations.service" . | nindent 4 }}

  {{ end }}

spec:
  type: {{ .Values.apiGateway.service.type }}
  ports:
    - port: {{ .Values.apiGateway.service.port }}
      targetPort: {{ .Values.apiGateway.service.targetPort }}
      protocol: TCP
      name: http
  selector:
    app: {{ include "api-gateway.name" . }}