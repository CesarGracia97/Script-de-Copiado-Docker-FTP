#!/bin/bash
sudo docker ps | grep build

# Ejecutar el comando y capturar la salida
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

# Conectar al NAS a través de FTP
FTP_USER="Debbancario"
FTP_PASSWORD="Xtr3m#2023"
FTP_HOST="140.27.120.102"

# Iniciar sesión en el FTP y verificar la conexión
ftp -n $FTP_HOST <<EOF
quote USER $FTP_USER
quote PASS $FTP_PASSWORD
quit
EOF
echo "Procedimiento FTP Paso 1 (conexion FTP)"

if [ $? -eq 0 ]; then
    echo "Conexión FTP al HOST ($FTP_HOST) exitosa"
else
    echo "Conexión FTP fallida. Verifica las credenciales o la configuración del servidor."
    exit 1
fi

# Verificar si existe el directorio en el NAS
HOST_DIR_FTP="/DebitosBancarios/PRODUCCION/ARCHIVOS_ENVIADOS_TYTAN"

ftp -n $FTP_HOST <<EOF
quote USER $FTP_USER
quote PASS $FTP_PASSWORD
cd "$HOST_DIR_FTP"
quit
EOF

echo "Procedimiento FTP Paso 2 (Existencia de directorio FTP)"

if [ $? -ne 0 ]; then
    # El directorio no existe, crearlo
    ftp -n $FTP_HOST <<EOF
    quote USER $FTP_USER
    quote PASS $FTP_PASSWORD
    mkdir "$HOST_DIR_FTP"
    quit
EOF
    echo "Directorio $HOST_DIR_FTP creado en el NAS"
else
    echo "Directorio $HOST_DIR_FTP ya existe en el NAS"
fi

echo "Procedimiento FTP Paso 3 (Carga de Archivos a FTP)"

# Transferir archivos al NAS
ftp -n $FTP_HOST <<EOF
quote USER $FTP_USER
quote PASS $FTP_PASSWORD
cd "$HOST_DIR_FTP"
lcd "$HOST_DIR"
prompt
mput *
quit
EOF

if [ $? -eq 0 ]; then
    echo "Transferencia de archivos al NAS exitosa"
else
    echo "Fallo en la transferencia de archivos al NAS. Verifica la conexión o los permisos."
fi

echo "Procedimiento FTP Paso 4 (Finalizar conexion FTP)"

# Cerrar sesión en el FTP
ftp -n $FTP_HOST <<EOF
quote USER $FTP_USER
quote PASS $FTP_PASSWORD
quit
EOF
