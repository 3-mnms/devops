apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: {{ include "api-festival.fullname" . }}-hpa
  namespace: {{ .Release.Namespace }}
spec:
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: {{ include "api-festival.fullname" . }}
  minReplicas: 1
  maxReplicas: 3
  metrics:
    - type: Resource
      resource:
        name: cpu
        target:
          type: Utilization
          averageUtilization: 80   
  behavior:
    scaleUp:
      stabilizationWindowSeconds: 10    
      policies:
        - type: Percent
          value: 100                   
          periodSeconds: 5
    scaleDown:
      stabilizationWindowSeconds: 60    
      policies:
        - type: Percent
          value: 50                    
          periodSeconds: 5