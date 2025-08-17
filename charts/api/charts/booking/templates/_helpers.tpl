{{- define "api-booking.fullname" -}}
{{ .Release.Name }}-booking
{{- end }}

{{- define "api-booking.labels" -}}
app.kubernetes.io/name: {{ include "api-booking.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "api-booking.servicename" -}}
{{- if .Values.global.service.apiBooking }}
{{- .Values.global.service.apiBooking | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
api-booking-service
{{- end }}
{{- end }}

{{- define "api-booking.exposelabel" -}}
{{- if .Values.global.apiGateway.serviceLabel }}
{{ .Values.global.apiGateway.serviceLabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}

#
# Application Properties
# 
#
# Application Properties
# 
{{- define "api-booking.applicationProperties" -}}
spring.application.name=booking


server.port=8080

server.address=0.0.0.0


# log file
logging.file.path=logs
logging.level.com.basic.myspringboot=debug

# MariaDB Database 설정
spring.datasource.url=jdbc:mariadb://{{ .Values.global.service.apiBookingDatabase | default "api-booking-database-service" }}:{{ .Values.apiBookingDatabase.service.port | default 3306 }}/{{ .Values.apiBookingDatabase.auth.database | default "booking" }}
spring.datasource.driver-class-name=org.mariadb.jdbc.Driver
spring.datasource.username={{ .Values.apiBookingDatabase.auth.username | default "rookies" }}
spring.datasource.password={{ .Values.apiBookingDatabase.auth.password | default "rookies" }}

# JPA 설정
spring.jpa.database-platform=org.hibernate.dialect.MariaDBDialect
spring.jpa.hibernate.ddl-auto=update

# Redis 설정
spring.data.redis.host={{ .Values.global.service.apiBookingRedis | default "api-booking-redis-service" }}
spring.data.redis.port={{ .Values.apiBookingRedis.service.port | default 6379 }}

# Kafka 설정
app.kafka.topic.booking-event=booking-events
app.kafka.topic.user-event=user-events
spring.kafka.bootstrap-servers={{ printf "%s:%d" (default "kafka-service" .Values.global.service.kafka) 9092 }}
spring.kafka.consumer.auto-offset-reset=earliest
spring.kafka.consumer.value-deserializer=org.apache.kafka.common.serialization.StringDeserializer
spring.kafka.consumer.properties.spring.json.trusted.packages=*
spring.kafka.consumer.properties.spring.json.use.type.headers=false
{{- end }}
