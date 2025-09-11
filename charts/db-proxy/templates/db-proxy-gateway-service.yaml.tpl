apiVersion: v1
kind: Service
metadata:
  name: {{ include "db-proxy.name" . }}-svc
  namespace: db-proxy
spec:
  type: NodePort
  selector:
    app: {{ include "db-proxy.name" . }}
  ports:
    - name: payment-db
      port: {{ .Values.dbProxy.payment.port }}
      targetPort: {{ .Values.dbProxy.payment.port }}
      nodePort: {{ .Values.dbProxy.payment.nodePort }}
    - name: user-db
      port: {{ .Values.dbProxy.user.port }}
      targetPort: {{ .Values.dbProxy.user.port }}
      nodePort: {{ .Values.dbProxy.user.nodePort }}
    - name: festival-db
      port: {{ .Values.dbProxy.festival.port }}
      targetPort: {{ .Values.dbProxy.festival.port }}
      nodePort: {{ .Values.dbProxy.festival.nodePort }}
    - name: booking-db
      port: {{ .Values.dbProxy.booking.port }}
      targetPort: {{ .Values.dbProxy.booking.port }}
      nodePort: {{ .Values.dbProxy.booking.nodePort }}