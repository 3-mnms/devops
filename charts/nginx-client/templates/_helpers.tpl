
# ======== nginx client 설정 ========
# 이름 설정
{{- define "nginx-client.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}



# Service 이름 설정
{{- define "nginx-client.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.client | default "nginx-client-service" -}}
{{- $name -}}
{{- end }}


# fullname 설정
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



# selectorLabels 설정
{{- define "nginx-client.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-client.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

# 라벨 설정
{{- define "nginx-client.labels" -}}
helm.sh/chart: {{- printf " %s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "nginx-client.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}



# ======== nginx mobile 설정 ========
# 이름 설정
{{- define "nginx-client-mobile.name" -}}
{{ include "nginx-client.name" . }}-mobile
{{- end }}


# fullname 설정
{{- define "nginx-client-mobile.fullname" -}}
{{ include "nginx-client.fullname" . }}-mobile
{{- end }}

# selectorLabel 설정
{{- define "nginx-client-mobile.selectorLabels" -}}
app.kubernetes.io/name: {{ include "nginx-client-mobile.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

# label 설정
{{- define "nginx-client-mobile.labels" -}}
helm.sh/chart: {{- printf " %s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{ include "nginx-client-mobile.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}



# Service 설정 
{{- define "nginx-client-mobile.serviceName" -}}
{{- $g := .Values.global | default (dict) -}}
{{- $svc := $g.service | default (dict) -}}
{{- $name := $svc.mobile | default "nginx-mobile-service" -}}
{{- $name -}}
{{- end }}


# =====================
# AWS Ingress 관련 설정
# ====================

# Annotation 설정
{{- define "nginx-client-ingress.aws.annotations.ingress" -}}
kubernetes.io/ingress.class: alb
alb.ingress.kubernetes.io/scheme: {{ .Values.nginxClient.ingress.aws.scheme | default "internet-facing" }}
alb.ingress.kubernetes.io/target-type: ip
alb.ingress.kubernetes.io/healthcheck-path: /health
alb.ingress.kubernetes.io/success-codes: "200"
{{- if eq .Values.nginxClient.ingress.tls true }}
alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}]'
alb.ingress.kubernetes.io/certificate-arn:  {{ .Values.nginxClient.ingress.aws.certificateArn | quote }}
alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
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


{{- define "nginx-client-ingress.clientHost" -}}
{{- if .Values.global.domain }}
{{- printf "www.%s" .Values.global.domain -}}
{{- else }}
www.rookies-tekcit.com
{{- end }}
{{- end }}

{{- define "nginx-client-ingress.mobileHost" -}}
{{- if .Values.global.domain }}
{{- printf "m.%s" .Values.global.domain -}}
{{- else }}
m.rookies-tekcit.com
{{- end }}
{{- end }}
