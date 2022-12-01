#!/bin/sh

mkdir "/srv/users/$1"
chown -R 1000 "/srv/users/$1"
chgrp -R 100 "/srv/users/$1"
mkdir "/srv/users/$1/.ssh"
chown -R 1000 "/srv/users/$1/.ssh"
chgrp -R 100 "/srv/users/$1/.ssh"

mkdir "/srv/shared/$1"
chown -R 1000 "/srv/shared/$1"
chgrp -R 100 "/srv/shared/$1"
