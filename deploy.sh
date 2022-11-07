#!/bin/bash

host_string=("'pzl97@apt137.apt.emulab.net'" "'pzl97@apt156.apt.emulab.net'" "'pzl97@apt153.apt.emulab.net'" "'pzl97@apt145.apt.emulab.net'")
name="deploy-cosmos"
if [ "$1" == "init" ]; then 
  tmux new-session -s $name -d
fi 

for i in $( seq 0 ${#host_string[@]} )

do
  tmux_name="$name:$i"
  #tmux neww -a -n "$client" -t $name
  if [ "$1" == "init" ]; then 
  tmux new-window -n "$i" -t "$name" -d
  tmux send -t $tmux_name "ssh ${host_string[i]}" Enter
  tmux send -t $tmux_name "git clone https://github.com/litrane/cosmos_experiment_file.git" Enter
  tmux send -t $tmux_name "cd cosmos_experiment_file" Enter
  tmux send -t $tmux_name "nohup ./earthd start --home=./workspace/earth/validator${i} > output 2>&1 & " Enter
elif [ "$1" == "update" ]; then
  #tmux send -t $tmux_name "cd theta_experiment_file" Enter
  tmux send -t $tmux_name "git clean -xfd" Enter
  tmux send -t $tmux_name "git pull" Enter
elif [ "$1" == "clean" ]; then
  tmux send -t $tmux_name "cd ~" Enter
  tmux send -t $tmux_name "rm -rf cosmos_experiment_file" Enter
fi
  val=`expr $i + 1`
  echo "start node${val}!"
  

done

