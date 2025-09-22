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
{{- if .Values.global.apiGateway.serviceLabel }}
{{ .Values.global.apiGateway.serviceLabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}


{{- define "api-payment.kafka.url" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.kafka | default "kafka-service" -}}
{{- $name -}}.kafka.svc.cluster.local:9092
{{- end -}}

{{- define "api-payment.database.url" -}}
jdbc:mariadb://{{ .Values.global.service.apiPaymentDatabase | default "api-payment-database-service" }}:3306/{{ .Values.apiPayment.database.name }}
{{- end -}}
