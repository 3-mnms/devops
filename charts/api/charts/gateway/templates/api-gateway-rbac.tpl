---
apiVersion: v1
kind: ServiceAccount
metadata:
  name: {{ include "api-gateway.fullname" . }}-sa
  namespace: {{ .Release.Namespace }}

---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: {{ include "api-gateway.fullname" . }}-role
  namespace: {{ .Release.Namespace }}
rules:
  - apiGroups: [""]
    resources: ["services", "endpoints", "pods"]
    verbs: ["get", "list", "watch"]

---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: {{ include "api-gateway.fullname" . }}-rolebinding
  namespace: {{ .Release.Namespace }}
subjects:
  - kind: ServiceAccount
    name: {{ include "api-gateway.fullname" . }}-sa
    namespace: {{ .Release.Namespace }}
roleRef:
  kind: Role
  name: {{ include "api-gateway.fullname" . }}-role
  apiGroup: rbac.authorization.k8s.io