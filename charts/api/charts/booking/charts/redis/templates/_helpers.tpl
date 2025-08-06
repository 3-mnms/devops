{{- define "bookingredis.appName" -}}api-booking-redis{{- end }}
{{- define "bookingredis.fullname" -}}{{ .Release.Name }}-{{ include "bookingredis.appName" . }}{{- end }}

{{- define "bookingredis.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiBookingRedis | default "api-booking-redis-service" -}}
{{- $name -}}
{{- end }}