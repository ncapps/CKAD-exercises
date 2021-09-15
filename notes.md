# Notes from Exercises
### Running a k3d cluster locally
```sh
# Create a new cluster
make create

# Cleanup and delete the cluster
make delete
```

### Exam init
1. Enable Kubectl autocomplete (reference/kubectl/cheatsheet)
```sh
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.

alias k=kubectl
complete -F __start_kubectl k
```
