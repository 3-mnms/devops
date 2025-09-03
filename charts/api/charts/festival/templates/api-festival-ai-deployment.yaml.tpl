apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-festival-ai.fullname" . }}
  labels:
    {{- include "api-festival-ai.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.apiFestivalAi.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "api-festival-ai.fullname" . }}
  template:
    metadata:
      labels:
        app: {{ include "api-festival-ai.fullname" . }}
    spec:
      containers:
        - name: festival
          image: "{{ .Values.apiFestivalAi.image.registry }}/{{ .Values.apiFestivalAi.image.repository }}:{{ .Values.apiFestivalAi.image.tag }}"
          imagePullPolicy: {{ .Values.apiFestivalAi.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.apiFestivalAi.service.port }}
          env:
        - name: AWS_BEDROCK_REGION
          valueFrom:
            secretKeyRef:
              name: api-festival-secret
              key: AWS_BEDROCK_REGION
        - name: AWS_BEDROCK_API_KEY
          valueFrom:
            secretKeyRef:
              name: api-festival-secret
              key: AWS_BEDROCK_API_KEY
          resources:
            requests:
              cpu: {{ .Values.apiFestivalAi.resources.requests.cpu | default "256m" }}
              memory: {{ .Values.apiFestivalAi.resources.requests.memory | default "256Mi" }}
            limits:
              cpu: {{ .Values.apiFestivalAi.resources.limits.cpu | default "500m" }}
              memory: {{ .Values.apiFestivalAi.resources.limits.memory | default "1024Mi" }}