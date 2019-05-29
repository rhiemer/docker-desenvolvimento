@echo off
setlocal

echo.

rem "Informar o caminho com a pasta dos fontes dos projetos."
:ComeBackHostPathProjetos
call :informarPasta "Informe a pasta com os fontes dos projetos. [obrigatorio]:" HOST_PATH_PROJETOS
if "x%HOST_PATH_PROJETOS%" == "x" (
    echo Valor obrigatório.
    goto :ComeBackHostPathProjetos
)

rem echo.
rem rem "Perguntar se deseja criar um jboss no container."
rem set /P CRIAR_JBOSS=Deseja criar um novo jboss no container. (S/N):
rem if /I not "%CRIAR_JBOSS%" == "S" (
rem     rem "Informar o caminho com a pasta local do jboss."
rem     call :informarPasta "Informe a pasta local do jboss:" PATH_VOLUME_JBOSS
rem     if "x%PATH_VOLUME_JBOSS%" == "x" (
        rem echo Sera instalado um novo jboss na maquina.
rem     )
rem )

echo.
rem "Perguntar se deseja utilizar o usuario do sistema operacional para o proxy do container."
set USUARIO_PROXY=%USERNAME%
set /P CHANGE_USUARIO_PROXY=Deseja utilizar o usuario %USUARIO_PROXY% como usuario do proxy do container (S/N):
if /I not "%CHANGE_USUARIO_PROXY%" == "S" (
    rem "Informar o usuario do proxy."
    set /P USUARIO_PROXY=Informe o login do usuario do proxy.: 
    if "x%USUARIO_PROXY%" == "x" (
        echo Sera utilizado o usuario %USUARIO_PROXY% no proxy.
    )
)

echo.
:ComeBackSenhaUsuarioHide
rem "Informar a senha do usuario do proxy do container."
call :passwordHide "Informe a senha do usuario %USUARIO_PROXY%. [obrigatorio]" SENHA_USUARIO_PROXY
if "x%SENHA_USUARIO_PROXY%" == "x" (
    echo Valor obrigatório.
    goto :ComeBackSenhaUsuarioHide
)

echo.
echo.

set ID_RUN=%RANDOM%
set PATH_DOCKER_TOOLS=C:\Program Files\Docker Toolbox
set PATH_VIRTUALBOX=C:\Program Files\Oracle\VirtualBox
set PATH_OLD=%path%
set VM_NAME=default
set IMAGE=sefaz/eclipseap6:v6

set PATH_PROJETOS_VOLUME=/root/projetos
set FILE_CONF_PROXY=/etc/apt/proxy.conf
set TIME_ZONE=America/Sao_Paulo
set LOCALE_DOCKER=pt_BR.UTF-8

set HOST_PROXY=proxy.sefaz.sefnet:3128
set PORTAS=-p 5901:5901 -p 6901:6901 -p 8080:8080
set PATH_JBOSS_HOME=/opt/jboss-eap-6.4

set path=%PATH_OLD%;%PATH_DOCKER_TOOLS%;%PATH_VIRTUALBOX%


echo Parando docker machine para executar alterações para execução do container.
docker-machine stop %VM_NAME%
if %errorlevel% GTR 1 (
   echo.
   echo ERROR: Erro ao parar a VM do DockerTools. %errorlevel%
   GOTO :EOF
)


echo.
rem "Coloca um número randômico para evitar erro de duplicidade de nomes ao criar um compartilhamento."
set SHARED_FOLDER_PROJETOS=projetos%ID_RUN%
echo Criando compartilhamento %SHARED_FOLDER_PROJETOS% da pasta %HOST_PATH_PROJETOS% na maquina virtual do DockerTools.
vboxmanage sharedfolder add %VM_NAME% --name "%SHARED_FOLDER_PROJETOS%"  --hostpath "%HOST_PATH_PROJETOS%" --automount
if not %errorlevel% == 0 (  
    echo.
    echo ERROR: Erro ao criar compartilhamento da pasta de projetos na maquina virtual do DockerTools. %errorlevel%
    GOTO :EOF
)


if not "x%PATH_VOLUME_JBOSS%" == "x" (    
    set SHARED_FOLDER_JBOSS=jboss%ID_RUN%    
    echo.
    echo Criando compartilhamento %SHARED_FOLDER_JBOSS% da pasta %PATH_VOLUME_JBOSS% na maquina virtual do DockerTools.
    vboxmanage sharedfolder add %VM_NAME% --name "%SHARED_FOLDER_JBOSS%"  --hostpath "%PATH_VOLUME_JBOSS%" --automount
    if not %errorlevel% == 0 (  
        echo.
        echo ERROR: Erro ao criar compartilhamento da pasta do jboss na maquina virtual do DockerTools. %errorlevel%
        GOTO :EOF
    )
    set CRIAR_VOLUME_JBOSS="S"
) 

