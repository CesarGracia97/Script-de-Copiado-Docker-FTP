#!/bin/bash

CONTAINER_DIR="/ruta/dentro/contenedor"

HOST_DIR="/ruta/fuera/contenedor"

CONTAINER_NAME_OR_ID=$(docker ps -q --filter "ancestor=nombre_de_la_imagen")

if [ -z "$CONTAINER_NAME_OR_ID" ]; then
    echo "No se encontró ningún contenedor en ejecución."
    exit 1
fi

# Copiar los archivos desde el contenedor al servidor host
docker cp "${CONTAINER_NAME_OR_ID}:${CONTAINER_DIR}" "${HOST_DIR}"

echo "Archivos copiados desde el contenedor a ${HOST_DIR}"

docker logout

#1. Abre una terminal en tu servidor Linux.
#2. Ejecuta el siguiente comando para editar el archivo crontab del usuario actual:
#   crontab -e
#3. Añade una línea al final del archivo crontab para programar la ejecución diaria de tu script. 
#4. 0 0 * * * /ruta/al/script/copiar_archivos.sh                        (si es 24h)
#4. 0 */12 * * * /ruta/al/script/copiar_archivos.sh                     (si es 12h)
#4 0 5 * * * TZ='America/Guayaquil' /ruta/al/script.sh
