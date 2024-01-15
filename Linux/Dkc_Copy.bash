#!/bin/bash

# Definir Variables de Contenedor->Servidor
CONTAINER_NAME_OR_ID=$(sudo docker ps | grep build | awk '{print $1}')
CONTAINER_DIR="/usr/src/app/entity/bankdebits"
HOST_DIR="/home/root_wso/RespaldoEnviados"

# Definir Variables de Servidor->FTP
FTP_USER="Debbancario"
FTP_PASSWORD="Xtr3m#2023"
FTP_HOST="140.27.120.102"

# Directorios locales de origen
DIR_ORIGEN1="/home/root_wso/RespaldoEnviados/bankdebits/sci"
DIR_ORIGEN2="/home/root_wso/RespaldoEnviados/bankdebits/bancobolivariano"
DIR_ORIGEN3="/home/root_wso/RespaldoEnviados/bankdebits/bancopacifico"
DIR_ORIGEN4="/home/root_wso/RespaldoEnviados/bankdebits/bancoguayaquil"
DIR_ORIGEN5="/home/root_wso/RespaldoEnviados/bankdebits/bancoprodubanco"
DIR_ORIGEN6="/home/root_wso/RespaldoEnviados/bankdebits/bancopichincha"
DIR_ORIGEN7="/home/root_wso/RespaldoEnviados/bankdebits/bancointernacional"

# Directorios remotos de destino
DIR_HOST_R1="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/sci"
DIR_HOST_R2="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/bancobolivariano"
DIR_HOST_R3="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/bancopacifico"
DIR_HOST_R4="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/bancoguayaquil"
DIR_HOST_R5="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/bancoprodubanco"
DIR_HOST_R6="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/bancopichincha"
DIR_HOST_R7="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN/bankdebits/bancointernacional"

# Parte Docker_Copy
sudo docker ps | grep build

# Ejecutar el comando y capturar la salida
if sudo docker ps | grep build; then
    echo "El comando 'sudo docker ps | grep build' se ejecutó con éxito."
else
    echo "El comando 'sudo docker ps | grep build' falló en ejecutarse."
    exit 1
fi


if [ -z $CONTAINER_NAME_OR_ID ]; then
    echo "No se encontró ningún contenedor con 'build' en su nombre o ID."
    exit 1
fi

# Verificar si la ruta HOST_DIR existe, si no existe, crearla
if [ ! -d $HOST_DIR ]; then
    echo "El Script detectó que la ruta de destino no existe, por lo tanto procederá a crearse."
    mkdir -p $HOST_DIR
fi

# Verificar si la ruta CONTAINER_DIR en el contenedor existe
if sudo docker exec $CONTAINER_NAME_OR_ID [ ! -d $CONTAINER_DIR ]; then
    echo "La ruta del contenedor no existe. Revisar la Ruta de Origen, finalizando proceso."
    exit 1
else
    echo "La ruta del contenedor sí existe, procediendo con el copiado."
fi

echo "sudo docker cp ${CONTAINER_NAME_OR_ID}:${CONTAINER_DIR} ${HOST_DIR}"

sudo docker cp ${CONTAINER_NAME_OR_ID}:${CONTAINER_DIR} ${HOST_DIR}

sudo chmod -R 777 ${HOST_DIR}

echo "Archivos copiados desde el contenedor a ${HOST_DIR}"

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
bye
END_SCRIPT

# Verificar el estado de la transferencia
if [ $? -eq 0 ]; then
  echo "Transferencia de archivos exitosa."
else
  echo "Fallo la transferencia de archivos."
  exit 1
fi
