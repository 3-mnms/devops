apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: infra-ingress-controller-binding
subjects:
  - kind: ServiceAccount
    name: infra-ingress-controller
    namespace: infra
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin  # 임시로 cluster-admin 권한 부여 (추후 권한 최소화 권장)
