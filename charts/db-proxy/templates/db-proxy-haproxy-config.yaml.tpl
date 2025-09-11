apiVersion: v1
kind: ConfigMap
metadata:
  name: haproxy-config
  namespace: db-proxy
data:
  haproxy.cfg: |

    global
      log stdout format raw local0

    defaults
        log     global
        mode    tcp
        option  tcplog
        timeout connect 10s
        timeout client  1m
        timeout server  1m

    listen payment-db
        bind *:{{ .Values.dbProxy.payment.port }}
        mode tcp
        server payment-db-svc {{ .Values.global.apiPaymentDatabase }}.payment.svc.cluster.local:3306 check

    listen user-db
        bind *:{{ .Values.dbProxy.user.port }}
        mode tcp
        server user-db-svc {{ .Values.global.service.apiUserDatabase }}.user.svc.cluster.local:3306 check

    listen festival-db
        bind *:{{ .Values.dbProxy.festival.port }}
        mode tcp
        server festival-db-svc {{ .Values.global.service.apiFestivalDatabase }}.festival.svc.cluster.local:3306 check

    listen booking-db
        bind *:{{ .Values.dbProxy.booking.port }}
        mode tcp
        server booking-db-svc {{ .Values.global.service.apiBookingDatabase }}.booking.svc.cluster.local:3306 check