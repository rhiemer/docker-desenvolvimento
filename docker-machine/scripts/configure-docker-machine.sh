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
VM="${PARAM_1}"
DOCKER_MACHINE="${DOCKER_TOOLBOX_INSTALL_PATH}\docker-machine.exe"

yes | "${DOCKER_MACHINE}" regenerate-certs "${VM}"
eval "$("${DOCKER_MACHINE}" env --shell=bash --no-proxy "${VM}" | sed -e "s/export/SETX/g" | sed -e "s/=/ /g")" &> /dev/null #for persistent Environment Variables, available in next sessions
eval "$("${DOCKER_MACHINE}" env --shell=bash --no-proxy "${VM}")" #for transient Environment Variables, available in current session

