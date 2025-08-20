---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "api-gateway.fullname" . }}-sa
  namespace: {{ .Release.Namespace }}
  {{- if eq .Values.apiGateway.ingress.mode "aws" }}
  annotations:
    eks.amazonaws.com/role-arn: {{ .Values.apiGateway.ingress.aws.roleArn | default "arn:aws:iam::123456789012:role/RookiesApiGatewayRole" }}
  {{- end }}
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: {{ include "api-gateway.fullname" . }}-clusterrole
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "list", "watch"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: {{ include "api-gateway.fullname" . }}-clusterrolebinding
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: {{ include "api-gateway.fullname" . }}-clusterrole
subjects:
  - kind: ServiceAccount
    name: {{ include "api-gateway.fullname" . }}-sa
    namespace: {{ .Release.Namespace }}