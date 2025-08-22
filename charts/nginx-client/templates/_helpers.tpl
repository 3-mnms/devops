{{/*
Expand the name of the chart.
*/}}
{{- define "nginx-client.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "nginx-client.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.client | default "nginx-client-service" -}}
{{- $name -}}
{{- end }}



{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "nginx-client.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "nginx-client.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "nginx-client.labels" -}}
helm.sh/chart: {{ include "nginx-client.chart" . }}
{{ include "nginx-client.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "nginx-client.selectorLabels" -}}
app: {{ include "nginx-client.name" . }}
app.kubernetes.io/name: {{ include "nginx-client.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "nginx-client.serviceAccountName" -}}
{{- if .Values.nginxClient.serviceAccount.create }}
{{- default (include "nginx-client.fullname" .) .Values.nginxClient.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.nginxClient.serviceAccount.name }}
{{- end }}
{{- end }}






# =====================
# AWS Ingress 관련 설정
# ====================

# Annotation 설정
{{- define "nginx-client-ingress.aws.annotations.ingress" -}}
kubernetes.io/ingress.class: alb
alb.ingress.kubernetes.io/scheme: {{ .Values.nginxClient.ingress.aws.scheme | default "internet-facing" }}
alb.ingress.kubernetes.io/target-type: ip
{{- if eq .Values.nginxClient.ingress.tls true }}
alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
alb.ingress.kubernetes.io/certificate-arn: {{ .Values.nginxClient.ingress.aws.certificateArn | quote }}
{{- else }}
alb.ingress.kubernetes.io/listen-ports: '[{"HTTP":80}]'
{{- end -}}
{{- end -}}




# =====================
# GCE Ingress 관련 설정
# =====================


{{- define "nginx-client-ingress.gce.annotations.service" -}}
kubernetes.io/ingress.class: gce
cloud.google.com/backend-config: '{"ports":{"http":"{{ include "nginx-client-ingress.gce.backendconfing.name" . | trim }}"}}'
{{- end -}}

{{- define "nginx-client-ingress.gce.annotations.ingress" -}}
kubernetes.io/ingress.class: gce
kubernetes.io/ingress.global-static-ip-name: {{ .Values.nginxClient.ingress.gce.ipName | default "rookies-tkcit-static-ip" }}
{{- end -}}


{{- define "nginx-client.serviceaccountname" -}}
{{ include "nginx-client.fullname" . }}-sa
{{- end -}}



#
# Ingress 관련 설정
#
{{- define "nginx-client-ingress.url" -}}
{{- if .Values.global.domain -}}
{{ .Values.global.domain }}
{{- else -}}
rookies-tekcit.com
{{- end }}
{{- end }}


{{- define "nginx-client-ingress.host" -}}
{{- if .Values.global.domain }}
{{- printf "www.%s" .Values.global.domain -}}
{{- else }}
www.rookies-tekcit.com
{{- end }}
{{- end }}



