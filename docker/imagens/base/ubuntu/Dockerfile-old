ARG IMAGEM_BASE="consol/ubuntu-xfce-vnc"

FROM $IMAGEM_BASE

USER root

RUN apt-get update ; \
    apt-get -y install \ 
        subversion \
        software-properties-common

ARG SCRIPTS_DOKER_HOST="scripts"
ARG SCRIPTS_DOKER="/etc/scripts/docker" 

ENV SCRIPTS_DOKER_HOST="$SCRIPTS_DOKER_HOST" \
    SCRIPTS_DOKER="$SCRIPTS_DOKER"

RUN mkdir -pv $SCRIPTS_DOKER

COPY $SCRIPTS_DOKER_HOST/change-locale.sh $SCRIPTS_DOKER/

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

COPY $SCRIPTS_DOKER_HOST/change-timezone.sh $SCRIPTS_DOKER/

ARG TIMEZONE="America/Sao_Paulo" 
ENV TIMEZONE="$TIMEZONE"

RUN find $SCRIPTS_DOKER/change-timezone.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./change-timezone.sh "$TIMEZONE"

COPY $SCRIPTS_DOKER_HOST/configurar-proxy.sh $SCRIPTS_DOKER/

ARG USUARIO_PROXY="e-rhiemer"
ARG SENHA_PROXY="numsey@1"
ARG HOST_PROXY="proxy.sefaz.sefnet:3128"
ARG PROTOCOLO_PROXY="http"

ENV USUARIO_PROXY="$USUARIO_PROXY" \
    SENHA_PROXY="$SENHA_PROXY" \
    HOST_PROXY="$HOST_PROXY" \
    PROTOCOLO_PROXY="$PROTOCOLO_PROXY" \
    FILE_NAME_CONF_PROXY="proxy_$PROTOCOLO_PROXY.conf"

RUN find $SCRIPTS_DOKER/configurar-proxy.sh -type f  \ 
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \ 
    && ./configurar-proxy.sh \ 
        --usuario "$USUARIO" \ 
        --senha "$SENHA_PROXY" \ 
        --host "$HOST_PROXY" \ 
        --protocolo "$PROTOCOLO_PROXY" \ 
        --file-name-conf-proxy "$FILE_NAME_CONF_PROXY" 

COPY $SCRIPTS_DOKER_HOST/install-java.sh $SCRIPTS_DOKER/

RUN find $SCRIPTS_DOKER/install-java.sh -type f  \ 
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \ 
    && ./install-java.sh


COPY $SCRIPTS_DOKER_HOST/set-version-java.sh $SCRIPTS_DOKER/

ARG JAVA_VERSION="1.8"
ENV JAVA_VERSION="$JAVA_VERSION"

RUN find $SCRIPTS_DOKER/set-version-java.sh -type f  \ 
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \ 
    && ./set-version-java.sh "$JAVA_VERSION"        

COPY $SCRIPTS_DOKER_HOST/install-maven.sh $SCRIPTS_DOKER/

RUN find $SCRIPTS_DOKER/install-maven.sh -type f  \ 
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \ 
    && ./install-maven.sh