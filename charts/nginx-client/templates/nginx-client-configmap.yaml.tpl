apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "nginx-client.fullname" . }}-config
data:
  default-pc.conf: |
    map $http_user_agent $redirect_domain {
        default www.{{ .Values.global.domain }};
        "~*Mobile|Android|iPhone" m.{{ .Values.global.domain }};
    }

    server {
        listen 80;
        server_name www.{{ .Values.global.domain }} m.{{ .Values.global.domain }};

        if ($http_user_agent = "ELB-HealthChecker/2.0") {
            return 200 "healthy";
        }

        if ($host != $redirect_domain) {
            return 301 https://$redirect_domain$request_uri;
        }

        root /usr/share/nginx/html;
        index index.html;

        location / {
            add_header Cache-Control "no-cache, no-store, must-revalidate";
            add_header Pragma "no-cache";
            add_header Expires 0;
            try_files $uri /index.html;
        }
    }
    
  default-mobile.conf: |
    map $http_user_agent $redirect_domain {
        default www.{{ .Values.global.domain }};
        "~*Mobile|Android|iPhone" m.{{ .Values.global.domain }};
    }

    server {
        listen 80;
        server_name www.{{ .Values.global.domain }} m.{{ .Values.global.domain }};

        if ($http_user_agent = "ELB-HealthChecker/2.0") {
            return 200 "healthy";
        }

        if ($host != $redirect_domain) {
            return 301 https://$redirect_domain$request_uri;
        }

        root /usr/share/nginx/html;
        index index.html;

        location / {
            add_header Cache-Control "no-cache, no-store, must-revalidate";
            add_header Pragma "no-cache";
            add_header Expires 0;
            try_files $uri /index.html;
        }
    }

