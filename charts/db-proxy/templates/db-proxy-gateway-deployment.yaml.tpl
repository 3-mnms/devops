apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "db-proxy.name" . }}
  namespace: d
spec:
  replicas: 1
  selector:
    matchLabels:
      app: {{ include "db-proxy.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "db-proxy.name" . }}
    spec:
      containers:
        - name: haproxy
          image: haproxy:2.8
          volumeMounts:
            - name: haproxy-config
              mountPath: /usr/local/etc/haproxy
      volumes:
        - name: haproxy-config
          configMap:
            name: haproxy-config