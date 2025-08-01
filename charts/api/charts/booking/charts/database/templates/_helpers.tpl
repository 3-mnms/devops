{{- define "bookingdb.appName" -}}api-booking-database{{- end }}
{{- define "bookingdb.fullname" -}}{{ .Release.Name }}-{{ include "bookingdb.appName" . }}{{- end }}

{{- define "bookingdb.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.apiBookingDatabase | default "api-booking-database-service" -}}
{{- $name -}}
{{- end }}
