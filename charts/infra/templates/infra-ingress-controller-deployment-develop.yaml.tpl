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
      serviceAccountName: {{ include "infra-ingress.serviceaccountname" . }}
      containers:
        - name: controller
          image: "{{ .Values.infra.ingress.controller.image.repository }}:{{ .Values.infra.ingress.controller.image.tag }}"
          imagePullPolicy: {{ .Values.infra.ingress.controller.image.pullPolicy }}
          args:
            - /nginx-ingress-controller
            - --ingress-class=nginx
          ports:
            - name: http
              containerPort: 80
{{- end }}