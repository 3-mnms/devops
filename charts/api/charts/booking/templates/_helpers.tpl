{{- define "apiBooking.fullname" -}}
{{ .Release.Name }}-booking
{{- end }}

{{- define "apiBooking.labels" -}}
app.kubernetes.io/name: {{ include "apiBooking.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}