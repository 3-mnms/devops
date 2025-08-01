{{- define "infra.name" -}}
infra
{{- end }}

{{- define "infra.fullname" -}}
{{ printf "%s-%s" .Release.Name (include "infra.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}


{{- define "infra.labels" -}}
app: {{ include "infra.name" . }}
app.kubernetes.io/name: {{ include "infra.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}


{{- define "infra.apiServiceName" -}}
{{- if .Values.global.service.apiGateway }}
{{- .Values.global.service.apiGateway | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
api-gateway-service
{{- end -}}
{{- end -}}

{{- define "infra.clientServiceName" -}}
{{- if .Values.global.service.client }}
{{- .Values.global.service.client | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
nginx-client-service
{{- end -}}
{{- end -}}
