
{{- if eq .Values.infra.ingress.mode "develop" }}
apiVersion: networking.k8s.io/v1
kind: IngressClass
metadata:
  name: nginx
spec:
  controller: k8s.io/ingress-nginx
{{- end }}