{{- if .Values.apiGateway.ingress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "api-gateway.fullname" . }}
  annotations:
    kubernetes.io/ingress.global-static-ip-name: rookies-tekcit-static-ip 
spec:
  ingressClassName: {{ .Values.apiGateway.ingress.ingressClassName }}
  rules:
    - host: {{ printf "api.%s"  .Values.global.url }}
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
        - {{ printf "%s.%s" .Values.apiGateway.ingress.api.subDomain .Values.apiGateway.ingress.host }}
        - {{ printf "%s.%s" .Values.apiGateway.ingress.client.subDomain .Values.apiGateway.ingress.host }}
      secretName: {{ .Values.apiGateway.ingress.tlsSecret }}
  {{- end }}
{{- end }}