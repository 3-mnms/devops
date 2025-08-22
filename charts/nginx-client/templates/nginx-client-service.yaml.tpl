apiVersion: v1
kind: Service
metadata:
  name: {{ include "nginx-client.serviceName" . }}
spec:
  selector:
    app: {{ include "nginx-client.fullname" . }}
  ports:
    - protocol: TCP
      port: {{ .Values.nginxClient.service.port }}
      targetPort: 80
  type: {{ .Values.nginxClient.service.type }}