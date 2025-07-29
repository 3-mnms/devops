# my-kafka-chart/templates/_helpers.tpl
{{- define "kafka.name" -}}
{{- default .Chart.Name .Values.nameOverride -}}
{{- end -}}

{{- define "kafka.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "kafka.headlessfullname" -}}
{{- printf "%s-headless" (include "kafka.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{- define "kafka.controllerQuorumVoters" -}}
{{- $fullName := include "kafka.fullname" . -}}
{{- $headlessService := include "kafka.headlessfullname" . -}}
{{- $namespace := .Release.Namespace -}}
{{- $replicaCount := int .Values.replicaCount -}} 

{{- $controllerPort := int .Values.service.headlessPort -}}

{{- $voters := list -}}
{{- range $i := until $replicaCount -}}
  {{- $voter := printf "%d@%s-%d.%s.%s.svc.cluster.local:%d" $i $fullName $i $headlessService $namespace $controllerPort -}}
  {{- $voters = append $voters $voter -}}
{{- end -}}
{{- join "," $voters -}}
{{- end -}}



{{- define "kafka.bootstrapServers" -}}
{{- $fullName := include "kafka.fullname" . -}}
{{- $headlessService := include "kafka.headlessfullname" . -}}
{{- $namespace := .Release.Namespace -}}
{{- $replicaCount := int .Values.replicaCount -}} 
{{- $brokerPort := int .Values.service.port -}} 
{{- $servers := list -}}
{{- range $i := until $replicaCount -}}
  {{- $server := printf "%s-%d.%s.%s.svc.cluster.local:%d" $fullName $i $headlessService $namespace $brokerPort -}}
  {{- $servers = append $servers $server -}}
{{- end -}}
{{- join "," $servers -}}
{{- end -}}