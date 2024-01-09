#!/bin/bash

# Credenciales FTP
FTP_USER="Debbancario"
FTP_PASSWORD="Xtr3m#2023"
FTP_HOST="140.27.120.102"

# Directorios en el contenedor y el host
CONTAINER_DIR="/usr/src/app/entity/bankdebits"
HOST_DIR="\\140.27.120.102\DebitosBancarios\PRODUCCION\ARCHIVOS_ENVIADOS_TYTAN"

# Directorio FTP en el host
FTP_DIR="\DebitosBancarios\PRODUCCION\ARCHIVOS_ENVIADOS_TYTAN"

# Intentar la conexión FTP
ftp_connect() {
    ftp -inv $FTP_HOST <<EOF
    user $FTP_USER $FTP_PASSWORD
    cd $FTP_DIR
EOF
}

# Desconectar FTP
ftp_disconnect() {
    ftp -inv $FTP_HOST <<EOF
    user $FTP_USER $FTP_PASSWORD
    bye
EOF
}

# Intentar conexión FTP
echo "PASO 1 ftp_connect (Conexion FTP por medio de Credenciales)"
if ! ftp_connect; then
    echo "Error al conectar al servidor FTP. Verifica las credenciales y la disponibilidad del servidor."
    exit 1
fi

# Verificar si la ruta HOST_DIR existe, si no existe, crearla
echo "PASO 2 ftp_connect (Validacion de Existencia de directorio) "
if ! ftp_connect; then
    echo "Error al acceder al directorio FTP en el servidor. Verifica la existencia del directorio y los permisos."
    exit 1
fi

# Cerrar la conexión FTP después de crear la carpeta en el servidor
ftp_disconnect

# Ejecutar el comando y capturar la salida
echo "Paso 3 Comando Docker de ID de contenedor"
if sudo docker ps | grep build; then
    echo "El comando 'sudo docker ps | grep build' se ejecutó con éxito."
else
    echo "El comando 'sudo docker ps | grep build' falló en ejecutarse."
    exit 1
fi

CONTAINER_NAME_OR_ID=$(sudo docker ps | grep build | awk '{print $1}')

if [ -z $CONTAINER_NAME_OR_ID ]; then
    echo "No se encontró ningún contenedor con 'build' en su nombre o ID."
    exit 1
fi

# Verificar si la ruta CONTAINER_DIR en el contenedor existe
if sudo docker exec $CONTAINER_NAME_OR_ID [ ! -d $CONTAINER_DIR ]; then
    echo "La ruta del contenedor no existe. Revisar la Ruta de Origen, finalizando proceso."
    exit 1
else
    echo "La ruta del contenedor sí existe, procediendo con el copiado."
fi

# Copiar archivos desde el contenedor al host
echo "sudo docker cp ${CONTAINER_NAME_OR_ID}:${CONTAINER_DIR} ${HOST_DIR}"
sudo docker cp ${CONTAINER_NAME_OR_ID}:${CONTAINER_DIR} ${HOST_DIR}

# Cambiar permisos en el host
sudo chmod -R 777 ${HOST_DIR}

# Mostrar mensaje de éxito
echo "Archivos copiados desde el contenedor a ${HOST_DIR}"


#1. Abre una terminal en tu servidor Linux.
#2. Ejecuta el siguiente comando para editar el archivo crontab del usuario actual:
#   crontab -e
#3. Añade una línea al final del archivo crontab para programar la ejecución diaria de tu script. 
# 0 0 * * * /ruta/al/script/copiar_archivos.sh                        (si es 24h)
# 0 */12 * * * /ruta/al/script/copiar_archivos.sh                     (si es 12h)
# 0 5 * * * TZ='America/Guayaquil' /ruta/al/script.sh
# 25 16 * * * TZ='America/Guayaquil' /ruta/al/script.sh


#15 10 * * * /usr/bin/sudo /usr/bin/docker ps | /usr/bin/grep build && /ruta/completa/DockerContent_Copy.bash || echo "No se encuentra el script DockerContent_Copy.bash"