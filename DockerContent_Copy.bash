#!/bin/bash
CONTAINER_NAME_OR_ID=$(sudo docker ps | grep build | awk '{print $1}')

if [ -z "$CONTAINER_NAME_OR_ID" ]; then
    echo "No se encontró ningún contenedor con 'build' en su nombre o ID."
    exit 1
fi



CONTAINER_DIR="/usr/src/app/entity/bankdebits"
HOST_DIR="/home/root_wso/RespaldoEnviados"

# Obtener el ID del contenedor que deseas utilizando el comando docker ps y grep

sudo ./DockerContent_Copy.bash $CONTAINER_NAME_OR_ID

sudo docker cp "${CONTAINER_NAME_OR_ID}:${CONTAINER_DIR}" "${HOST_DIR}"

echo "Archivos copiados desde el contenedor a ${HOST_DIR}"

#1. Abre una terminal en tu servidor Linux.
#2. Ejecuta el siguiente comando para editar el archivo crontab del usuario actual:
#   crontab -e
#3. Añade una línea al final del archivo crontab para programar la ejecución diaria de tu script. 
# 0 0 * * * /ruta/al/script/copiar_archivos.sh                        (si es 24h)
# 0 */12 * * * /ruta/al/script/copiar_archivos.sh                     (si es 12h)
# 0 5 * * * TZ='America/Guayaquil' /ruta/al/script.sh
# 25 16 * * * TZ='America/Guayaquil' /ruta/al/script.sh