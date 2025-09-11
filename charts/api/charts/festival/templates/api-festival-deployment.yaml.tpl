apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-festival.fullname" . }}
  labels:
    {{- include "api-festival.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.apiFestival.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "api-festival.fullname" . }}
  template:
    metadata:
      labels:
        app: {{ include "api-festival.fullname" . }}
    spec:
      containers:
        - name: festival
          image: "{{ .Values.apiFestival.image.registry }}/{{ .Values.apiFestival.image.repository }}:{{ .Values.apiFestival.image.tag }}"
          imagePullPolicy: {{ .Values.apiFestival.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.apiFestival.service.port }}
          env:
            - name: SERVER_PORT
              value: "8080"
            - name: SPRING_PROFILES_ACTIVE
              value: prod
            - name: TZ
              value: Asia/Seoul

            # Kafka
            - name: SPRING_KAFKA_BOOTSTRAP_SERVERS
              value: {{ include "api-festival.kafka.url" . }}

            # Database
            - name: SPRING_DATASOURCE_URL
              value: {{ include "api-festival.database.url" . }}
            - name: SPRING_DATASOURCE_USERNAME
              valueFrom:
                secretKeyRef:
                  name: api-festival-secret
                  key: SPRING_DATASOURCE_USERNAME
            - name: SPRING_DATASOURCE_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: api-festival-secret
                  key: SPRING_DATASOURCE_PASSWORD
            - name: KAKAO_REST_API_KEY
              valueFrom:
                secretKeyRef:
                  name: api-festival-secret
                  key: KAKAO_REST_API_KEY

            
            # External Service
            - name: FESTIVAL_API_KEY
              valueFrom:
                secretKeyRef:
                  name: api-festival-secret
                  key: FESTIVAL_API_KEY
            
            - name: AI_URL
              value: {{ printf "http://%s:%s" (.Values.global.service.apiFestivalAi | default "api-festival-ai-service") (.Values.apiFestivalAi.service.port | default "8084") }}

            # AWS Setting
            - name: AWS_S3_BUCKET_NAME
              valueFrom: 
                secretKeyRef:
                  name: api-festival-secret
                  key: AWS_S3_BUCKET_NAME
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
            - name: AWS_REGION
              valueFrom:
                secretKeyRef:
                  name: api-festival-secret
                  key: AWS_REGION
            - name: AWS_STS_ROLE_ARN
              valueFrom:
                secretKeyRef:
                  name: api-festival-secret
                  key: AWS_STS_ROLE_ARN
            # GEOCODE
            - name: USER_GEOCODE_API
              value: "/api/users/geocodeInfo"
            - name: BASE_API
              value: {{ printf "https://api.%s" .Values.global.domain  | quote }}
          resources:
            requests:
              cpu: {{ .Values.apiFestival.resources.requests.cpu | default "256m" }}
              memory: {{ .Values.apiFestival.resources.requests.memory | default "256Mi" }}
            limits:
              cpu: {{ .Values.apiFestival.resources.limits.cpu | default "500m" }}
              memory: {{ .Values.apiFestival.resources.limits.memory | default "1024Mi" }}
          # livenessProbe:
          #   httpGet:
          #     path: /actuator/health
          #     port: {{ .Values.apiFestival.service.port }}
          #   initialDelaySeconds: 60
          #   periodSeconds: 10
          # readinessProbe:
          #   httpGet:
          #     path: /actuator/health
          #     port: {{ .Values.apiFestival.service.port }}
          #   initialDelaySeconds: 60
          #   periodSeconds: 5