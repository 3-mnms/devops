{{- define "db.appName" -}}api-festival-database{{- end }}
{{- define "db.fullname" -}}{{ .Release.Name }}-{{ include "db.appName" . }}{{- end }}

{{- define "db.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiFestivalDatabase | default "api-festival-database-service" -}}
{{- $name -}}
{{- end }}
