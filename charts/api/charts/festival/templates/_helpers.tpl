{{- define "api-festival.fullname" -}}
{{ .Release.Name }}-festival
{{- end }}

{{- define "api-festival.labels" -}}
app.kubernetes.io/name: {{ include "api-festival.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "api-festival.servicename" -}}
{{- if .Values.global.service.apiFestival }}
{{- .Values.global.service.apiFestival | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
api-festival-service
{{- end }}
{{- end }}

{{- define "api-festival.exposelabel" -}}
{{- if .Values.global.apiGateway.serviceLabel }}
{{ .Values.global.apiGateway.serviceLabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}


{{- define "api-festival.kafka.url" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.kafka | default "kafka-service" -}}
{{- $name -}}.kafka.svc.cluster.local:9092
{{- end -}}

{{- define "api-festival.database.url" -}}
jdbc:mariadb://{{ .Values.global.service.apiFestivalDatabase | default "api-festival-database-service" }}:3306/{{ .Values.apiFestival.database.name }}
{{- end -}}
