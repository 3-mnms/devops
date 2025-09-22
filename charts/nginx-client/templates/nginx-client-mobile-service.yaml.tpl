apiVersion: v1
kind: Service
metadata:
  name: {{ include "nginx-client-mobile.serviceName" . }}
spec:
  selector:
    app: {{ include "nginx-client-mobile.fullname" . }}
  ports:
    - protocol: TCP
      port: {{ .Values.nginxClientMobile.service.port }}
      targetPort: 80
  type: {{ .Values.nginxClientMobile.service.type }}