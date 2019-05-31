#!/bin/bash
set -o errexit

trap '[ "$?" -eq 0 ] || echo "Looks like something went wrong in step ´$STEP´"' EXIT

usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Nome da docker-machine. 
  Options:       
    -v,--verbose             Printa toda a execução do arquivo. 
    -h,--help                Print this help message.
EOF

}

#Quick Hack: used to convert e.g. "C:\Program Files\Docker Toolbox" to "/c/Program Files/Docker Toolbox"
win_to_unix_path(){ 
	wd="$(pwd)"
	cd "$1"
		the_path="$(pwd)"
	cd "$wd"
	echo $the_path
}

if [[ $1 = @(-h|--help) ]];then
  usage
  exit 0
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in     
     --vm)
      DOCKER_MACHINE_NAME="$2"
      shift # past argument
      shift # past value
      ;;
     --toolbox-install)
      DOCKER_TOOLBOX_INSTALL_PATH="$2"
      shift # past argument
      shift # past value
      ;;
      --docker-machine-install)
      DOCKER_MACHINE="$2"
      shift # past argument
      shift # past value
      ;;
      --vbox-install)
      VBOXMANAGE="$2"
      shift # past argument
      shift # past value
      ;;
      --driver)
      DOCKER_MACHINE_VIRTUALIZACAO="$2"
      shift # past argument
      shift # past value
      ;;
      --http-proxy)
      HTTP_PROXY=true
      shift # past argument
      ;;
      --https-proxy)
      HTTPS_PROXY=true
      shift # past argument
      ;;
      --no-proxy)
      NO_PROXY=true
      shift # past argument
      ;;
      -v|--verbose)
      set -x      
      shift # past argument                  
      ;;
      -*|--*)
       DOCKER_MACHINE_CREATE_OPTIONS="$@"
       break
      ;;
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

# restore positional parameters
set -- "${POSITIONAL[@]}"

PARAM_1="${1}"

VM="${DOCKER_MACHINE_NAME:-$PARAM_1}"
DOCKER_MACHINE="${DOCKER_TOOLBOX_INSTALL_PATH}\docker-machine.exe"
DOCKER_MACHINE_VIRTUALIZACAO=${DOCKER_MACHINE_VIRTUALIZACAO:-"virtualbox"}

#clear all_proxy if not socks address
if  [[ $ALL_PROXY != socks* ]]; then
  unset ALL_PROXY
fi
if  [[ $all_proxy != socks* ]]; then
  unset all_proxy
fi

if [ ! -f "${DOCKER_MACHINE}" ]; then
  echo "Docker Machine is not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

set -e

#set proxy variables inside virtual docker machine if they exist in host environment
if [ "${HTTP_PROXY}" ]; then
  PROXY_ENV="$PROXY_ENV --engine-env HTTP_PROXY=$HTTP_PROXY"
fi
if [ "${HTTPS_PROXY}" ]; then
  PROXY_ENV="$PROXY_ENV --engine-env HTTPS_PROXY=$HTTPS_PROXY"
fi
if [ "${NO_PROXY}" ]; then
  PROXY_ENV="$PROXY_ENV --engine-env NO_PROXY=$NO_PROXY"
fi

"${DOCKER_MACHINE}" create -d $DOCKER_MACHINE_VIRTUALIZACAO $DOCKER_MACHINE_CREATE_OPTIONS $PROXY_ENV "${VM}"

set +e