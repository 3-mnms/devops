{{- define "api-message-test.fullname" -}}
{{ .Release.Name }}-message-test
{{- end }}

{{- define "api-message-test.labels" -}}
app.kubernetes.io/name: {{ include "api-message-test.fullname" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{- define "api-message-test.servicename" -}}
api-message-test-service
{{- end }}

{{- define "api-message-test.exposelabel" -}}
expose-via-spring-gateway
{{- end }}