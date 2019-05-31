#!/bin/bash
set -o errexit

usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Código do TimeZone a ser configurado. default:America/Sao_Paulo
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

JAVANAME_DEFAULT="1.8"
JAVANAME="$PARAM_1"

JAVA_NAME_SET=$( update-java-alternatives -l | grep $JAVANAME | cut -d ' '  -f 1 )
if [ ! -z "${JAVA_NAME_SET// }" ]; then 
  update-java-alternatives -s "$JAVA_NAME_SET"
else
  echo "Não encontrado nenhuma java alternativa para $JAVANAME" 1>&2
  exit 1
fi



