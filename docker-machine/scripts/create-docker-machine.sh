#!/bin/bash
set -o errexit

trap '[ "$?" -eq 0 ] || echo "Looks like something went wrong in step ´$STEP´"' EXIT

usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Nome da docker-machine. ['default']
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
      --pasta-machines)
       PASTA_MACHINES="$2"
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

DOCKER_MACHINE_NAME="${DOCKER_MACHINE_NAME:-$PARAM_1}"

# This is needed  to ensure that binaries provided
# by Docker Toolbox over-ride binaries provided by
# Docker for Windows when launching using the Quickstart.
export PATH="$(win_to_unix_path "${DOCKER_TOOLBOX_INSTALL_PATH}"):$PATH"

VM=${DOCKER_MACHINE_NAME-default}
DOCKER_MACHINE="${DOCKER_TOOLBOX_INSTALL_PATH}\docker-machine.exe"
PASTA_MACHINES=${PASTA_MACHINES:-"~/.docker/machine/machines"}
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

if [ $DOCKER_MACHINE_VIRTUALIZACAO -eq "virtualbox" ]; then
  STEP="Looking for vboxmanage.exe"
  
  if [ ! -z "$VBOX_MSI_INSTALL_PATH" ]; then
    VBOXMANAGE="${VBOX_MSI_INSTALL_PATH}VBoxManage.exe"
  else
    VBOXMANAGE="${VBOX_INSTALL_PATH}VBoxManage.exe"
  fi
  
  if [ ! -f "${VBOXMANAGE}" ]; then
    echo "VirtualBox is not installed. Please re-run the Toolbox Installer and try again."
    exit 1
  fi

  "${VBOXMANAGE}" list vms | grep \""${VM}"\" &> /dev/null
  VM_EXISTS_CODE=$?  
else
  VM_EXISTS_CODE=1  
fi

set -e

STEP="Checking if machine $VM exists"
if [ $VM_EXISTS_CODE -eq 1 ]; then
  "${DOCKER_MACHINE}" rm -f "${VM}" &> /dev/null || :
  rm -rf ~/.docker/machine/machines/"${VM}"
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
fi

STEP="Checking status on $VM"
VM_STATUS="$( set +e ; "${DOCKER_MACHINE}" status "${VM}" )"
if [ "${VM_STATUS}" != "Running" ]; then
  "${DOCKER_MACHINE}" start "${VM}"
  yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
fi

STEP="Setting env"
eval "$("${DOCKER_MACHINE}" env --shell=bash --no-proxy "${VM}" | sed -e "s/export/SETX/g" | sed -e "s/=/ /g")" &> /dev/null #for persistent Environment Variables, available in next sessions
eval "$("${DOCKER_MACHINE}" env --shell=bash --no-proxy "${VM}")" #for transient Environment Variables, available in current session

echo "Docker Machine $VM criada com sucesso."