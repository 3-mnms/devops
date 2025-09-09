
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "nginx-client-mobile.fullname" . }}
  labels:
    app: {{ include "nginx-client-mobile.name" . }}
    {{- include "nginx-client-mobile.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.nginxClientMobile.replicaCount }}
  selector:
    matchLabels:
      {{- include "nginx-client-mobile.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        app: {{ include "nginx-client-mobile.name" . }}
        {{- include "nginx-client-mobile.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: nginx
          image: "{{ .Values.nginxClientMobile.image.registry }}/{{ .Values.nginxClientMobile.image.repository }}:{{ .Values.nginxClientMobile.image.tag }}"
          imagePullPolicy: {{ .Values.nginxClientMobile.image.pullPolicy }}
          ports:
            - containerPort: 80
          volumeMounts:
            - name: env-secret
              mountPath: /usr/share/nginx/html/env.js
              subPath: env.js
            - name: nginx-conf
              mountPath: /etc/nginx/conf.d/default.conf
              subPath: default.conf
      volumes:
        - name: env-secret
          secret:
            secretName: nginx-clien-secret
        - name: nginx-conf
          configMap:
            name: {{ include "nginx-client.fullname" . }}-config