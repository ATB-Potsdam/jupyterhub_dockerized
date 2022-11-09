#!/bin/sh


docker pull jupyterhub/singleuser:latest
docker build ./jupyter -t jupyter_atb:latest || exit 1

docker pull jupyterhub/jupyterhub:latest
docker build ./jupyterhub -t jupyterhub_atb:latest || exit 1

for container in `docker ps | grep "jupyter-" | cut -d" " -f1`; do
    docker kill $container
done

docker kill jupyter
docker kill jupyterhub
echo y | docker system prune

sudo mkdir -p /var/lib/jupyterhub/srv
sudo mkdir -p /var/lib/jupyterhub/crontabs
mkdir -p /var/lib/jupyterhub/users
mkdir -p /var/lib/jupyterhub/shared
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
    -v /var/lib/jupyterhub/crontabs:/var/spool/cron/crontabs \
    jupyterhub_atb:latest \
    jupyterhub --debug
