#!/bin/bash
set -o errexit


win_to_unix_path(){ 
	wd="$(pwd)"
	cd "$1"
		the_path="$(pwd)"
	cd "$wd"
	echo $the_path
}

PARAM_1="${1}"

PATH_IMAGENS_DEFAULT="c:\\Users\\e-rhiemer\\desenvolvimento\\container\\images"
PATH_IMAGENS="${PARAM_1:-$PATH_IMAGENS_DEFAULT}"
P_PATH_IMAGENS="$(win_to_unix_path "$PATH_IMAGENS")"

./load-docker-images.sh "$P_PATH_IMAGENS" $@
