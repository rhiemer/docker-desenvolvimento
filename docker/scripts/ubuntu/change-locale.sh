#!/bin/bash



locale-gen $LOCALE
dpkg-reconfigure locales
update-locale LANG=$LOCALE
