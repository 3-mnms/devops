{{- if .Values.apiGateway.ingress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "api-gateway.fullname" . }}
  annotations:
    {{- include "api-gateway-ingress.gce.annotations.ingress" . | nindent 4 }}
spec:
  rules:
    - host: {{ include "api-gateway-ingress.host" . }}
      http:
        paths:
          - path: {{ .Values.apiGateway.ingress.path }}
            pathType: {{ .Values.apiGateway.ingress.pathType | default "Prefix" | title }}
            backend:
              service:
                name: {{ include "api-gateway.servicename" . }}
                port:
                  number: {{ .Values.apiGateway.ingress.port.http }}

      
  {{- if .Values.apiGateway.ingress.tls }}
  tls:
    - hosts:
        - {{ include "api-gateway-ingress.host" . }}
      secretName: {{ .Values.apiGateway.ingress.tlsSecret | default "api-gateway-tls-secret" }}
  {{- end }}
{{- end }}