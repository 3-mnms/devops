{{- if eq .Values.infra.ingress.mode "develop" }}
apiVersion: v1
kind: Service
metadata:
  name: infra-ingress-controller
  namespace: {{ .Release.Namespace }}
  labels:
    app: infra-ingress-controller
spec:
  type: {{ .Values.infra.ingress.controller.service.type }}
  ports:
    - name: http
      port: {{ .Values.infra.ingress.controller.service.httpPort }}
      targetPort: 80
    - name: https
      port: {{ .Values.infra.ingress.controller.service.httpsPort }}
      targetPort: 443
  selector:
    app: infra-ingress-controller
{{- end }}