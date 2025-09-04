apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-booking.fullname" . }}
  labels:
    {{- include "api-booking.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.apiBooking.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "api-booking.fullname" . }}
  template:
    metadata:
      labels:
        app: {{ include "api-booking.fullname" . }}
    spec:
      containers:
        - name: booking
          image: "{{ .Values.apiBooking.image.registry }}/{{ .Values.apiBooking.image.repository }}:{{ .Values.apiBooking.image.tag }}"
          imagePullPolicy: {{ .Values.apiBooking.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.apiBooking.service.port }}
          env:
            - name: SPRING_PROFILES_ACTIVE
              value: "prod"

            # Database
            - name: DB_URL
              value: "jdbc:mariadb://{{ .Values.global.service.apiBookingDatabase | default "api-booking-database-service" }}:{{ .Values.apiBookingDatabase.service.port | default 3306 }}/{{ .Values.apiBookingDatabase.auth.database | default "booking" }}"
            - name: DB_USERNAME
              value: {{ .Values.apiBookingDatabase.auth.username | default "rookies" }}
            - name: DB_PASSWORD
              value: {{ .Values.apiBookingDatabase.auth.password | default "rookies" }}
            
            # Redis
            - name: REDIS_SERVER_URL
              value: "api-booking-redis-service"
            - name: REDIS_PORT
              value: 6379

            # Kafka
            - name: KAFKA_SERVERS
              value: {{ include "api-booking.kafka-server" . }}

            # External APIs
            - name: BASE_API
              value: {{ include "api-booking.user-server" . }}
            - name: USER_BASE_API
              value: {{ include "api-booking.user-server" . }}
            - name: USER_INFO_API
              value: /api/users/booking-profile
            - name: USER_STATS_LIST_API
              value: /api/users/statisticsList
            - name: BOOKING_USER_INFO_API
              value: /api/users/reservationList
            
            - name: MAIL_USERNAME
              valueFrom:
                secretKeyRef:
                  name: api-booking-secret
                  key: MAIL_USERNAME
            - name: MAIL_PASSWORD
              valueFrom:
                secretKeyRef:
                  name: api-booking-secret
                  key: MAIL_PASSWORD
            # OCR Settings  
            - name: OCR_SECRET_KEY
              valueFrom:
                secretKeyRef:
                  name: api-booking-secret
                  key: OCR_SECRET_KEY
            - name: OCR_INVOKE_URL
              valueFrom:
                secretKeyRef:
                  name: api-booking-secret
                  key: OCR_INVOKE_URL
          resources:
            requests:
              cpu: {{ .Values.apiBooking.resources.requests.cpu | default "256m" }}
              memory: {{ .Values.apiBooking.resources.requests.memory | default "256Mi" }}
            limits:
              cpu: {{ .Values.apiBooking.resources.limits.cpu | default "500m" }}
              memory: {{ .Values.apiBooking.resources.limits.memory | default "1024Mi" }}
          # actuator 가 없어서 주석처리
          # livenessProbe:
          #   httpGet:
          #     path: /actuator/health
          #     port: {{ .Values.apiBooking.service.port }}
          #   initialDelaySeconds: 60
          #   periodSeconds: 10
          # readinessProbe:
          #   httpGet:
          #     path: /actuator/health
          #     port: {{ .Values.apiBooking.service.port }}
          #   initialDelaySeconds: 60
          #   periodSeconds: 5
