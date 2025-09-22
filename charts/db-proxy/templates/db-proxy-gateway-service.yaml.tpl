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
      targetPort: {{ .Values.dbProxy.payment.targetPort }}
    - name: user-db
      port: {{ .Values.dbProxy.user.port }}
      targetPort: {{ .Values.dbProxy.user.targetPort }}
    - name: festival-db
      port: {{ .Values.dbProxy.festival.port }}
      targetPort: {{ .Values.dbProxy.festival.targetPort }}
    - name: booking-db
      port: {{ .Values.dbProxy.booking.port }}
      targetPort: {{ .Values.dbProxy.booking.targetPort }}
    - name: kafka-ui
      port: {{ .Values.dbProxy.kafkaUi.port }}
      targetPort: {{ .Values.dbProxy.kafkaUi.targetPort }}
    - name: grafana
      port: {{ .Values.dbProxy.grafana.port }}
      targetPort: 4011