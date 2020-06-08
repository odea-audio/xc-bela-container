#!/usr/bin/env bash

DOCKCMD="docker run \
    -it --rm -w /workspace \
    -e BBB_HOSTNAME=192.168.7.2 \
    -e SSH_AUTH_SOCK=$SSH_AUTH_SOCK \
    -v $(dirname $SSH_AUTH_SOCK):$(dirname $SSH_AUTH_SOCK) \
    --mount source=xc-bela-src,target=/workspace,type=volume \
    --mount source=xc-bela-bashhistory,target=/commandhistory,type=volume \
    --network host --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    --entrypoint \"/bin/bash\" ebai101/xc-bela:latest"

SESSIONNAME="vimdev"
tmux has-session -t $SESSIONNAME &> /dev/null

if [ $? != 0 ]
then
    tmux new-session -s $SESSIONNAME -d
    #tmux send-keys "htop" Enter
    #tmux split-pane -v
    #tmux send-keys "bmon -p en0" Enter
    #tmux new-window
    tmux send-keys -t $SESSIONNAME "$DOCKCMD" Enter
    tmux split-pane -h
    tmux send-keys -t $SESSIONNAME "tmux resize-pane -x 74" Enter
    tmux send-keys -t $SESSIONNAME "$DOCKCMD" Enter  
    tmux split-pane -v
fi

tmux attach -t $SESSIONNAME
