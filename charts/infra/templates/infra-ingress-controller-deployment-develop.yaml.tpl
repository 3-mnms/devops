{{- if eq .Values.infra.ingress.mode "develop" }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: infra-ingress-controller
  namespace: {{ .Release.Namespace }}
  labels:
    app: infra-ingress-controller
spec:
  replicas: {{ .Values.infra.ingress.controller.replicaCount }}
  selector:
    matchLabels:
      app: infra-ingress-controller
  template:
    metadata:
      labels:
        app: infra-ingress-controller
    spec:
      containers:
        - name: controller
          image: "{{ .Values.infra.ingress.controller.image.repository }}:{{ .Values.infra.ingress.controller.image.tag }}"
          imagePullPolicy: {{ .Values.infra.ingress.controller.image.pullPolicy }}
          args:
            - /nginx-ingress-controller
            - --election-id=ingress-controller-leader
            - --controller-class=k8s.io/ingress-nginx
            - --ingress-class=nginx
            - --configmap=$(POD_NAMESPACE)/infra-ingress-controller-conf
          ports:
            - name: http
              containerPort: 80
            - name: https
              containerPort: 443
{{- with .Values.infra.ingress.controller.nodeSelector }}
      nodeSelector:
{{ toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.infra.ingress.controller.tolerations }}
      tolerations:
{{ toYaml . | nindent 8 }}
{{- end }}
{{- with .Values.infra.ingress.controller.affinity }}
      affinity:
{{ toYaml . | nindent 8 }}
{{- end }}
{{- end }}