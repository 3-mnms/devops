{{- define "db.appName" -}}api-payment-database{{- end }}
{{- define "db.fullname" -}}{{ .Release.Name }}-{{ include "db.appName" . }}{{- end }}

{{- define "db.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiPaymentDatabase | default "api-payment-database-service" -}}
{{- $name -}}
{{- end }}