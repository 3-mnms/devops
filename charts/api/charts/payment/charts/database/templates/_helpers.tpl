{{- define "paymentdb.appName" -}}api-payment-database{{- end }}
{{- define "paymentdb.fullname" -}}{{ .Release.Name }}-{{ include "paymentdb.appName" . }}{{- end }}

{{- define "paymentdb.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiPaymentDatabase | default "api-payment-database-service" -}}
{{- $name -}}
{{- end }}