echo.
echo Habilitando sincronismo da data da maquina com a VM do DockerTools.
vboxmanage setextradata %VM_NAME% VBoxInternal/Devices/VMMDev/0/Config/GetHostTimeDisabled 0
if not %errorlevel% == 0 (  
    echo.
    echo ERROR: Erro ao habilitar o sincronismo da data da maquina com a VM do DockerTools. %errorlevel%
    GOTO :EOF
)

echo.
echo Iniciando docker-machine apos as alteracoes.
echo.
docker-machine start %VM_NAME% 

for /f %%i in ('docker-machine status %VM_NAME%') do set VM_STATUS=%%i
if not %VM_STATUS% equ Running (
    echo.
    echo ERROR: maquina virtual do DockerTools não está sendo executada. %VM_STATUS%
    GOTO :EOF
)

echo.
echo.
echo Informações da maquina virtual %VM_NAME%.
echo.
docker-machine ls %VM_NAME%

rem Parametros para o comando docker run.
set VOLUMES=-v /%SHARED_FOLDER_PROJETOS%:%PATH_PROJETOS_VOLUME%
if "%CRIAR_VOLUME_JBOSS%" == "S" (
   set VOLUMES=%VOLUMES% -v /%SHARED_FOLDER_JBOSS%:%PATH_JBOSS_HOME%
)
set VARIAVEIS_CONTAINER=-e LANG=%LOCALE_DOCKER% -e LC_ALL=%LOCALE_DOCKER%

rem Nome do container.
set CONTAINER_NAME=desenvolvimento-%ID_RUN%

echo.
echo.
echo Criando o container de nome %CONTAINER_NAME% .
echo.

echo Volumes %VOLUMES%
docker run -d --rm %VOLUMES% %PORTAS% %VARIAVEIS_CONTAINER% --name %CONTAINER_NAME% -i "%IMAGE%"
if not %errorlevel% == 0 (  
    echo.
    echo ERROR: Ocorreu um erro ao criar o container. %errorlevel%
    GOTO :EOF
)

echo.
echo Configurando Locale %LOCALE_DOCKER%.
docker exec -it %CONTAINER_NAME% locale-gen %LOCALE_DOCKER%
docker exec -it %CONTAINER_NAME% dpkg-reconfigure locales
docker exec -it %CONTAINER_NAME% update-locale LANG=%LOCALE_DOCKER%
docker exec -it %CONTAINER_NAME% cat /etc/default/locale

echo.
echo Configurando TimeZone %TIME_ZONE%.
docker exec -it %CONTAINER_NAME% cp -rfv /etc/localtime /etc/localtime.bkp
docker exec -it %CONTAINER_NAME% ln -sfv /usr/share/zoneinfo/%TIME_ZONE% /etc/localtime

echo.
echo Configuracoes de Proxy para o usuario %USUARIO_PROXY% no arquivo %FILE_CONF_PROXY%.
rem Remover o arquivo com configurações de proxy que foi criado na imagem para não ocorrer conflito.
docker exec -it %CONTAINER_NAME% rm -rfv /etc/apt/apt.cof || true

rem Não é possível direcionar o stdout de um echo para um arquivo texto no container, então o mesmo teve que ser criado na maquina, como temporário, e após copiado.
set FILE_TMP_PROXY=%temp%\proxy.conf.%RANDOM%
echo Acquire::http::Proxy "http://%USUARIO_PROXY%:%SENHA_USUARIO_PROXY%@%HOST_PROXY%;"> %FILE_TMP_PROXY%
docker cp %FILE_TMP_PROXY% %CONTAINER_NAME%:%FILE_CONF_PROXY%
del %FILE_TMP_PROXY%

echo.
echo Criando um atalho para o eclipse na area de trabalho.
docker exec -it %CONTAINER_NAME% ln -sv /headless/.local/share/umake/ide/eclipse-jee/./eclipse /headless/Desktop/eclipse

echo Excluindo arquivos que não são configurações de workspace e se encontram em /root/eclipse-workspace.
docker exec -it -w /root/eclipse-workspace %CONTAINER_NAME% find . -maxdepth 2  -not -path *.metadata* -not -path . -exec rm -rf {} ;

echo.
echo.
echo Container %CONTAINER_NAME% criado e configurado com sucesso.
GOTO :EOF


:passwordHide
set titulo=%~1
set "psCommand=powershell -Command "$pword = read-host '%titulo%' -AsSecureString ; ^
    $BSTR=[System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($pword); ^
        [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)""
for /f "usebackq delims=" %%p in (`%psCommand%`) do set password=%%p
set %~2=%password%
exit /b 0


:informarPasta
set pasta=""
set /P pasta=%~1
if not "x%pasta%" == "x"   (
    if not exist "%pasta%\*" (
        echo Valor informado %pasta% não é um caminho de diretorio valido. 
        goto :informarPasta    
    ) 
)
set %~2=%pasta%
exit /b 0