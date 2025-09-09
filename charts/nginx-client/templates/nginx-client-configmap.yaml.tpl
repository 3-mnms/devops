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

      location /health {
          access_log off;
          return 200 'healthy';
          add_header Content-Type text/plain;
      }
      
      if ($http_user_agent ~* "Mobile|Android|iPhone") {
          add_header Cache-Control "no-cache, no-store, must-revalidate";
          add_header Pragma "no-cache";
          add_header Expires 0;
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

      location /health {
          access_log off;
          return 200 'healthy';
          add_header Content-Type text/plain;
      }

      if ($http_user_agent !~* "Mobile|Android|iPhone") {
          add_header Cache-Control "no-cache, no-store, must-revalidate";
          add_header Pragma "no-cache";
          add_header Expires 0;
          return 301 https://www.{{ .Values.global.domain }}$request_uri;
      }

      location / {
          try_files $uri /index.html;
      }
    }

