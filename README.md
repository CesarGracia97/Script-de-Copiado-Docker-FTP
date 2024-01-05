# Documentacion DockerContent_Copy.bash.
## Explicacion.
> Este codigo script de Linux permite copiar archivos de un contenedor y ruta de contenedor especificada, y alojarlo en una ruta especifica. El Script actua de forma minuciosa validando la existencia del contenedor, de la ruta del directorio que alberga los archivos a copiar y de la ruta a alojar los archivos ya copiados; tambien muestra en pantalla los comandos ejecutados y los procesos realizados.
## Modo de Uso.
> 1. Conectarse al servidor donde se aloja el Contenedor 
> 2. Dirigirse al directorio `"/home/root_wso/RespaldoEnviados"`, de no estar y seguir los otros pasos le saldra error.
> 3. Ejecutar el comando sudo docker ps | grep build
> 4. Si ejecuto el paso 3 y le salio un mensaje de password es normal que salga, cancele el ingreso de contraseña y vuelva a ejecutar el paso 3.
> 5. Ejecutar el comando `./DockerContent_Copy.bash`
> 6. Verifique que los archivos fueron copiados.
> 7. Si presiente o ve anomalias con los archivos ingrese al contenedor de Origen.
> 8. `sudo docker ps | grep build`         (le permitira obtener el Id del contenedor.)
> 9. `docker exec -it idContenedor_Docker /bin/bash`