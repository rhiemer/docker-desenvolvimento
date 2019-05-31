
usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Nome da maquina virtual.
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
      *)    # unknown option
      POSITIONAL+=("$1") # save it in an array for later
      shift # past argument
      ;;
  esac
done

# restore positional parameters
set -- "${POSITIONAL[@]}"

PARAM_1="${1}"

VM="$PARAM_1"
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

if [ $VM_EXISTS_CODE -eq 0 ]; then
  return 0
else
  echo "${VM} não existe."
  return 1
fi
