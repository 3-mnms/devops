apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "infra-ingress.serviceaccountname" . }}
  namespace: {{ .Release.Namespace }}