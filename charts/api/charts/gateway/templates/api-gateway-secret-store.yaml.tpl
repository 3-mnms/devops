
{{- if eq .Values.apiGateway.ingress.mode "test" -}}
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: aws-secrets-manager
spec:
  provider:
    aws:
      service: SecretsManager       # AWS Secrets Manager 사용
      region: ap-northeast-2
      auth:
        jwt:
          serviceAccountRef:
            name: external-secrets-sa
            namespace: external-secrets

---
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: api-gateway-role-arn
  namespace: gateway
spec:
  refreshInterval: 1h          
  secretStoreRef:
    name: aws-secrets-manager
    kind: ClusterSecretStore
  target:
    name: api-gateway-role-arn
    creationPolicy: Owner
  data:
    - secretKey: roleArn       
      remoteRef:
        key: /gateway/apiGateway/roleArn 

{{- end -}}

