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
          - name: AWS_ACCESS_KEY_ID
            valueFrom:
              secretKeyRef:
                name: api-festival-secret
                key: AWS_ACCESS_KEY_ID
          - name: AWS_SECRET_ACCESS_KEY
            valueFrom:
              secretKeyRef:
                name: api-festival-secret
                key: AWS_SECRET_ACCESS_KEY
