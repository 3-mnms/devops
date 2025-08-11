


{{- define "api-gateway.name" -}}
api-gateway
{{- end }}

# deployment 용 name 
{{- define "api-gateway.fullname" -}}
{{ printf "%s-%s" .Release.Name "api-gateway" | trunc 63 | trimSuffix "-" }}
{{- end }}

#  service 네임 고정을 위한 작업
{{- define "api-gateway.servicename" -}}
{{- if .Values.global.service.apiGateway }}
{{- .Values.global.service.apiGateway | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
api-gateway-service
{{- end }}
{{- end }}

# gateway 노출용 exposeLabel
{{- define "api-gateway.exposelabel" -}}
{{- if .Values.global.apiGateway.exposelabel }}
{{ .Values.global.apiGateway.exposelabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}


{{- define "api-gateway.infranamespace"-}}
{{- if .Values.global.namespace.infra }}
{{- .Values.global.namespace.infra | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
infra
{{- end }}
{{- end }}

