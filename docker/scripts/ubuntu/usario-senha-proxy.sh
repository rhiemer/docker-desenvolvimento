
FILE_CONF_PROXY=/etc/apt/proxy.conf

echo Acquire::http::Proxy "http://%USUARIO_PROXY%:%SENHA_USUARIO_PROXY%@%HOST_PROXY%;" > $FILE_CONF_PROXY