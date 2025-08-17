{{- if eq .Values.apiGateway.ingress.mode "gce" }}
apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: {{ .Values.apiGateway.ingress.gce.backendConfigName | default "api-gateway-backendconfig" }}
spec:
  healthCheck:
    checkIntervalSec: 10
    timeoutSec: 5
    healthyThreshold: 2
    unhealthyThreshold: 2
    type: HTTP
    requestPath: /actuator/health
    port: 8080
    initialDelaySec: 80
{{- end }}