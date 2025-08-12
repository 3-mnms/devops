apiVersion: v1
kind: ServiceAccount
metadata:
  name: infra-ingress-controller
  namespace: {{ .Release.Namespace }}