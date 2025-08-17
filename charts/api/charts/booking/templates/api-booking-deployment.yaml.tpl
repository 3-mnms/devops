apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "api-booking.fullname" . }}
  labels:
    {{- include "api-booking.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.apiBooking.replicaCount }}
  selector:
    matchLabels:
      app: {{ include "api-booking.fullname" . }}
  template:
    metadata:
      labels:
        app: {{ include "api-booking.fullname" . }}
    spec:
      volumes:
        - name: config-volume
          configMap:
            name: api-booking-booking-config
      containers:
        - name: booking
          image: "{{ .Values.apiBooking.image.registry }}/{{ .Values.apiBooking.image.repository }}:{{ .Values.apiBooking.image.tag }}"
          imagePullPolicy: {{ .Values.apiBooking.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.apiBooking.service.port }}
          envFrom:
            - configMapRef:
                name: api-booking-booking-config
          volumeMounts:
            - name: config-volume
              mountPath: /config
              readOnly: true
          env:
            - name: SPRING_CONFIG_LOCATION
              value: "file:/config/application.properties"