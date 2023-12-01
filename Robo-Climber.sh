#!/bin/sh
echo -ne '\033c\033]0;Game Off 2023 - Scale\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/Robo-Climber.x86_64" "$@"
