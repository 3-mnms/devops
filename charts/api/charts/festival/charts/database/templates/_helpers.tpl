{{- define "festivaldb.appName" -}}api-festival-database{{- end }}
{{- define "festivaldb.fullname" -}}{{ .Release.Name }}-{{ include "festivaldb.appName" . }}{{- end }}

{{- define "festivaldb.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiFestivalDatabase | default "api-festival-database-service" -}}
{{- $name -}}
{{- end }}
