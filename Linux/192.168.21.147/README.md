# Documentacion Dkc_Copy.bash 192.168.21.147
## Procedimiento
> El funcionamiento de Dkc_Copy (21.147) es similar a su version original (59.184), el mayor cambio es el paso de  FTP a SFTP por razones basadas en el servidor donde se aloja este script.
> Dkc_Copy (21.147) se saltea el procedimiento Docker ya que los archivos son alojados desde un servidor local evitando todo el procedimiento de ID y copiado.
> Dkc_Copy (21.147) cambia la estructura de inicio de sesion por razones de sintaxis (FTP - SFTP).
> Dkc_Copy (21.147) mantiene la pregunta de eliminacion de archivos para evitar la latencia al enviar datos por medio del script.
>`1. Abre una terminal en tu servidor Linux.`
>`2. Ejecuta el siguiente comando para editar el archivo crontab del usuario actual:`
>`crontab -e`
>`3. Anade una l�nea al final del archivo crontab para programar la ejecucion diaria de tu script.` 
>`0 0 * * * /ruta/al/script/copiar_archivos.sh                        (si es 24h)`
>`0 */12 * * * /ruta/al/script/copiar_archivos.sh                     (si es 12h)`
>`0 5 * * * TZ='America/Guayaquil' /ruta/al/script.sh`
>`25 16 * * * TZ='America/Guayaquil' /ruta/al/script.sh`
>`15 10 * * * /usr/bin/sudo /usr/bin/docker ps | /usr/bin/grep build && /ruta/completa/DockerContent_Copy.bash || echo "No se encuentra el script DockerContent_Copy.bash"`