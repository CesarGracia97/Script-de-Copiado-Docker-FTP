#!/bin/bash
CONTAINER_NAME_OR_ID=$(sudo docker ps | grep build | awk '{print $1}')

if [ -z $CONTAINER_NAME_OR_ID ]; then
    echo "No se encontró ningún contenedor con 'build' en su nombre o ID."
    exit 1
fi


CONTAINER_DIR="/usr/src/app/entity/bankdebits"
HOST_DIR="/home/root_wso/RespaldoEnviados"

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

#1. Abre una terminal en tu servidor Linux.
#2. Ejecuta el siguiente comando para editar el archivo crontab del usuario actual:
#   crontab -e
#3. Añade una línea al final del archivo crontab para programar la ejecución diaria de tu script. 
# 0 0 * * * /ruta/al/script/copiar_archivos.sh                        (si es 24h)
# 0 */12 * * * /ruta/al/script/copiar_archivos.sh                     (si es 12h)
# 0 5 * * * TZ='America/Guayaquil' /ruta/al/script.sh
# 25 16 * * * TZ='America/Guayaquil' /ruta/al/script.sh