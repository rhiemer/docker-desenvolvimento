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

add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java7-installer
apt-get install oracle-java8-installer