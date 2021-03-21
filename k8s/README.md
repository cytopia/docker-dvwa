# Kubernetes deployment



## Minikube

The following show-cases how to deploy everything locally on minikube.

### Start minikube
```bash
minikube start
```


### Make Loadbalancer work with minikube

Retrieve the IP address minikube is running on
```bash
$ minikube ip
192.168.49.2
```

Install metallb
```bash
$ minikube addons enable metallb
```

Configure an IP address range for metallb, based on the minikube address found earlier. Just increment a few digits:
```
$ minikube addons configure metallb
-- Enter Load Balancer Start IP: 192.168.49.10
-- Enter Load Balancer End IP: 192.168.49.20
```

Verify
```
kubectl describe configmap config -n metallb-system
```


### Deploy

Ensure to be inside the `k8s/` directory of this repository.

```bash
kubectl apply -f .
```


### View

Retrieve the load balancer URL
```bash
$ kubectl get svc dvwa-web-service
NAME               TYPE           CLUSTER-IP       EXTERNAL-IP     PORT(S)          AGE
dvwa-web-service   LoadBalancer   10.102.127.193   192.168.49.10   8081:30434/TCP   78s
```
Then open http://192.168.49.10:8081
