#!/bin/sh -e
help_screen="SCRIPT_DESCRIPTION

Usage: {script} [options] PATH SECONDS

Arguments:
    PATH       - Path to the file or directory with files.
    SECONDS    - Time to watch over the directory.

Options:
    -h, --help   Show this screen and exit.
"


if [ $# != 2 ]; then
	script_name=$(basename $0)
	printf "%s" "$help_screen" | sed "s/{script}/$script_name/g"
	( [ "$1" = "-h" ] || [ "$1" = "--help" ] ) && exit 0 || exit 1
fi

path=$1
seconds=$2

for file in "$1" "$1"/*; do
	watch-file-updates "$path" &
	pid=$!
	sleep "$seconds" && kill $pid &
done
wait
