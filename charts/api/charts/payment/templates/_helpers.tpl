{{- define "api-payment.fullname" -}}
{{ .Release.Name }}-payment
{{- end }}

{{- define "api-payment.labels" -}}
app.kubernetes.io/name: {{ include "api-payment.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "api-payment.servicename" -}}
{{- if .Values.global.service.apiPayment }}
{{- .Values.global.service.apiPayment | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
api-payment-service
{{- end }}
{{- end }}

{{- define "api-payment.exposelabel" -}}
{{- if .Values.global.apiPayment.serviceLabel }}
{{ .Values.global.apiPayment.serviceLabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}