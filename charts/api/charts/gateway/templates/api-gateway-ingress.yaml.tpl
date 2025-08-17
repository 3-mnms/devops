{{- if .Values.apiGateway.ingress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "api-gateway.fullname" . }}
  annotations:
    {{ if eq .Values.apiGateway.ingress.mode "gce" }}
    {{- include "api-gateway-ingress.gce.annotations.ingress" . | nindent 4 }}
    {{- else if eq .Values.apiGateway.ingress.mode "aws" -}}
    {{- include "api-gateway-ingress.aws.annotations.ingress" . | nindent 4 }}
    {{ end }}

spec:
  rules:
    - host: {{ include "api-gateway-ingress.host" . }}
      http:
        paths:
          - path: {{ .Values.apiGateway.ingress.path | default "/" }}
            pathType: {{ .Values.apiGateway.ingress.pathType | default "Prefix" | title }}
            backend:
              service:
                name: {{ include "api-gateway.servicename" . }}
                port:
                  number: {{ .Values.apiGateway.service.port }}

      
  {{- if .Values.apiGateway.ingress.tls }}
  tls:
    - hosts:
        - {{ include "api-gateway-ingress.host" . }}
      secretName: {{ .Values.apiGateway.ingress.tlsSecret | default "api-gateway-tls-secret" }}
  {{- end }}
{{- end }}