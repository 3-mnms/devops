
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "nginx-client.fullname" . }}
  labels:
    app: {{ include "nginx-client.name" . }}
    {{- include "nginx-client.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.nginxClient.replicaCount }}
  selector:
    matchLabels:
      {{- include "nginx-client.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        app: {{ include "nginx-client.name" . }}
        {{- include "nginx-client.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: nginx
          image: rookiesdogun/nginx-client:test3
          # image: "{{ .Values.nginxClient.image.repository }}:{{ .Values.nginxClient.image.tag }}"
          imagePullPolicy: {{ .Values.nginxClient.image.pullPolicy }}
          ports:
            - containerPort: 80
          volumeMounts:
            - name: nginx-config
              mountPath: /etc/nginx/nginx.conf
              subPath: nginx.conf
            - name: env-secret
              mountPath: /usr/share/nginx/html/env.js
              subPath: env.js
      volumes:
        - name: nginx-config
          configMap:
            name: {{ include "nginx-client.fullname" . }}-config
        - name: env-secret
          secret:
            secretName: nginx-client-secret