#!/bin/sh
echo -ne '\033c\033]0;first pony shooter\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/first pony shooter.x86_64" "$@"
