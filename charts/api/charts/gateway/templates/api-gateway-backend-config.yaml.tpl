apiVersion: cloud.google.com/v1
kind: BackendConfig
metadata:
  name: api-gateway-backendconfig
spec:
  healthCheck:
    checkIntervalSec: 10
    timeoutSec: 5
    healthyThreshold: 2
    unhealthyThreshold: 2
    type: HTTP
    requestPath: /actuator/health
    port: 8080
    initialDelaySec: 60