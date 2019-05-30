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
     --arquivo)
      ARQUIVO="$2"
      shift # past argument
      shift # past value
      ;;
     --nome)
      SENHA="$2"
      shift # past argument
      shift # past value
      ;;
      --pasta-desktop)
      PASTA_DESKTOP="$2"
      shift # past argument
      shift # past value
      ;;
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

PASTA_DESKTOP_DEFAULT="/headless/Desktop"

PARAM_1="${1}"
PARAM_2="${2}"

ARQUIVO="${ARQUIVO:-$PARAM_1}"
NOME="${NOME:-$PARAM_2}"

PASTA_DESKTOP=${PASTA_DESKTOP:-$PASTA_DESKTOP_DEFAULT}
_BASENAME=`basename $NOME`
_NAME="${BASENAME%.*}"

P_NAME=${NOME:-$_NAME}

FILE_LN="$PASTA_DESKTOP/$P_NAME"

ln -sfv "$ARQUIVO" "$FILE_LN"