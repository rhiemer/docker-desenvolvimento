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

TIME_ZONE_DEFAULT="America/Sao_Paulo"
TIME_ZONE="${PARAM_1:-$TIME_ZONE_DEFAULT}"
ARQUIVO_LOCALTIME="/etc/localtime"
PASTA_ZONEINFO="/usr/share/zoneinfo"
ARQUIVO_ZONEINFO="$PASTA_ZONEINFO/$TIME_ZONE"

cp -rfv "$ARQUIVO_LOCALTIME" "$ARQUIVO_LOCALTIME.bkp"
ln -sfv "$ARQUIVO_ZONEINFO" "$ARQUIVO_LOCALTIME"