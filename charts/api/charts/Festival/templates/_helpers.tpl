{{- define "apiFestival.fullname" -}}
{{ .Release.Name }}-festival
{{- end }}

{{- define "apiFestival.labels" -}}
app.kubernetes.io/name: {{ include "apiFestival.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
