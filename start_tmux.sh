#!/bin/bash
# Session Name
session="SandC"
# Start new detached session with given name
tmux new-session -d -s $session
# rename a window and split in two terminals
tmux rename-window -t $session terminal
tmux split-window -h -t $session
# create a new window and change the name
tmux new-window -t $session
tmux rename-window -t $session server
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
tmux attach -t $session
