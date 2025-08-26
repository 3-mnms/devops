apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-gateway.fullname" . }}
  labels:
    app: {{ include "api-gateway.name" . }}
spec:
  replicas: {{ .Values.apiGateway.replicaCount | default 2 }}
  selector:
    matchLabels:
      app: {{ include "api-gateway.name" . }}
  template:
    metadata:
      labels:
        app: {{ include "api-gateway.name" . }}
    spec: 
      serviceAccountName: {{ include "api-gateway.serviceaccountname" . }}
      containers: 
        - name: {{ include "api-gateway.name" . }}
          image: "{{ .Values.apiGateway.image.repository }}:{{ .Values.apiGateway.image.tag }}"
          imagePullPolicy: {{ .Values.apiGateway.image.pullPolicy | default "IfNotPresent" }}
          ports:
            - containerPort: {{ .Values.apiGateway.service.port }}
              name: http
              protocol: TCP

          resources:
            requests:
              cpu: {{ .Values.apiGateway.resources.requests.cpu | default "256m" }}
              memory: {{ .Values.apiGateway.resources.requests.memory | default "256Mi" }}
            limits:
              cpu: {{ .Values.apiGateway.resources.limits.cpu | default "500m" }}
              memory: {{ .Values.apiGateway.resources.limits.memory | default "1024Mi" }}
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

          env:
            # JWT 파일 경로
            - name: SPRING_PROFILES_ACTIVE
              value: {{ .Values.apiGateway.spring.profiles | default "prod" }}
            - name: JWT_PRIVATE_PEM_PATH
              value: "file:/etc/keys/private.pem"
            - name: JWT_PUBLIC_PEM_PATH
              value: "file:/etc/keys/public.pem"
            - name: CORS_URL
              value: {{ .Values.apiGateway.spring.corsUrl | default "http://www.rookies-tekcit.com" }}
          volumeMounts:
            - name: jwt-keys
              mountPath: /etc/keys
              readOnly: true
      volumes:
        - name: jwt-keys
          secret:
            secretName: api-gateway-secret
            items:
              - key: JWT_PRIVATE_PEM_PATH
                path: private.pem
              - key: JWT_PUBLIC_PEM_PATH
                path: public.pem

      