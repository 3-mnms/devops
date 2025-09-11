apiVersion: v1
kind: Service
metadata:
  name: {{ include "db-proxy.name" . }}-svc
  namespace: db-proxy
spec:
  type: LoadBalancer
  selector:
    app: {{ include "db-proxy.name" . }}
  ports:
    - name: payment-db
      port: {{ .Values.dbProxy.payment.port }}
      targetPort: {{ .Values.dbProxy.payment.port }}
    - name: user-db
      port: {{ .Values.dbProxy.user.port }}
      targetPort: {{ .Values.dbProxy.user.port }}
    - name: festival-db
      port: {{ .Values.dbProxy.festival.port }}
      targetPort: {{ .Values.dbProxy.festival.port }}
    - name: booking-db
      port: {{ .Values.dbProxy.booking.port }}
      targetPort: {{ .Values.dbProxy.booking.port }}