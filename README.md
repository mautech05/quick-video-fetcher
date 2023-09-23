[**Quick Video Fetcher**](https://github.com/mautech05/quick-video-fetcher) es una interfaz gráfica de [yt-dlp](https://github.com/yt-dlp/yt-dlp) pensada para su uso en computadoras con Windows. Se trata de un proyecto rápido y para nada profesional que fue elaborado enteramente en scripting de [AutoHotKey v2](https://github.com/AutoHotkey/AutoHotkey/tree/v2.0). Te invito a que revises cada línea de código y que instales este programa si estás de acuerdo con el contenido.

## Capturas de Pantalla
![Menú](https://github.com/mautech05/quick-video-fetcher/blob/main/preview.png)

## Sumas de Verificación
Puedes utilizar estos *checksum* para verificar que la descarga no ha sido alterada y/o infectada por un atacante. En caso de que no tengas una herramienta para esta tarea te recomendamos [Quick Checksum Tool](https://github.com/mautech05/quick-checksum-tool).

| NOMBRE DE ARCHIVO       | SHA256                                                           | MD5                              |
|-------------------------|------------------------------------------------------------------|----------------------------------|
| [Quick_Video_Fetcher.ahk](https://github.com/mautech05/quick-video-fetcher/blob/main/Quick_Video_Fetcher.ahk) | 223fc54f76164be125766d5a0b33199ce6c8188998ea28a07280dab60a675a08 | 9e285c1f6bc9dd9866e083a3fb71b9e3 |
| [quickvf_release.zip](https://github.com/mautech05/quick-video-fetcher/releases)     | ff3a4b5fccdf360743fc9ae57711d5d4dd4197ac6c4868a48f79b80511786f72 | 744c9a3d7ad4da4cf8b814d80200776f |

## Instalación
⚠️⚠️Es importante mencionar que este programa **requiere** del uso de **AutoHotKey v2** para funcionar. No obstante, también ofrecemos una versión ya compilada para aquellos que no desean o no pueden instalar AutoHotKey. Dicha versión compilada [no está firmada digitalmente](https://www.redeszone.net/2018/04/21/comprobar-firmas-digitales-programas-windows/) (la licencia cuesta casi 500 euros) por lo que Windows tratará de evitar su ejecución.
- Si **NO** planeas instalar AutoHotKey avanza hasta [esta sección](#sin-autohotkey-instalado) de la guía de instalación.
- Si estás pensando en instalar este intérprete de scripts sigue [este link](https://www.autohotkey.com/download/ahk-v2.exe) para descargarlo en tu computador y avanza hasta [esta sección](#con-autohotkey-instalado).

### SIN AutoHotKey instalado
1. 🌐 Haz clic sobre [este enlace](https://github.com/mautech05/quick-video-fetcher/releases) para dirigirte a la página de las *releases*.
2. 👀 Ubica el artículo/bloque/*release* que, a la derecha del título, tenga una etiqueta verde con el texto **latest**.
3. ⚙️ Haz clic izquierdo sobre el texto que dice *Assets* para desplegar el menú colapsable. Te mostrará tres enlaces a varios archivos, pero el que nos interesa es el que dice **quickvf_release.zip**.
4. 📦 Presiona clic izquierdo sobre este para comenzar la descarga. Una vez que se haya terminado, coloca el archivo comprimido *.zip* donde prefieras.
5. 🔓 Utilizando el software de tu preferencia, descomprime el contenido del ZIP, asegurándote de marcar la opción correspondiente para *extraer aquí*.
6. 📁 Esto te debió haber generado una carpeta con nombre **quickvf_release**. Si es así, entonces ya puedes eliminar el archivo comprimido *.zip* pues ya no lo necesitaremos más.
7. 📄 Abre la carpeta de  **quickvf_release** que extraíste previamente. Una vez allí, ubica el archivo llamado **QuickVF_release.exe** y haz doble clic izquierdo sobre él para ejecutarlo.
- Si te aparece la ventana azul de *[SmartScreen](https://www.adslzone.net/esenciales/windows/smartscreen-windows/)* es necesario que hagas clic izquierdo sobre el texto de "Más Información" y luego otro clic izquierdo sobre el texto de "Ejecutar de todos modos"
8. ⌛ Espera unos segundos. El programa creará tres carpetas y posteriormente abrirá la interfaz.
9. ✅ ¡Todo Listo! Ya puedes comenzar a utilizar el programa. 
Recuerda que la próxima ocasión que abras el **QuickVF_release.exe** no tendrás que esperar pues ya cuentas con las tres carpetas esenciales para el funcionamiento de Quick Video Fetcher.

### CON AutoHotKey instalado
Si tienes [GIT](https://git-scm.com/) instalado en tu ordenador:
```bash
  git clone https://github.com/mautech05/quick-video-fetcher
```

En caso de que no tengas [GIT](https://git-scm.com/) instalado:
1. 📦 Haz clic sobre [este enlace](https://github.com/mautech05/quick-video-fetcher/archive/refs/heads/main.zip) para comenzar la descarga. Una vez que se haya terminado, coloca el archivo comprimido *.zip* donde prefieras.
2. 🔓 Utilizando el software de tu preferencia, descomprime el contenido del ZIP, asegurándote de marcar la opción correspondiente para *extraer aquí*.
3. 📁 Esto te debió haber generado una carpeta con nombre **quick-video-fetcher-main**. Si es así, entonces ya puedes eliminar el archivo comprimido *.zip* pues ya no lo necesitaremos más.
4. 📄 Abre la carpeta de  **quick-video-fetcher-main** que extraíste previamente. Una vez allí, ubica el archivo llamado **Quick_Video_Fetcher.ahk** y haz doble clic izquierdo sobre él para ejecutarlo.
5. ⚙️ Te mostrará un mensaje de bienvenida y, posteriormente, una notificación que indica que se están descargando algunas [librerías](#reconocimientos) desde Internet para que el programa pueda funcionar. La duración de este paso dependerá en buena medida del ancho de banda (mbps) que tengas contratado en tu paquete de internet.
6. 📲 Cuando se haya terminado la descarga de estas librerías, el instalador te preguntará si deseas crear un acceso directo en el escritorio.
- Si tu respuesta fue **SI** entonces dirígete a tu 💻escritorio y haz doble clic izquiero sobre el ícono del folder rojo con el nombre de **Quick Video Fetcher**
- Si tu respuesta fue **NO** entonces vuelve a abrir la 📂carpeta de **quick-video-fetcher-main** y haz doble clic izquierdo sobre el archivo llamado **Quick_Video_Fetcher.ahk** para ejecutarlo.

## Reconocimientos
 - [yt-dlp](https://github.com/yt-dlp/yt-dlp): utilizado para descargar los archivos (videos) desde las diferentes plataformas.
 - [ffmpeg](https://github.com/BtbN/FFmpeg-Builds/releases/): utilizado para convertir los archivos en caso de que tengan un formato o tipo de descarga incorrecto.