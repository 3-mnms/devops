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
{{- define "api-booking.kafka-server" -}}
{{ printf "%s.kafka.svc.cluster.local:%d" (default "kafka-service" .Values.global.service.kafka) 9092 }}
{{- end -}}

{{- define "api-booking.user-server" -}}
{{ printf "http://%s.user.svc.cluster.local:%d" (default "api-user-service" .Values.global.service.apiUser) 8080 }}
{{- end -}}


