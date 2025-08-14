


{{- define "api-gateway.name" -}}
api-gateway
{{- end }}

# deployment 용 name 
{{- define "api-gateway.fullname" -}}
{{ printf "%s-%s" .Release.Name "api-gateway" | trunc 63 | trimSuffix "-" }}
{{- end }}

#  service 네임 고정을 위한 작업
{{- define "api-gateway.servicename" -}}
{{- if .Values.global.service.apiGateway }}
{{- .Values.global.service.apiGateway | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
api-gateway-service
{{- end }}
{{- end }}

# gateway 노출용 exposeLabel
{{- define "api-gateway.exposelabel" -}}
{{- if .Values.global.apiGateway.exposelabel }}
{{ .Values.global.apiGateway.exposelabel }}
{{- else }}
expose-via-spring-gateway
{{- end }}
{{- end }}


{{- define "api-gateway.infranamespace" -}}
{{- if .Values.global.namespace.infra }}
{{- .Values.global.namespace.infra | trunc 63 | trimSuffix "-" }}
{{- else if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
infra
{{- end }}
{{- end }}

{{- define "api-gateway.externalname" -}}
{{ include "api-gateway.servicename" . }}.{{ include ".Release.Namespace" . }}.svc.cluster.local
{{- end }}

{{- define "api-gateway-ingress.externalname" -}}
{{ include "api-gateway.servicename" . }}.{{ include ".Release.Namespace" . }}.svc.cluster.local
{{- end }}


#
# Ingress 관련 설정
#
{{- define "api-gateway-ingress.url" -}}
{{- if .Values.global.domain }}
{{ .Values.global.domain }}
{{- else }}
rookies-tekcit.com
{{- end }}
{{- end }}


{{- define "api-gateway-ingress.host" -}}
{{- if .Values.global.domain }}
{{- printf "api.%s" .Values.global.domain -}}
{{- else }}
api.rookies-tekcit.com
{{- end }}
{{- end }}

# =====================
# AWS Ingress 관련 설정
# ====================

# Annotation 설정
{{- define "api-gateway-ingress.aws.annotations.ingress" -}}
kubernetes.io/ingress.class: alb
alb.ingress.kubernetes.io/scheme: {{ .Values.apiGateway.ingress.aws.scheme | default "internet-facing" }}
alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
alb.ingress.kubernetes.io/target-type: ip
alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
{{- if .Values.apiGateway.ingress.tls }}
alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
{{- end -}}
{{- end -}}




# =====================
# GCE Ingress 관련 설정
# =====================
{{- define "api-gateway-ingress.gce.backendconfing.name" -}}
{{- if .Values.apiGateway.ingress.gce.backendConfigName }}
{{ .Values.apiGateway.ingress.gce.backendConfigName }}
{{- else }}
api-gateway-backendconfig
{{- end -}}
{{- end -}}

{{- define "api-gateway-ingress.gce.annotations.service" -}}
kubernetes.io/ingress.class: gce
cloud.google.com/backend-config: '{"http":"{{ include "api-gateway-ingress.gce.backendconfing.name" . }}"}'

{{- end -}}

{{- define "api-gateway-ingress.gce.annotations.ingress" -}}
kubernetes.io/ingress.class: gce
kubernetes.io/ingress.global-static-ip-name: {{ .Values.apiGateway.ingress.gce.ipName | default "rookies-tkcit-static-ip" }}
{{- end -}}

