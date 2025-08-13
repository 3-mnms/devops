apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-gateway.fullname" . }}
  labels:
    app: {{ include "api-gateway.name" . }}
    {{ include "api-gateway.exposelabel" . }}: "true"
spec:
  replicas: {{ .Values.apiGateway.replicaCount | default 2 }}
  selector:
    matchLabels:
      app: {{ include "api-gateway.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "api-gateway.name" . }}
        {{ include "api-gateway.exposelabel" . | indent 4 }}: "true"
    spec: 
      serviceAccountName: {{ include "api-gateway.fullname" . }}-sa
      containers: 
        - name: {{ include "api-gateway.name" . }}
          image: "{{ .Values.apiGateway.image.repository }}:{{ .Values.apiGateway.image.tag }}"
          imagePullPolicy: {{ .Values.apiGateway.image.pullPolicy | default "IfNotPresent" }}
          ports:
            - containerPort: {{ .Values.apiGateway.service.port }}
              name: http
              protocol: TCP
          env:
            - name: SPRING_PROFILES_ACTIVE
              value: {{ .Values.apiGateway.spring.profiles | default "local" | quote }}
          resources:
            requests:
              cpu: {{ .Values.apiGateway.resources.requests.cpu | default "256m" }}
              memory: {{ .Values.apiGateway.resources.requests.memory | default "256Mi" }}
            limits:
              cpu: {{ .Values.apiGateway.resources.limits.cpu | default "500m" }}
              memory: {{ .Values.apiGateway.resources.limits.memory | default "512Mi" }}
          livenessProbe:
            httpGet:
              path: /actuator/health
              port: {{ .Values.apiGateway.service.targetPort }}
            initialDelaySeconds: 80
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: {{ .Values.apiGateway.service.targetPort }}
            initialDelaySeconds: 80
            periodSeconds: 5