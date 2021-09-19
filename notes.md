# Notes from Exercises
### Running a k3d cluster locally
```sh
# Create a new cluster
make create

# Cleanup and delete the cluster
make delete
```
### CKAD Curriculum
https://github.com/cncf/curriculum

### Exam init
1. Enable Kubectl autocomplete (reference/kubectl/cheatsheet)
```sh
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

alias k=kubectl
complete -F __start_kubectl k
```

### Multi-Container Pod

```yaml
# Create pod with nginx container exposed at port 80
kubectl run nginx --port=80 --dry-run=client --restart=Never --image=nginx -o yaml > pod.yaml

# Add a busybox init container which downloads a page using "wget -O /work-dir/index.html http://neverssl.com/online"
# Make a volume of type emptyDir and mount it in both containers
# For the nginx container, mount it on "/usr/share/nginx/html" and for the initcontainer, mount it on "/work-dir".
# https://kubernetes.io/docs/tasks/configure-pod-container/configure-volume-storage/
# https://kubernetes.io/docs/tasks/configure-pod-container/configure-pod-initialization/
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    ports:
    - containerPort: 80
    volumeMounts:
    - name: tmp-storage
      mountPath: /usr/share/nginx/html
    resources: {}
  initContainers:
  - name: install
    image: busybox
    command:
    - wget
    - "-O"
    - "/work-dir/index.html"
    - http://neverssl.com/online
    volumeMounts:
    - name: tmp-storage
      mountPath: "/work-dir"
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  volumes:
  - name: tmp-storage
    emptyDir: {}
status: {}

# get the IP of the created pod and create a busybox pod and run "wget -O- IP"
kubectl get pod -o wide
kubectl run busybux --image=busybox --rm --restart=Never -it -- sh -c 'wget -O- 10.42.0.13:80'
```

### Pod Design
```sh
# Create multiple pods
for i in `seq 1 3`; do kubectl run nginx$i --image=nginx -l app=v1 ; done
# Remove a label
kubectl label po nginx{1..3} app-

# Create a pod that gets scheduled based on node label
# Add label to node
kubectl label node k3d-k3s-default-server-0 accelerator=nvidia-tesla-p100
# Show that the label was created
kubectl get node -L accelerator

# You can easily find out where in the YAML it should be placed by:
kubectl explain po.spec
# Add Node selector property
apiVersion: v1
kind: Pod
metadata:
  creationTimestamp: null
  labels:
    run: nginx
  name: nginx
spec:
  containers:
  - image: nginx
    name: nginx
    resources: {}
  dnsPolicy: ClusterFirst
  restartPolicy: Never
  nodeSelector:
    accelerator: nvidia-tesla-p100
status: {}
```
### Labels and Annotations
https://kubernetes.io/docs/concepts/overview/working-with-objects/annotations/

You can use either labels or annotations to attach metadata to Kubernetes objects. Labels can be used to select objects and to find collections of objects that satisfy certain conditions. In contrast, annotations are not used to identify and select objects. The metadata in an annotation can be small or large, structured or unstructured, and can include characters not permitted by labels.
