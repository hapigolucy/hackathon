Steps to build and run the docker images
1. Build the image
docker build -t myapp .
2. Run the container
# To see the log output on the same terminal window
docker run -p 80:80 myapp 
OR
# To run the container in the background
docker run -d -p 80:80 --name myapp myapp


Steps to rebuild the image on code changes
1. docker build -t myapp .
2. docker stop myapp
3. docker rm myapp
4. docker run -p 80:80 myapp

General Docker commands
1. Stop all containers at once
docker stop $(docker ps -a -q)

2. Remove all containers at once 
docker stop $(docker ps -a -q)

Kubernetes
1. Apply Kubernetes configurations
kubectl apply -f kubernetes/
2. Verify the app status
kubectl get pods
kubectl get services
3. Get minikube ip
minikube ip
4. Run the app in your browser using ip and port from service.yaml
http://192.168.49.2:30000

or 
5. tunnel creates a route to services deployed with type LoadBalancer and sets their Ingress to their ClusterIP. for a
   detailed example see https://minikube.sigs.k8s.io/docs/tasks/loadbalancer
minikube tunnel
kubectl get services
http://<external_ip>
