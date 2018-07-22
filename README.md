How to use this
========

build
---- 
```bash
$ DOCKER_REGISTRY=<registry> \
    DOCKER_USERNAME=<username> \
    DOCKER_PASSWORD=<password> \
    ballerina build hello.bal
```

Run locally
---- 
```bash
$ ballerina run hello.bal
```

Deploy to Kubernetes
---- 
After `build` step and assuming you have a working cluster and `kubectl` access credentials.

```bash
$ kubectl -f create ./kubernetes
```

> For now I could not make `@kubernetes:Ingress` to work properly (getting exception at compilation time) so I've addes the `custom-k8s/ingress.yaml` file for basic ingress (assuming Ingress controller already implemented or integreated to your cluster).