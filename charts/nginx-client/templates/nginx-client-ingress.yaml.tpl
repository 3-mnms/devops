{{- if .Values.nginxClient.ingress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "nginx-client.fullname" . }}
  annotations:
    {{ if eq .Values.nginxClient.ingress.mode "gce" }}
    {{- include "nginx-client-ingress.gce.annotations.ingress" . | nindent 4 }}
    {{- else if eq .Values.nginxClient.ingress.mode "aws" -}}
    {{- include "nginx-client-ingress.aws.annotations.ingress" . | nindent 4 }}
    {{ end }}

spec:
  rules:
    - host: {{ include "nginx-client-ingress.host" . }}
      http:
        paths:
          - path: {{ .Values.nginxClient.ingress.path | default "/" }}
            pathType: {{ .Values.nginxClient.ingress.pathType | default "Prefix" | title }}
            backend:
              service:
                name: {{ include "nginx-client.serviceName" . }}
                port:
                  number: {{ .Values.nginxClient.service.port }}

      
  {{- if and (eq .Values.nginxClient.ingress.mode "gce") .Values.nginxClient.ingress.tls }}
  tls:
    - hosts:
        - {{ include "nginx-client-ingress.host" . }}
      secretName: {{ .Values.nginxClient.ingress.gce.tlsSecret | default "nginx-client-tls-secret" }}
  {{- end }}
{{- end }}