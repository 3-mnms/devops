apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "nginx-client.fullname" . }}-config
data:

  default.conf: |
    server {
      listen 80;
      server_name _;

      root /usr/share/nginx/html;
      index index.html;

      if ($http_user_agent ~* "Mobile|Android|iPhone") {
          return 301 https://m.{{ .Values.global.domain }}$request_uri;
      }
      return 301 https://www.{{ .Values.global.domain }}$request_uri;

      location / {
          try_files $uri /index.html;
      }
    }

