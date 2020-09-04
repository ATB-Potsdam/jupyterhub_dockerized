# jupyterhub_dockerized

This project creates a dockerized jupyterhub with Github authentication.


## Prerequisites

You have to create an organisation at Github.
Also a server with Docker running is nessecary.

## Install


### Create OAuth configuration

You can only login with a Github account that belongs to an organisation. Create an OAuth application at the Github organisation settings.
As callback URL enter https://YOUR_JUPYTERHUB_DOMAIN/hub/oauth_callback

Add the domain, client-id and client-secret at the jupyterhub_config.py

### Setup proxy and ssl

Setup a proxy that proxies requests to your domain to the jupyterhub at localhost:8000
Use nginx-config-snippet.conf as an example.

Make sure your proxy handles ssl connections well.


### Build and run jupyterhub docker containers

To build the docker images and restart jupyterhub and all running jupyter processes, simply run
```sudo build-and-run-jupyterhub.sh```

Caution: The script will kill all running notebook instances.
