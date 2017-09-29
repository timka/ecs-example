Minimalistic ECS setup example
==============================


Setup
-----

1. `vagrant up` to create a development box w/ everything necessary (Docker, AWS tools)
1. `ssh-add ~/.ssh/id_rsa` to add your SSH RSA key to agent. The pub key will be imported into an EC2 key pair
1. `vagrant ssh -- -A` to SSH into the bex w/ agent forwarding
1. `aws conifgure` to set your AWS credentials
1. `cd /vagrant`


Deploy
------

1. `./setup.sh stage` to create `stage` cluster and run services from `docker-compose.yml`
1. `./setup.sh prod` to do the same for `prod` cluster


Update
------

1. Change `wordpress:8.4.1` to `wordpress:8.4.2` in `docker-compose.yml`
1. `ecs-cli compose --cluster stage service up`
1. `ecs-cli compose --cluster prod  service up`


Destroy
-------

1. `ecs-cli compose --cluster stage service rm`
1. `ecs-cli down --cluster stage --force`
1. `ecs-cli compose --cluster prod service rm`
1. `ecs-cli down --cluster prod --force `
