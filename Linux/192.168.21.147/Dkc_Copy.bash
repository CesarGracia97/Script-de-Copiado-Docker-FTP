#!/bin/bash

# Definir Variables de Servidor
HOST_DIR="/u01/dpsbs/data/DebitosSFTP/search"

# Definir Variables de Servidor->FTP
FTP_USER="Debbancario"
FTP_PASSWORD="Xtr3m#2023"
FTP_HOST="140.27.120.102"
SFTP_PORT=2222

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


echo "Conectando a NAS..."
sftppass -p "$SFTP_PASSWORD" sftp -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
   ls
EOF

if [ $? -eq 0 ]; then
    echo "Conexión exitosa a NAS."

    # Realizar transferencias
    echo "Transferiendo archivos..."

    sftppass -p "$SFTP_PASSWORD" sftp -oPort=$SFTP_PORT $SFTP_USER@$SFTP_HOST <<EOF
        mput $DIR_ORIGEN1/*.txt $DIR_HOST_R1/
        mput $DIR_ORIGEN2/*.txt $DIR_HOST_R2/
        mput $DIR_ORIGEN3/*.txt $DIR_HOST_R3/
        mput $DIR_ORIGEN4/*.txt $DIR_HOST_R4/
        mput $DIR_ORIGEN5/*.txt $DIR_HOST_R5/
        mput $DIR_ORIGEN6/*.txt $DIR_HOST_R6/
        mput $DIR_ORIGEN7/*.txt $DIR_HOST_R7/
        mput $DIR_ORIGEN8/*.txt $DIR_HOST_R8/
        bye
EOF

    if [ $? -eq 0 ]; then
        echo "Transferencia de archivos exitosa."
        # Preguntar al usuario si desea eliminar archivos locales
        read -p "¿Deseas eliminar los archivos locales de las carpetas de bankdebits? (Y/N): " opcion

        # Eliminar archivos locales si la respuesta es 'Y'
        if [ "$opcion" == "Y" ] || [ "$opcion" == "y" ]; then
            find $DIR_ORIGEN1 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN2 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN3 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN4 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN5 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN6 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN7 -type f -name "*.txt" -exec rm -f {} +
            find $DIR_ORIGEN8 -type f -name "*.txt" -exec rm -f {} +

            echo "Archivos locales .txt eliminados."
        else
            echo "No se han eliminado archivos locales."
        fi
    else
        echo "Fallo en la transferencia de archivos."
    fi
else
    echo "Fallo la conexión a NAS."
fi

exit 0


