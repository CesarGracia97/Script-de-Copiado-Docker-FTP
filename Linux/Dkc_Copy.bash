#!/bin/bash

#Definir Variables de Contenedor->Servidor
CONTAINER_NAME_OR_ID=$(sudo docker ps | grep build | awk '{print $1}')
CONTAINER_DIR="/usr/src/app/entity/bankdebits"
HOST_DIR="/home/root_wso/RespaldoEnviados"
#Definir Variables de Servidor->FTP
FTP_USER="Debbancario"
FTP_PASSWORD="Xtr3m#2023"
FTP_HOST="140.27.120.102"
HOST_DIR_FTP="//140.27.120.102/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN"
CHRFTP_FILE_DIR="/RespaldoEnviados/bankdebits"
#Definir Función para manejar errores
handle_error() {
    local exit_code=$?
    if [ $exit_code -ne 0 ]; then
        echo "Error: $1"
        exit $exit_code
    fi
}

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

#ParteFTP

echo "Iniciando carga de archivos a la NAS a través de FTP..."
ftp -inv $HOST_FTP <<EOF
    user $FTP_USER $FTP_PASSWORD
    binary
    cd $HOST_DIR_FTP
    mput -r $HOST_DIR/*
    bye
EOF

# Manejar errores durante la carga de archivos a la NAS
handle_error "Error al cargar archivos a la NAS a través de FTP"

# Mensaje de éxito
echo "Archivos cargados en la NAS con éxito."
