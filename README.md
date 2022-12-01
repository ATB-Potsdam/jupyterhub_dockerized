# jupyterhub_dockerized

This project creates a dockerized jupyterhub with Github authentication.


## Prerequisites

You may create an organisation at Github and add _public_ members to restrict access. As alternatives you can grant access for users explicitly by name or use a different authentication method than Github OAuth2.
Also a server with Docker running is nessecary.

## Install


### Create OAuth configuration

You can only login with a Github account that belongs to an organisation. Create an OAuth application at the Github organisation settings.
As callback URL enter https://YOUR_JUPYTERHUB_DOMAIN/hub/oauth_callback

Add the domain, client-id and client-secret at the jupyterhub_config.py


### Build and run jupyterhub docker containers

To build the docker images and restart jupyterhub and all running jupyter processes, simply run
```sudo build-and-run-jupyterhub.sh```

Caution: The script possibly kills all running notebook instances.

The server listens on port 80 and 443 on all interfaces.
