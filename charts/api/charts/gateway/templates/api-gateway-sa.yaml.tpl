
{{- if eq .Values.apiGateway.ingress.mode "aws" -}}
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "api-gateway.serviceaccountname" . }}
  namespace: gateway
{{- end -}}