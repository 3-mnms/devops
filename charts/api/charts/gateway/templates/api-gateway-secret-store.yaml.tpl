
{{- if eq .Values.apiGateway.ingress.mode "aws" -}}
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
            name: {{ include "api-gateway.alb.serviceaccountname"  . }} 
            namespace: external-secrets
{{- end -}}