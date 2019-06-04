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

COPY $SCRIPTS_DOKER_HOST/remover-image-desktop-background.sh $SCRIPTS_DOKER/

RUN find $SCRIPTS_DOKER/remover-image-desktop-background.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./remover-image-desktop-background.sh

COPY $SCRIPTS_DOKER_HOST/desinstalar-chromium.sh $SCRIPTS_DOKER/

RUN find $SCRIPTS_DOKER/desinstalar-chromium.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./desinstalar-chromium.sh

COPY $SCRIPTS_DOKER_HOST/instalar-chrome.sh $SCRIPTS_DOKER/

RUN find $SCRIPTS_DOKER/instalar-chrome.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./instalar-chrome.sh  

COPY $SCRIPTS_DOKER_HOST/configurar-chrome.sh $SCRIPTS_DOKER/

RUN find $SCRIPTS_DOKER/configurar-chrome.sh -type f  \      
      -exec sh -c 'tr -d "\r" < "{}" > "{}".new && mv "{}".new "{}"' -- {} \; \    
      -exec chmod +x {} \; \    
    && cd $SCRIPTS_DOKER \
    && ./configurar-chrome.sh    

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



