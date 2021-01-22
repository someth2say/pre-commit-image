#! /bin/sh

image=pre-commit:latest

book=$(pwd)
container_book=/tmp/coursebook

ssh_cfg=~/.ssh
ssh_cfg_cpy=$(mktemp -d -t pre-commit-XXXXX)
container_ssh_cfg=/root/.ssh

cp -r ${ssh_cfg}/* ${ssh_cfg_cpy}

pcommit_cache=~/.cache/pre-commit
container_pcommit_cache=/root/.cache/pre-commit

if [ ! -d $pcommit_cache ]; then
  mkdir -p $pcommit_cache;
fi

podman run --name pre-commit -ti \
     -v ${book}:${container_book}:z \
     -v ${ssh_cfg_cpy}:${container_ssh_cfg}:z \
     -v ${pcommit_cache}:${container_pcommit_cache}:z \
     ${image} $@

rm -rf ${ssh_cfg_cpy}
podman rm -fi pre-commit > /dev/null