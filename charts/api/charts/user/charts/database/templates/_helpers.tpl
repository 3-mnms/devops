{{- define "userdb.appName" -}}api-user-database{{- end }}
{{- define "userdb.fullname" -}}{{ .Release.Name }}-{{ include "userdb.appName" . }}{{- end }}

{{- define "userdb.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiUserDatabase | default "api-user-database-service" -}}
{{- $name -}}
{{- end }}