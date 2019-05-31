
#!/bin/bash
set -o errexit

usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Usuário do proxy
    (2) Senha do proxy
  Options:       
    --usuario                Usuário do proxy.
    --senha                  Senha do proxy.
    --protocolo              Protocolo da url do proxy. default: http
    --protocolo-proxy        Protocolo do proxy. default:--protocolo
    --host                   Host do proxy. default: proxy.sefaz.sefnet:3128
    --pasta-conf-proxy       Pasta do arquivo de configuração do proxy. default: /etc/apt
    --file-name-conf-proxy   Nome do arquivo de configuração do proxy. default: proxy_http.proxy
    --file-proxy             Caminho completo do arquivo de configuração do proxy.
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
     --usuario)
      USUARIO="$2"
      shift # past argument
      shift # past value
      ;;
     --senha)
      SENHA="$2"
      shift # past argument
      shift # past value
      ;;
      --protocolo)
      PROTOCOLO="$2"
      shift # past argument
      shift # past value
      ;;
      --protocolo-proxy)
      PROTOCOLO_PROXY="$2"
      shift # past argument
      shift # past value
      ;;
      --host)
      HOST="$2"
      shift # past argument
      shift # past value
      ;;
      --pasta-conf-proxy)
      PASTA_CONF_PROXY="$2"
      shift # past argument
      shift # past value
      ;;
      --file-name-conf-proxy)
      FILE_NAME_CONF_PROXY="$2"
      shift # past argument
      shift # past value
      ;;
      --file-conf-proxy)
      FILE_CONF_PROXY="$2"
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

PARAM_1="${1}"
PARAM_2="${2}"

PROTOCOLO_DEFAULT="http"
HOST_DEFAULT="proxy.sefaz.sefnet:3128"
FILE_NAME_CONF_PROXY_DEFAULT="proxy_http.conf"
PASTA_CONF_PROXY_DEFAULT="/etc/apt"

HOST="${HOST:-$HOST_DEFAULT}"
USUARIO="${USUARIO:-$PARAM_1}"
SENHA="${SENHA:-$PARAM_2}"

PROTOCOLO="${PROTOCOLO:-$PROTOCOLO_DEFAULT}"
PASTA_CONF_PROXY="${PASTA_CONF_PROXY:-$PASTA_CONF_PROXY_DEFAULT}"
FILE_NAME_CONF_PROXY="${FILE_NAME_CONF_PROXY:-$FILE_NAME_CONF_PROXY_DEFAULT}"
FILE_CONF_PROXY="${FILE_CONF_PROXY:-$PASTA_CONF_PROXY/$FILE_NAME_CONF_PROXY}"

PROTOCOLO_PROXY="${PROTOCOLO_PROXY:-$PROTOCOLO}"

URL="${PROTOCOLO:+$PROTOCOLO://}"
URL="${USUARIO:+$URL$USUARIO}"
URL="${SENHA:+$URL:$SENHA}"
([ ! -z "${USUARIO// }" ] || [ ! -z "${SENHA// }" ]) && URL="$URL@" 
URL="${HOST:+$URL$HOST}"

echo "Acquire::$PROTOCOLO_PROXY::Proxy \"$URL;\" > $FILE_CONF_PROXY