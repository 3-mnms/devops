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
{{- if .Values.global.apiBooking.serviceLabel }}
{{ .Values.global.apiBooking.serviceLabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}