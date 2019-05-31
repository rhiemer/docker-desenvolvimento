@echo off

set GIT_BASH="C:\Program Files\Git\bin\bash.exe"
set GIT_BASH_CMD=%GIT_BASH% --login -i -c

%GIT_BASH_CMD%  "./load-docker-images-bat.sh"

