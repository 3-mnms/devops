
### argo cd
kubectl port-forward svc/argocd-server -n argocd 8080:443

#### 초기 패스워드 
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo

### kafka ui
kubectl port-forward svc/kafka-rookies-kafka-ui  -n [kafka namespace] 8081:8080

### api gateway 
kubectl port-forward svc/api-payment-service -n test 9090:8080


### 저장소 추가
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo update