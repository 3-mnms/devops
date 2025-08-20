{{- define "api-user.fullname" -}}
{{ .Release.Name }}-user
{{- end }}

{{- define "api-user.labels" -}}
app.kubernetes.io/name: {{ include "api-user.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "api-user.servicename" -}}
{{- if .Values.global.service.apiUser -}}
{{- .Values.global.service.apiUser | trunc 63 | trimSuffix "-" -}}
{{- else if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
api-user-service
{{- end -}}
{{- end -}}

{{- define "api-user.exposelabel" -}}
{{- if .Values.global.apiGateway.serviceLabel }}
{{ .Values.global.apiGateway.serviceLabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}