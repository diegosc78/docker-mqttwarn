# docker-mqttwarn
Docker multiarch slim image for mqttwarn

## References

This repo is only for building a docker image. Original product is located here: <https://github.com/jpmens/mqttwarn>
You can check product versions here: <https://github.com/mqtt-tools/mqttwarn/blob/main/CHANGES.rst>

## Why this repo

Only for my own convenience in my home k8s cluster. I want a mqttwarn docker image:
- Based on stable published product releases (pip, not github source)
- Multiarch
- Slim... only product and telegram plugin

## Where is the docker image

Here it is <https://hub.docker.com/r/ponte124/mqttwarn>

## How to build the image

- Modify Makefile. 
    - Usually only needed to change mqttwarn version and, maybe python version. Check [product versions page] (https://github.com/mqtt-tools/mqttwarn/blob/main/CHANGES.rst). 
    - Obviously, if you want to publish the image to dockerhub, you'll need to put your dockerhub username in Makefile variable.
- Use makefile for multiarch building and publishing

```bash
make buildx
```
