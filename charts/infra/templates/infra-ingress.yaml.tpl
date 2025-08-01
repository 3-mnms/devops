{{- if .Values.infra.ingress }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "infra.fullname" . }}
  labels:
    {{- include "infra.labels" . | nindent 4 }}
  annotations:
    {{- toYaml .Values.infra.ingress.annotations | nindent 4 }}
spec:
  ingressClassName: {{ .Values.infra.ingress.ingressClassName }}
  rules:
    - host: {{ printf "%s.%s" .Values.infra.ingress.api.subDomain .Values.infra.ingress.host }}
      http:
        paths:
          - path: {{ .Values.infra.ingress.api.path }}
            pathType: {{ .Values.infra.ingress.api.pathType | default "Prefix" | title }}
            backend:
              service:
                name: {{ include "infra.apiServiceName" . }}
                port:
                  number: {{ .Values.infra.ingress.api.port }}

                  
    - host: {{ printf "%s.%s" .Values.infra.ingress.client.subDomain .Values.infra.ingress.host }}
      http:
        paths:
          - path: {{ .Values.infra.ingress.client.path }}
            pathType: {{ .Values.infra.ingress.client.pathType | default "Prefix" | title }}
            backend:
              service:
                name: {{ include "infra.clientServiceName" . }}
                port:
                  number: {{ .Values.infra.ingress.client.port }}
  {{- if .Values.infra.ingress.tls }}
  tls:
    - hosts:
        - {{ printf "%s.%s" .Values.infra.ingress.api.subDomain .Values.infra.ingress.host }}
        - {{ printf "%s.%s" .Values.infra.ingress.client.subDomain .Values.infra.ingress.host }}
      secretName: {{ .Values.infra.ingress.tlsSecret }}
  {{- end }}
{{- end }}