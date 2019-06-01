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

#TO-DO: instalar java 7 e 8 da oracle. 
#Instalando o openjdk para o java7 e java8 pois a versão da oracle não está mais disponível para downloads.
#http://www.webupd8.org/2012/01/install-oracle-java-jdk-7-in-ubuntu-via.html
#https://launchpad.net/~webupd8team/+archive/ubuntu/java
add-apt-repository ppa:openjdk-r/ppa
apt-get update   
apt-get install -y openjdk-7-jdk
apt-get install -y openjdk-8-jdk