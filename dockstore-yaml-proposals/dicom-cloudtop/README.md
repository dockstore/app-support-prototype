# Title
Installation instructions for multi container DICOM CLOUDTOP.

## Prerequisites
1) Create a NFS PVC storage - name the pvc "cloud-top".
2) Copy the [config](https://github.com/helxplatform/docker-guacamole/tree/use-all-defaults-with-ohif-and-ortha/docker/config) files to the /mounts directory in the NFS PVC storage.
3) Rename the nginx-with-proxy.conf to default.conf

4) Edit the following lines.

[Edit-1](https://github.com/helxplatform/docker-guacamole/blob/ac61d6b610692807b8be6bedc279a0be727330c1/docker/config/nginx-with-proxy.conf#L10)
```
proxy_pass http://127.0.0.1:8042;
```

[Edit-2](https://github.com/helxplatform/docker-guacamole/blob/ac61d6b610692807b8be6bedc279a0be727330c1/docker/config/orthanc.json#L7)
```
"Host" : "127.0.0.1",
```



 
