#! /bin/sh

# 1. Start ssh agent to avoid more passwords
eval `ssh-agent` && ssh-add > /dev/null

# 2.- Execute pre-commit
/root/bin/pre-commit $@
