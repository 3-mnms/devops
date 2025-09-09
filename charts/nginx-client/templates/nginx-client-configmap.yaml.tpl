apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "nginx-client.fullname" . }}-config
data:
  default-pc.conf: |
    server {
      listen 80;
      server_name www.{{ .Values.global.domain }};

      root /usr/share/nginx/html;
      index index.html;

      if ($http_user_agent ~* "Mobile|Android|iPhone") {
          return 301 https://m.{{ .Values.global.domain }}$request_uri;
      }

      location / {
          try_files $uri /index.html;
      }
    }
    
  default-mobile.conf: |
    server {
      listen 80;
      server_name m.{{ .Values.global.domain }};

      root /usr/share/nginx/html;
      index index.html;

      if ($http_user_agent !~* "Mobile|Android|iPhone") {
          return 301 https://www.{{ .Values.global.domain }}$request_uri;
      }

      location / {
          try_files $uri /index.html;
      }
    }

