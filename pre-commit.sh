#! /bin/sh
# VARIABLES: Consider updating to adapt your environment

# Local folder storing SSH identity information
#  It is not mandatory to include anything, but must exist.
#  Is recommened to include, at least a passwordless `id_rsa` and `known_hosts` to avoid user interaction
ssh_cfg=~/.ssh

# Local folder caching pre-commit repositories
#  If it does not exist, it will be created.
#  If pre-existing for a previous pre-commit local installation, it may need a `pre-commit clean`
pcommit_cache=~/.cache/pre-commit

# CONSTANTS: DO NOT TOUCH
# Container image.
image=pre-commit:latest

book=$(pwd)

container_book=/tmp/coursebook
container_ssh_cfg=/root/.ssh
container_pcommit_cache=/root/.cache/pre-commit
container_name=pre-commit-$RANDOM

ssh_cfg_cpy=$(mktemp -d /tmp/pre-commit-XXXXX)
##############

# Create a temp copy for the keys
cp -r ${ssh_cfg}/* ${ssh_cfg_cpy}

# If not exist, create the cache folder.
if [ ! -d $pcommit_cache ]; then
  mkdir -p $pcommit_cache;
fi

# Execute container image
podman run --name ${container_name} -ti \
     -v ${book}:${container_book}:z \
     -v ${ssh_cfg_cpy}:${container_ssh_cfg}:z \
     -v ${pcommit_cache}:${container_pcommit_cache}:z \
     ${image} $@

# Cleanup 
rm -rf ${ssh_cfg_cpy}
podman rm -f ${container_name} > /dev/null