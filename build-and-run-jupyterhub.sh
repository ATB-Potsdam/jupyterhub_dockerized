#!/bin/sh


docker build ./jupyter -t jupyter_atb:latest
docker build ./jupyterhub -t jupyterhub_atb:latest

for container in `docker ps | grep "jupyter-" | cut -d" " -f1`; do
    docker kill $container
done

docker kill jupyter
docker kill jupyterhub
echo y | docker system prune

mkdir -p /var/lib/jupyterhub/srv
mkdir -p /var/lib/jupyterhub/users
sudo cp -n jupyterhub_config.py /var/lib/jupyterhub/srv
sudo cp user-bootstrap.sh /var/lib/jupyterhub/srv


docker run -dt --restart=always \
    --name jupyterhub \
    -p 8000:8000 \
    -p 172.17.0.1:8081:8081 \
    --add-host jupyterhub:0.0.0.0 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /var/lib/jupyterhub/srv:/srv/jupyterhub \
    -v /var/lib/jupyterhub/users:/srv/users \
    -v /var/lib/jupyterhub/shared:/srv/shared \
    jupyterhub_atb:latest \
    jupyterhub --debug
