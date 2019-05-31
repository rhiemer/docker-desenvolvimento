#!/bin/bash
set -o errexit

usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Código do Locale a ser configurado. default:pt_BR.UTF-8
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

LOCALE_DEFAULT="pt_BR.UTF-8"
LOCALE="${PARAM_1:-$LOCALE_DEFAULT}"

locale-gen $LOCALE
dpkg-reconfigure locales
update-locale LANG=$LOCALE