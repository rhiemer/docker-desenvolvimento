
usage(){
  cat <<EOF
usage: ${0##*/} [options]
  Parêmtros Posicionais
    (1) Pasta da workspace. default:pt_BR.UTF-8
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
WORK_SPACE_DEFAULT="/root/eclipse-workspace"
WORK_SPACE=${PARAM_1:-$WORK_SPACE_DEFAULT}

cd $WORK_SPACE
find . -maxdepth 2  -not -path *.metadata* -not -path . -exec rm -rf {} ;

