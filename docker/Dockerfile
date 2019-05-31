ARG IMAGEM_BASE="sefaz/eclipseap6:v6"

FROM $IMAGEM_BASE

USER root

ARG SCRIPTS_SO="ubuntu"
ARG SCRIPTS_DOKER_HOST="scripts"
ARG SCRIPTS_DOKER="/etc/scripts/docker" 

ENV SCRIPTS_SO="$SCRIPTS_SO" \
    SCRIPTS_DOKER_HOST="$SCRIPTS_DOKER_HOST" \
    SCRIPTS_DOKER="$SCRIPTS_DOKER" 
    SCRIPTS_DOKER_HOST_SO="$SCRIPTS_DOKER_HOST/$SCRIPTS_SO"

RUN mkdir -pv $SCRIPTS_DOKER

COPY $SCRIPTS_DOKER_HOST_SO/change-locale.sh $SCRIPTS_DOKER/

ARG LOCALE="pt_BR" 
ARG ENCODE="UTF-8"
ARG LANGUAGE="pt_BR:pt"    

ENV LOCALE_CHANGE="$LOCALE.$ENCODE"

RUN find $SCRIPTS_DOKER/change-locale.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./change-locale.sh "$LOCALE_CHANGE"

ENV LANG="$LOCALE_CHANGE" \
    LC_ALL="$LOCALE_CHANGE" \
    LANGUAGE="$LANGUAGE"

COPY $SCRIPTS_DOKER_HOST_SO/change-timezone.sh $SCRIPTS_DOKER/

ARG TIMEZONE="America/Sao_Paulo" 
ENV TIMEZONE="$TIMEZONE"

RUN find $SCRIPTS_DOKER/change-timezone.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./change-timezone.sh "$TIMEZONE"

COPY $SCRIPTS_DOKER_HOST_SO/configurar-proxy.sh $SCRIPTS_DOKER/

ARG USUARIO_PROXY
ARG SENHA_PROXY
ARG HOST_PROXY="proxy.sefaz.sefnet:3128"
ARG PROTOCOLO_PROXY="http"

ENV USUARIO_PROXY="$USUARIO_PROXY" \
    SENHA_PROXY="$SENHA_PROXY" \
    HOST_PROXY="$HOST_PROXY" \
    PROTOCOLO_PROXY="$PROTOCOLO_PROXY" \
    FILE_NAME_CONF_PROXY="proxy_$PROTOCOLO_PROXY.conf"

RUN find $SCRIPTS_DOKER_HOST_SO/configurar-proxy.sh -type f  \ 
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \ 
    && ./configurar-proxy.sh \ 
        --usuario "$USUARIO" \ 
        --senha "$SENHA_PROXY" \ 
        --host "$HOST_PROXY" \ 
        --protocolo "$PROTOCOLO_PROXY" \ 
        --file-name-conf-proxy "$FILE_NAME_CONF_PROXY" 
          


