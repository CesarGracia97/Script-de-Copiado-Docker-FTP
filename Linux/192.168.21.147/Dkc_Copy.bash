#!/bin/bash

# Definir Variables de Servidor
HOST_DIR="/u01/dpsbs/data/DebitosSFTP/search"

# Definir Variables de Servidor->FTP
FTP_USER="Debbancario"
FTP_PASSWORD="Xtr3m#2023"
FTP_HOST="140.27.120.102"

# Directorios locales de origen
DIR_ORIGEN1="/u01/dpsbs/data/DebitosSFTP/search"
DIR_ORIGEN2="/u01/dpsbs/data/DebitosSFTP/search/0"
DIR_ORIGEN3="/u01/dpsbs/data/DebitosSFTP/search/13"
DIR_ORIGEN4="/u01/dpsbs/data/DebitosSFTP/search/435"
DIR_ORIGEN5="/u01/dpsbs/data/DebitosSFTP/search/434"
DIR_ORIGEN6="/u01/dpsbs/data/DebitosSFTP/search/427"
DIR_ORIGEN7="/u01/dpsbs/data/DebitosSFTP/search/443"
DIR_ORIGEN8="/u01/dpsbs/data/DebitosSFTP/search/440"

# Directorios remotos de destino
DIR_HOST_R1="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/ARCHIVOS_TYTAN"
DIR_HOST_R2="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/0"
DIR_HOST_R3="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/13"
DIR_HOST_R4="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/435"
DIR_HOST_R5="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/434"
DIR_HOST_R6="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/427"
DIR_HOST_R7="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/443"
DIR_HOST_R8="/DebitosBancarios/PRODUCCION/ARCHIVOS_RECIBIDOS_TYTAN/440"

# ParteFTP
# Iniciar sesión FTP y verificar la conexión
ftp -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASSWORD
prompt
ls
bye
END_SCRIPT

# Verificar el estado de la conexión
if [ $? -eq 0 ]; then
  echo "Conexión exitosa a NAS."
else
  echo "Fallo la conexión a NAS."
  exit 1
fi

# Realizar transferencia de archivos usando mput
ftp -n $FTP_HOST <<END_SCRIPT
quote USER $FTP_USER
quote PASS $FTP_PASSWORD
prompt
cd $DIR_HOST_R1
lcd $DIR_ORIGEN1
mput *
cd $DIR_HOST_R2
lcd $DIR_ORIGEN2
mput *
cd $DIR_HOST_R3
lcd $DIR_ORIGEN3
mput *
cd $DIR_HOST_R4
lcd $DIR_ORIGEN4
mput *
cd $DIR_HOST_R5
lcd $DIR_ORIGEN5
mput *
cd $DIR_HOST_R6
lcd $DIR_ORIGEN6
mput *
cd $DIR_HOST_R7
lcd $DIR_ORIGEN7
mput *
cd $DIR_HOST_R8
lcd $DIR_ORIGEN8
mput *
bye
END_SCRIPT

# Verificar el estado de la transferencia
if [ $? -eq 0 ]; then
  echo "Transferencia de archivos exitosa."
else
  echo "Fallo la transferencia de archivos."
  exit 1
fi

# Preguntar al usuario si desea eliminar archivos locales
read -p "¿Deseas eliminar los archivos locales de las carpetas de bankdebits? (Y/N): " opcion

# Eliminar archivos locales si la respuesta es 'Y'
if [ "$opcion" == "Y" ] || [ "$opcion" == "y" ]; then
  rm -f $DIR_ORIGEN1/*
  rm -f $DIR_ORIGEN2/*
  rm -f $DIR_ORIGEN3/*
  rm -f $DIR_ORIGEN4/*
  rm -f $DIR_ORIGEN5/*
  rm -f $DIR_ORIGEN6/*
  rm -f $DIR_ORIGEN7/*
  rm -f $DIR_ORIGEN8/*
  echo "Archivos locales eliminados."
else
  echo "No se han eliminado archivos locales."
fi