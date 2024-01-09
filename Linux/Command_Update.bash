
#1. Abre una terminal en tu servidor Linux.
#2. Ejecuta el siguiente comando para editar el archivo crontab del usuario actual:
#   crontab -e
#3. Añade una línea al final del archivo crontab para programar la ejecución diaria de tu script. 
# 0 0 * * * /ruta/al/script/copiar_archivos.sh                        (si es 24h)
# 0 */12 * * * /ruta/al/script/copiar_archivos.sh                     (si es 12h)
# 0 5 * * * TZ='America/Guayaquil' /ruta/al/script.sh
# 25 16 * * * TZ='America/Guayaquil' /ruta/al/script.sh


#15 10 * * * /usr/bin/sudo /usr/bin/docker ps | /usr/bin/grep build && /ruta/completa/DockerContent_Copy.bash || echo "No se encuentra el script DockerContent_Copy.bash"