{{- define "db.appName" -}}mariadb{{- end }}
{{- define "db.fullname" -}}{{ include "db.appName" . }}-{{ .Release.Name }}{{- end }}

{{- define "db.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiBookingDatabase | default "api-booking-database-service" -}}
{{- $name -}}
{{- end }}