apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: infra-ingress-controller-role
  namespace: {{ .Release.Namespace }}
rules:
  - apiGroups: [""]
    resources: ["configmaps","endpoints","nodes","pods","secrets","services"]
    verbs: ["get","list","watch"]
  - apiGroups: ["extensions","networking.k8s.io"]
    resources: ["ingresses","ingressclasses"]
    verbs: ["get","list","watch"]
  - apiGroups: ["coordination.k8s.io"]
    resources: ["leases"]
    verbs: ["get", "watch", "list", "create", "update", "patch", "delete"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: infra-ingress-controller-binding
subjects:
  - kind: ServiceAccount
    name: {{ include "infra-ingress.serviceaccountname" . }}
    namespace: {{ .Release.Namespace }}
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: infra-ingress-controller-role
  namespace: {{ .Release.Namespace }}
