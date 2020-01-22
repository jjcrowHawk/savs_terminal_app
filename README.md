# terminal_sismos_app

App de Vulnerabilidad Sismica para Materia Integradora

## Requisitos

Para probar este proyecto, se necesita instalar flutter con todas sus dependencias, asi como tambien se deberá tener los IDEs correspondientes para las plataformas en que se desea probar o distribuir (Android Studio para Android o XCode para iOS).

### Instalacion de Flutter en Windows

1. Abrir la consola (CMD o PowerShell) y ubicarse en un directorio especifico, para luego ejecutar el siguiente commando: **git clone https://github.com/flutter/flutter.git** (Debe tener git instalado)

2. Debe actualizar la variable de Entorno PATH, agregando el directorio de flutter **(directorioFlutter/flutter/bin))**, (Puede buscar en la barra de busqueda con la palabra 'env' y luego seleccionar editar variables  de entorono para su cuenta)

3. Una vez hecho esto, corra el comando **fluter doctor**, el cual le indicará las dependencias que faltan por instalar para el funcionamiento de Flutter.


(Estos mismos pasos se aplican para otros SO en los que se desee instalar).


## Prueba de aplicación

Para probar la aplicación para la plataforma android:

1. Abrir Android Studio e ir a Preferences > Plugins para macOS, File > Settings > Plugins para Windows y Linux.
2. Seleccionar Marketplace, buscar y seleccionar Flutter plugin e instalaar. (debera reiniciar Android Studio para que los cambios surjan efecto.)
3. Ahora debe abrir desde android studio la carpeta del proyecto, luego de esto podra probar la aplicacion con un emulador o un dispositivo real conectado mediante los comandos de Run y Build que trae Android Studio.

Para probar la aplicación en iOS:
1. Debera correr dentro de la carpeta del proyecto el commando **flutter build**
2. Luego de esto debera dirigirse dentro de la carpeta del proyecto, a la carpeta que contenga el archivo Runner.WorkSpace, haga click en el archivo, y luego de esto XCode automáticamente abrira el proyecto de la aplicacion en iOS.
3. Ahora ya puede probar de forma convencional en Xcode la aplicación.


## Exportando la aplicación a la tiendas

Para exportar la aplicacion en Android, puede hacerlo convencionalmente en Android Studio en la opcion Build > Generate Signed APK, en la cual usted deberia crear un keystore para la firma de la aplicacion. Posterior a eso, siga los pasos que le indica el Asistente, luego de esto se generará el APK firmado para ser subido a la tienda. Tambien puede ver este articulo: https://flutter.dev/docs/deployment/android.

Para exportar a iOS, debera agregar las credenciales de AppStore Connect a Xcode para generar un ejecutable firmado. Si ya ha ingresao la cuenta en Xocde, debe seguir los pasos indicados en este articulo: https://flutter.dev/docs/deployment/ios
