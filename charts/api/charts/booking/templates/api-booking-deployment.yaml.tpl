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
            items:
              - key: application-dev.properties
                path: application-dev.properties
      containers:
        - name: booking
          image: "{{ .Values.apiBooking.image.registry }}/{{ .Values.apiBooking.image.repository }}:{{ .Values.apiBooking.image.tag }}"
          imagePullPolicy: {{ .Values.apiBooking.image.pullPolicy }}
          ports:
            - containerPort: {{ .Values.apiBooking.service.port }}
          env:
            - name: SPRING_PROFILES_ACTIVE
              value: dev
            - name: SPRING_CONFIG_LOCATION
              value: "classpath:/,file:/config/"
          volumeMounts:
            - name: config-volume
              mountPath: /config
              readOnly: true
          resources:
            requests:
              cpu: {{ .Values.apiBooking.resources.requests.cpu | default "256m" }}
              memory: {{ .Values.apiBooking.resources.requests.memory | default "256Mi" }}
            limits:
              cpu: {{ .Values.apiBooking.resources.limits.cpu | default "500m" }}
              memory: {{ .Values.apiBooking.resources.limits.memory | default "1024Mi" }}
          livenessProbe:
            httpGet:
              path: /actuator/health
              port: {{ .Values.apiBooking.service.port }}
            initialDelaySeconds: 60
            periodSeconds: 10
          readinessProbe:
            httpGet:
              path: /actuator/health
              port: {{ .Values.apiBooking.service.port }}
            initialDelaySeconds: 60
            periodSeconds: 5
