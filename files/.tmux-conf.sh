function taiga-runserver {
    session=taiga
    state=$(tmux ls 2>/dev/null)
    if $(echo $state | grep -q "$session"); then
        if $(echo $state | grep -qv "(attached)"); then
            tmux attach -t $session
        fi
        tmux select-window -t servers
    else
        tmux new-session -ds $session -n servers
        tmux send-keys -t $session 'taiga-runserver-front' C-m
        tmux split-window -t $session
        tmux send-keys -t $session 'taiga-runserver-back' C-m
        tmux attach -t $session
    fi
}

function taiga-runserver-front {
    workon taiga
    cd ~/taiga-front
    gulp
}

function taiga-runserver-back {
    circusctl stop taiga
    workon taiga
    cd ~/taiga-back
    python manage.py runserver 0.0.0.0:8001
}
