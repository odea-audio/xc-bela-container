#!/usr/bin/env bash -e

# custom run command, run as "./docker-run -nc" to disable
[ -z "$1" ] && RUN_CMD="git clone git@github.com:ebai101/dotfiles.git ~/.dotfiles && ~/.dotfiles/install.sh && exec bash"
[ "$1" = "-nc" ] && RUN_CMD=bash 

docker run \
    -it -w /workspace \
    -e BBB_HOSTNAME=192.168.7.2 \
    -v /run/host-services/ssh-auth.sock:/run/host-services/ssh-auth.sock \
    -e SSH_AUTH_SOCK="/run/host-services/ssh-auth.sock" \
    --mount source=xc-bela-src,target=/workspace,type=volume \
    --mount source=xc-bela-bashhistory,target=/commandhistory,type=volume \
    --network host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    ebai101/xc-bela:latest \
    bash -c "$RUN_CMD"
