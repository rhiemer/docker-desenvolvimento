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

if [[ $1 = @(-h|--help) ]];then
  usage
  exit 0
fi

POSITIONAL=()
while [[ $# -gt 0 ]]
do
  key="$1"
  case $key in     
      -v|--verbose)
      set -x      
      shift # past argument                  
      ;;
      -*|--*)
       OPTIONS="$@"
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
PARAM_2="${2}"
PARAM_3="${3}"

VM="$PARAM_1"
NAME="$PARAM_2"
HOST="$PARAM_3"

P_OPTIONS=${OPTIONS:- --automount}

if [ ! -z "$VBOX_MSI_INSTALL_PATH" ]; then
  VBOXMANAGE="${VBOX_MSI_INSTALL_PATH}VBoxManage.exe"
else
  VBOXMANAGE="${VBOX_INSTALL_PATH}VBoxManage.exe"
fi

if [ ! -f "${VBOXMANAGE}" ]; then
  echo "VirtualBox is not installed. Please re-run the Toolbox Installer and try again."
  exit 1
fi

echo "Criando compartilhamento $NAME da pasta $HOST na maquina virtual $VM."
"${VBOXMANAGE}" sharedfolder add "$VM" --name "$NAME" --hostpath "$HOST" $P_OPTIONS