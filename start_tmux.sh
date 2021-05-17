#!/bin/bash
# Session Name
session="SandC"
# avoid changing the session if it already exists
SESSIONEXISTS=$(tmux list-sessions | grep $session)
if [ "$SESSIONEXISTS" = "" ]
then
# Start new detached session with given name
tmux new-session -d -s $session
# rename a window and split in two terminals
tmux rename-window -t $session terminal
# create a new window and change the name directly
tmux new-window -t $session -n "server"
# start a program in it
tmux send-keys -t $session 'jupyter notebook' C-m
# split the window vertically and start another program
tmux split-window -v -t $session
tmux send-keys -t $session 'htop' C-m
# select a specific pane (session:window.pane)
# needs to select the windows first
tmux select-window -t $session:terminal
tmux select-pane -t $session:terminal.2
# attach to the session
fi
# attach to the session
tmux attach-session -t $session
