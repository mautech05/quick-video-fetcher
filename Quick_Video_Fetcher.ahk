#Requires AutoHotkey >=2.0- <2.1
#SingleInstance Force
#ErrorStdOut
#Warn All, Off


;Configuraciones del Script
global installation_base_dir := A_ScriptDir
global buttons_dir := installation_base_dir "\buttons\"
global libraries_dir := installation_base_dir "\libraries\"
global temporal_dir := installation_base_dir "\tmp\"
global settings_dir := installation_base_dir "\settings\"
global set_update_settings := settings_dir "quickVF_updater.txt"
global set_online_version := settings_dir "quickVF_online.txt"
global title_path := temporal_dir "quickVF_title.txt"
global check_dl_option := temporal_dir "quickVF_option.txt"
global download_path := ""
global script_icon := buttons_dir "QuickVideoFetcher.ico"
global U_version := "0.1.0.0" ;Tiene que ser en formato X.X.X.X para evitar problemas con el AutoUpdater
;@Ahk2Exe-SetVersion 0.1.0.0
;@Ahk2Exe-SetName Quick Video Fetcher
;@Ahk2Exe-SetDescription Herramienta para descargar videos de internet
;@Ahk2Exe-SetCompanyName MauTech05
;@Ahk2Exe-SetCopyright MauTech05
;@Ahk2Exe-SetLanguage 0x080a
;@Ahk2Exe-ExeName QuickVF_release.exe
;@Ahk2Exe-SetMainIcon buttons\QuickVideoFetcher.ico
;@Ahk2Exe-Base C:\Program Files\AutoHotkey\v2\AutoHotkey32.exe
;@Ahk2Exe-AddResource buttons\button.png
;@Ahk2Exe-AddResource buttons\button_analizar.png
;@Ahk2Exe-AddResource buttons\button_comenzar.png
;@Ahk2Exe-AddResource buttons\button_espere.png
;@Ahk2Exe-AddResource buttons\button_guardar-como.png
;@Ahk2Exe-AddResource buttons\button_x.png
;@Ahk2Exe-AddResource buttons\maintab_acerca.png
;@Ahk2Exe-AddResource buttons\maintab_inicio.png
;@Ahk2Exe-AddResource buttons\maintab_plataformas.png
;@Ahk2Exe-AddResource buttons\QuickVideoFetcher.ico
;@Ahk2Exe-AddResource buttons\tab_acerca.png
;@Ahk2Exe-AddResource buttons\tab_inicio.png
;@Ahk2Exe-AddResource buttons\tab_plataformas.png
;@Ahk2Exe-AddResource buttons\tabs_border.png
;@Ahk2Exe-AddResource libraries\release\yt-dlp.exe
;@Ahk2Exe-AddResource libraries\release\ffmpeg.exe
;@Ahk2Exe-AddResource libraries\release\ffprobe.exe
;@Ahk2Exe-AddResource libraries\release\LICENSE_FFmpeg.txt
;@Ahk2Exe-AddResource libraries\release\LICENSE_yt-dlp.txt
;@Ahk2Exe-AddResource libraries\release\versions.txt
;@Ahk2Exe-AddResource libraries\release\README.md
if not FileExist(buttons_dir "tabs_border.png") {
	DirCreate buttons_dir
	DirCreate libraries_dir
	DirCreate temporal_dir
	DirCreate settings_dir
	FileInstall "buttons\button.png", buttons_dir "button.png"
	FileInstall "buttons\button_analizar.png", buttons_dir "button_analizar.png"
	FileInstall "buttons\button_comenzar.png", buttons_dir "button_comenzar.png"
	FileInstall "buttons\button_espere.png", buttons_dir "button_espere.png"
	FileInstall "buttons\button_guardar-como.png", buttons_dir "button_guardar-como.png"
	FileInstall "buttons\button_x.png", buttons_dir "button_x.png"
	FileInstall "buttons\maintab_acerca.png", buttons_dir "maintab_acerca.png"
	FileInstall "buttons\maintab_inicio.png", buttons_dir "maintab_inicio.png"
	FileInstall "buttons\maintab_plataformas.png", buttons_dir "maintab_plataformas.png"
	FileInstall "buttons\QuickVideoFetcher.ico", buttons_dir "QuickVideoFetcher.ico"
	FileInstall "buttons\tab_acerca.png", buttons_dir "tab_acerca.png"
	FileInstall "buttons\tab_inicio.png", buttons_dir "tab_inicio.png"
	FileInstall "buttons\tab_plataformas.png", buttons_dir "tab_plataformas.png"
	FileInstall "buttons\tabs_border.png", buttons_dir "tabs_border.png"
	FileInstall "libraries\release\yt-dlp.exe", libraries_dir "yt-dlp.exe"
	FileInstall "libraries\release\ffmpeg.exe", libraries_dir "ffmpeg.exe"
	FileInstall "libraries\release\ffprobe.exe", libraries_dir "ffprobe.exe"
	FileInstall "libraries\release\LICENSE_FFmpeg.txt", libraries_dir "LICENSE_FFmpeg.txt"
	FileInstall "libraries\release\LICENSE_yt-dlp.txt", libraries_dir "LICENSE_yt-dlp.txt"
	FileInstall "libraries\release\versions.txt", libraries_dir "versions.txt"
	FileInstall "libraries\release\README.md", libraries_dir "README.md"
}

;Configuraciones del Ícono de la Bandeja
A_IconTip := "Quick Video Fetcher"
TraySetIcon(script_icon)
Tray := A_TrayMenu
Tray.delete
Tray.Add("Cerrar", GuiEscape)

;Instalación (Nunca antes se ha usado el programa)
if !FileExist(libraries_dir "yt-dlp.exe") && !FileExist(libraries_dir "ffmpeg.exe") && !FileExist(libraries_dir "ffprobe.exe") {
	start_installation := MsgBox("¡Gracias por descargar Quick Video Fetcher! Con este programa podrás descargar videos desde casi cualquier página o sitio de internet de manera rápida y sencilla.`n`nHaz clic en el botón de [ACEPTAR] para comenzar con la instalación.", "Instalador - Quick Video Fetcher", "OKCancel T15 Iconi")
	if (start_installation = "OK" || start_installation = "Timeout")
		installQVF()
	else
		ExitApp
}

;Verificacion de Librerías
if !FileExist(libraries_dir "yt-dlp.exe") {
	lib_missing("yt-dlp.exe")
	installQVF()
}
if !FileExist(libraries_dir "ffmpeg.exe") {
	lib_missing("ffmpeg.exe")
	installQVF()
}
if !FileExist(libraries_dir "ffprobe.exe") {
	lib_missing("ffprobe.exe")
	installQVF()
}


;Verificación de Actualizaciones
try {
	global Update_Settings := FileRead(set_update_settings)
} catch {
	try
		FileDelete set_update_settings
	FileAppend "Manual", set_update_settings
	global Update_Settings := FileRead(set_update_settings)
}
if Update_Settings == "Automatico" {
	AutoUpdate()
	update_status := "checked"
} else {
	update_status := ""
}


;Configuraciones de la Interfaz de Usuario (GUI)
OnMessage(0x0201, WM_LBUTTONDOWN)
quickVF_GUI := Gui()
quickVF_GUI.Title := "Quick Video Fetcher by MauTech05"
quickVF_GUI.OnEvent("Close", GuiEscape)
quickVF_GUI.OnEvent("Escape", GuiEscape)
quickVF_GUI.Opt("-Caption +Border")
quickVF_GUI.BackColor := "191919"


;Encabezado
quickVF_GUI.Add("Picture", "x15 y6 w30 h-1", script_icon)
quickVF_GUI.SetFont("s16 w900 cffffff", "Roboto")
quickVF_GUI.Add("Text", "x60 y7", "Quick Video Fetcher")
quickVF_GUI.SetFont("s12 w900 c5f656d", "Roboto")
quickVF_GUI.Add("Text", "x280 y11", "v" U_version)
botonMinimizarGUI := quickVF_GUI.Add("Picture", "x400 y10 w15 h-1", buttons_dir "\button.png")
	botonMinimizarGUI.OnEvent("Click", GuiMinimize)
botonCerrarGUI := quickVF_GUI.Add("Picture", "x430 y10 w15 h-1", buttons_dir "\button_x.png")
	botonCerrarGUI.OnEvent("Click", GuiEscape)

;========== DESCARGAS (INICIO) ==========
quickVF_GUI.SetFont("s9 w400 c000000", "Open Sans")
global VFtabs := quickVF_GUI.Add("Tab3", "x15 y50 w520 h334 section 0x182", ["Inicio","Plataformas soportadas", "Acerca de"])
homeTab:= quickVF_GUI.Add("Picture", "xs ys w-1 h25", buttons_dir "\maintab_inicio.png")
platformsTab:= quickVF_GUI.Add("Picture", "xs+62 ys+5 w-1 h20", buttons_dir "\tab_plataformas.png")
	platformsTab.OnEvent("Click", goToPlatforms)
aboutTab:= quickVF_GUI.Add("Picture", "xs+263 ys+5 w-1 h20", buttons_dir "\tab_acerca.png")
	aboutTab.OnEvent("Click", goToAbout)
quickVF_GUI.Add("Picture", "xs ys+25 w425 h310 section", buttons_dir "\tabs_border.png")

inputURL := quickVF_GUI.Add("Edit", "xs+10 ys+20 w300 h21 -VScroll")
	SendMessage(0x1501, 1, StrPtr("Ingrese una URL aquí [Admite varias plataformas]"), , "ahk_id " inputURL.hwnd)
botonAnalizarURL :=quickVF_GUI.Add("Picture", "xs+325 ys+20 w85 h-1", buttons_dir "\button_analizar.png")
	botonAnalizarURL.OnEvent("Click", AnalyzeURL)
botonAnalizandoURL :=quickVF_GUI.Add("Picture", "xs+325 ys+20 w85 h-1", buttons_dir "\button_espere.png")

;Opciones de Descarga
quickVF_GUI.SetFont("s11 w600 cffffff", "Roboto")
quickVF_GUI.Add("Text", "xs+10 ys+60 section", "Opciones de descarga")
quickVF_GUI.SetFont("s9 w400 cffffff", "Open Sans")
quickVF_GUI.Add("Text", "xs+15 ys+25 w45 h18 +0x200", "Título:")
outputTitulo := quickVF_GUI.Add("Edit", "xs+60 ys+25 w340 h18 -VScroll +Disabled", "Primero ingresa una URL y haz clic en Analizar")
seccionDescarga := quickVF_GUI.Add("Text", "xs+15 ys+55 h18 +0x200", "Descargar:")
opcionDescarga := quickVF_GUI.Add("DropDownList", "xs+90 ys+55 w310", ["Video + Audio", "Sólo video", "Sólo audio"])
	opcionDescarga.OnEvent("Change", ShowControls)

	;Completo y Sólo video
	seccionFormatoV := quickVF_GUI.Add("Text", "xs+15 ys+85 h18 +0x200", "Formato:")
	videoFormato := quickVF_GUI.Add("DropDownList", "xs+90 ys+85 w80", ["webm", "mp4", "mov", "flv"])
		videoFormato.OnEvent("Change", ChooseFormat)
	seccionResolucion := quickVF_GUI.Add("Text", "xs+180 ys+85 h18 +0x200", "Resolución:")
	videoResolucion := quickVF_GUI.Add("DropDownList", "xs+255 ys+85 w145", ["2160p (Ultra HD / 4K)", "1440p (Quad HD / 2K)","1080p (Full HD)", "720p (HD)", "480p (SD)", "360p", "240p", "144p"])

	;Sólo audio
	seccionFormatoA := quickVF_GUI.Add("Text", "xs+15 ys+85 h18 +0x200", "Formato:")
	audioFormato := quickVF_GUI.Add("DropDownList", "xs+90 ys+85 w80", ["m4a", "aac", "mp3", "ogg", "opus", "webm"])
		audioFormato.OnEvent("Change", ChooseFormat)

	;Guardar como
	quickVF_GUI.SetFont("s9 w400 c000000", "Open Sans")
	inputUbicacion := quickVF_GUI.Add("Edit", "xs+15 ys+115 w250 R1 -VScroll +ReadOnly")
	botonUbicacion :=quickVF_GUI.Add("Picture", "xs+275 ys+115 w124 h-1", buttons_dir "\button_guardar-como.png")
		botonUbicacion.OnEvent("Click", ChoosePath)

quickVF_GUI.SetFont("s9 w400 c5f656d", "Open Sans")
aclaracionDescarga := quickVF_GUI.Add("Text", "xs ys+155 w400", "*Si no se encuentra el formato y/o resolución elegidos se descargará el mejor disponible y luego se aplicará una conversión.")
botonDescargarURL := quickVF_GUI.Add("Picture", "xs ys+195 w-1 h25", buttons_dir "\button_comenzar.png")
	botonDescargarURL.OnEvent("Click", DownloadURL)

;Ocultar controles
botonAnalizandoURL.Visible := false
seccionDescarga.Visible := false
opcionDescarga.Visible := false
seccionResolucion.Visible := false
videoResolucion.Visible := false
seccionFormatoV.Visible := false
videoFormato.Visible := false
seccionFormatoA.Visible := false
audioFormato.Visible := false
inputUbicacion.Visible := false
botonUbicacion.Visible := false
aclaracionDescarga.Visible := false
botonDescargarURL.Visible := false

;========== PLATAFORMAS SOPORTADAS ==========
VFtabs.UseTab(2)
quickVF_GUI.SetFont("s9 w400 cffffff", "Open Sans")
homeTab:= quickVF_GUI.Add("Picture", "x15 y55 w-1 h20 section", buttons_dir "\tab_inicio.png")
	homeTab.OnEvent("Click", goToHome)
platformsTab:= quickVF_GUI.Add("Picture", "xs+62 ys-5 w200 h25", buttons_dir "\maintab_plataformas.png")
aboutTab:= quickVF_GUI.Add("Picture", "xs+263 ys w-1 h20", buttons_dir "\tab_acerca.png")
	aboutTab.OnEvent("Click", goToAbout)
quickVF_GUI.Add("Picture", "xs ys+20 w425 h310 section", buttons_dir "\tabs_border.png")

quickVF_GUI.Add("Text", "xs+10 ys+20", "YouTube")
quickVF_GUI.Add("Text", "xs+10 ys+70", "Tiktok")
quickVF_GUI.Add("Text", "xs+10 ys+120", "Facebook")
quickVF_GUI.Add("Text", "xs+10 ys+150", "Reddit")
quickVF_GUI.Add("Text", "xs+10 ys+180", "Instagram")
quickVF_GUI.Add("Text", "xs+10 ys+210", "Twitch")
quickVF_GUI.Add("Text", "xs+60 ys+260", "Prueba con otras plataformas, ¡Quizás tengas suerte!")

quickVF_GUI.SetFont("s9 w400 c5f656d", "Open Sans")
quickVF_GUI.Add("Text", "xs+80 ys+20 w330 r1", "https://www.youtube.com/watch?v=ABCDE123456")
quickVF_GUI.Add("Text", "xs+80 ys+40 w330 r1", "https://youtu.be/ABCDE123456")
quickVF_GUI.Add("Text", "xs+80 ys+70 w330 r1", "https://www.tiktok.com/@usuario/video/1234567890123456789")
quickVF_GUI.Add("Text", "xs+80 ys+90 w330 r1", "https://vm.tiktok.com/ABCDE1234/")
quickVF_GUI.Add("Text", "xs+80 ys+120 w330 r1", "https://fb.watch/ABCDE12345/")
quickVF_GUI.Add("Text", "xs+80 ys+150 w330 r1", "https://www.reddit.com/r/comunidad/comments/ABCD123/usuario/")
quickVF_GUI.Add("Text", "xs+80 ys+180 w330 r1", "https://www.instagram.com/reel/ABCDEF12345/")
quickVF_GUI.Add("Text", "xs+80 ys+210 w330 r1", "https://www.twitch.tv/videos/1234567890")

;========== ACERCA DE ==========
VFtabs.UseTab(3)
homeTab:= quickVF_GUI.Add("Picture", "x15 y55 w-1 h20 section", buttons_dir "\tab_inicio.png")
	homeTab.OnEvent("Click", goToHome)
platformsTab:= quickVF_GUI.Add("Picture", "xs+62 ys w-1 h20", buttons_dir "\tab_plataformas.png")
	platformsTab.OnEvent("Click", goToPlatforms)
aboutTab:= quickVF_GUI.Add("Picture", "xs+263 ys-5 w-1 h25", buttons_dir "\maintab_acerca.png")
quickVF_GUI.Add("Picture", "xs ys+20 w425 h310 section", buttons_dir "\tabs_border.png")

quickVF_GUI.SetFont("s9 w400 cffffff", "Open Sans")
check_autoupdates := quickVF_GUI.Add("CheckBox", "xs+10 ys+20 w400 " update_status, "Descargar e instalar actualizaciones al iniciar el programa")
	check_autoupdates.OnEvent("Click", EnableAutoUpdate)
quickVF_GUI.Add("Link", "xs+10 ys+70 w400", 'Interfaz por <a href="https://github.com/mautech05">MauTech05</a>')
quickVF_GUI.Add("Link", "xs+10 ys+90 w400", 'Ejecutable de yt-dlp en su <a href="https://github.com/yt-dlp/yt-dlp">github</a>')
quickVF_GUI.Add("Link", "xs+10 ys+120 w400", 'Binarios de FFmpeg y FFmprobe en su <a href="https://www.ffmpeg.org/">página oficial</a>. No obstante, nosotros utilizamos las <a href="https://github.com/yt-dlp/FFmpeg-Builds">custom builds</a> que proveen los creadores de yt-dlp.')
quickVF_GUI.Add("Link", "xs+10 ys+180 w400", 'Ícono «Folder» creado por Freepik para <a href="https://www.flaticon.com/free-icon/folder_440856" title="folder icons">flaticon.com</a>')

quickVF_GUI.SetFont("s9 w400 c5f656d", "Open Sans")
quickVF_GUI.Add("Text", "xs+30 ys+105 w390 r1", "Utilizado para descargar los videos desde las diferentes plataformas.")
quickVF_GUI.Add("Text", "xs+30 ys+150 w390 r2", "Utilizado para convertir los videos en caso de que tengan un formato o tipo de descarga incorrecto.")


quickVF_GUI.Show("w456 h400")
quickVF_GUI.SetFont("s9 w600 c000000", "Open Sans")
Return

;========== FUNCIONES DE LA INTERFAZ GUI ==========
WM_LBUTTONDOWN(*) {
	Try PostMessage(0xA1, 2, , , "A")
}
GuiEscape(*) {
	GuiClose:
		ExitApp()
}
GuiMinimize(*) {
	quickVF_GUI.Minimize()
}
goToHome(*) {
	VFtabs.Choose(1)
}
goToPlatforms(*) {
	VFtabs.Choose(2)
}
goToAbout(*) {
	VFtabs.Choose(3)
}
HideTrayTip(*) {
    TrayTip  ; Attempt to hide it the normal way.
    if SubStr(A_OSVersion,1,3) = "10." {
        A_IconHidden := true
        Sleep 200  ; It may be necessary to adjust this sleep.
        A_IconHidden := false
    }
}
ControlsEnabled(*) {
	if (download_option = "Video + Audio" || download_option  = "Sólo video") {
		videoResolucion.Enabled := true
		videoFormato.Enabled := true
	} else {
		audioFormato.Enabled := true
	}
	botonAnalizarURL.Enabled := true
	opcionDescarga.Enabled := true
	botonUbicacion.Enabled := true
	botonDescargarURL.Visible := true
}
ControlsDisabled(*) {
	if (download_option = "Video + Audio" || download_option  = "Sólo video") {
		videoResolucion.Enabled := false
		videoFormato.Enabled := false
	} else {
		audioFormato.Enabled := false
	}
	botonAnalizarURL.Enabled := false
	opcionDescarga.Enabled := false
	botonUbicacion.Enabled := false
	botonDescargarURL.Visible := false
}
EnableAutoUpdate(*) {
	if check_autoupdates.Value = 1 {
		try
			FileDelete set_update_settings
		FileAppend "Automatico", set_update_settings
		AutoUpdate()
	} else {
		try
			FileDelete set_update_settings
		FileAppend "Manual", set_update_settings
	}
}
AutoUpdate(*) {
	try {
		RunWait "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command curl https://raw.githubusercontent.com/mautech05/quick-video-fetcher/main/settings/quickVF_version.txt -O " settings_dir "\quickVF_online.txt", , "Hide"
		online_version := RegExReplace(FileRead(set_online_version),"\.")
		offline_version :=  RegExReplace(U_version,"\.")

		if (online_version > offline_version) {
			RunWait "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command curl https://raw.githubusercontent.com/mautech05/quick-video-fetcher/main/Quick_Video_Fetcher.ahk -O " temporal_dir "\Quick_Video_Fetcher.ahk", , "Hide"
			FileMove temporal_dir "\Quick_Video_Fetcher.ahk", A_ScriptDir, 1
			Reload
		}
	} catch {
		MsgBox "No pudimos conectar con el servidor de actualizaciones, por lo que no sabemos si ya cuentas con la versión más actualizada. Favor de intentar nuevamente más tarde.", "Actualizador de Quick Video Fetcher", "OK T15 Iconx"
	}
}


;========== FUNCIONES DEL INSTALADOR =========
installQVF(*){
	;Establecer variables de inicio
	temporal_dir := A_ScriptDir "\tmp\"
	libraries_dir := A_ScriptDir "\libraries\"
	DirCreate temporal_dir
	DirCreate libraries_dir
	if A_Is64bitOS == 1 {
		downloadYTdlp := "https://github.com/yt-dlp/yt-dlp/releases/download/2023.07.06/yt-dlp.exe"
		downloadFFmpeg := "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/autobuild-2023-06-30-14-08/ffmpeg-n6.0-26-g3f345ebf21-win64-gpl-6.0.zip"
		HideTrayTip()
		TrayTip "Estamos descargando algunas librerias (140 MiB aproximadamente) desde Internet. Esto puede tomar más o menos tiempo según tu conexión a internet.", "Instalador de Quick Video Fetcher", "Iconi"
	} else {
		downloadYTdlp := "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp_x86.exe"
		downloadFFmpeg := "https://github.com/yt-dlp/FFmpeg-Builds/releases/download/autobuild-2023-06-30-14-08/ffmpeg-n6.0-26-g3f345ebf21-win32-gpl-6.0.zip"
		HideTrayTip()
		TrayTip "Estamos descargando algunas librerias (104 MiB aproximadamente) desde Internet. Esto puede tomar más o menos tiempo según tu conexión a internet.", "Instalador de Quick Video Fetcher", "Iconi"
	}
	;Descargar YT-DLP desde internet
	if !FileExist(libraries_dir "yt-dlp.exe") {
		try {
			HideTrayTip()
			TrayTip "Descargando la librería de yt-dlp...", "Instalador de Quick Video Fetcher", "Iconi"
			RunWait "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command curl " downloadYTdlp " -O " libraries_dir "yt-dlp.exe"
		} catch {
			dl_lib_failed("yt-dlp",downloadYTdlp)
		}
	}
	;Descargar FFmpeg desde internet
	if !FileExist(libraries_dir "ffmpeg.exe") || !FileExist(libraries_dir "ffprobe.exe") {
		try {
			HideTrayTip()
			TrayTip "Descargando la librería de ffmpeg y ffprobe...", "Instalador de Quick Video Fetcher", "Iconi"
			RunWait "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command curl " downloadFFmpeg " -O " libraries_dir "ffmpeg.zip"
			ffmpeg_web_install()
		} catch {
			dl_lib_failed("FFmpeg",downloadYTdlp)
		}
	}
	;Acceso directo de Escritorio
	shortcut:= MsgBox("¿Quieres que dejemos un acceso directo en el escritorio?", "Instalador de Quick Video Fetcher", "36")
	if shortcut = "Yes"
		FileCreateShortcut A_ScriptDir "\Quick_Video_Fetcher.ahk", A_Desktop "\Quick Video Fetcher.lnk", , , "Quick Video Fetcher", A_ScriptDir "\buttons\QuickVideoFetcher.ico"
	Reload
}

;Extraer FFmpeg y FFmprobe en caso de que SÍ se pudo descargar desde Internet
ffmpeg_web_install(*) {
	HideTrayTip()
	TrayTip "Descomprimiendo la librería de ffmpeg y ffprobe...", "Instalador de Quick Video Fetcher", "Iconi"
	RunWait "C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe -Command Expand-Archive -LiteralPath " libraries_dir "ffmpeg.zip -DestinationPath " libraries_dir, , "Hide"
	FileDelete libraries_dir "ffmpeg.zip"
	if A_Is64bitOS == 1 {
		FileMove libraries_dir "ffmpeg-n6.0-26-g3f345ebf21-win64-gpl-6.0\bin\ffmpeg.exe", libraries_dir
		FileMove libraries_dir "ffmpeg-n6.0-26-g3f345ebf21-win64-gpl-6.0\bin\ffprobe.exe", libraries_dir
		DirDelete libraries_dir "ffmpeg-n6.0-26-g3f345ebf21-win64-gpl-6.0", 1
	} else {
		FileMove libraries_dir "ffmpeg-n6.0-26-g3f345ebf21-win32-gpl-6.0\bin\ffmpeg.exe", libraries_dir
		FileMove libraries_dir "ffmpeg-n6.0-26-g3f345ebf21-win32-gpl-6.0\bin\ffprobe.exe", libraries_dir
		DirDelete libraries_dir "ffmpeg-n6.0-26-g3f345ebf21-win32-gpl-6.0", 1
	}
}

;Error al descargar una librería
dl_lib_failed(library,link) {
	MsgBox "Intentamos descargar la librería de " library " desde " link " pero es posible que el servidor de descarga haya sido eliminado o movido.`n`nFavor de tomar una captura de pantalla de este mensaje y contactar al desarrollador de Quick Video Fetcher (MauTech05 en GitHub)", "Instalador de Quick Video Fetcher", "OK T15 Iconi"
	ExitApp
}

;No se encontró una librería -> Instalarla vía installQVF(*)
lib_missing(library) {
	MsgBox "No se encontró una instalación de " library " dentro de la carpeta de Librerías. Procederemos a descargar e instalar el software faltante por tí.", "Instalador de Quick Video Fetcher", "OK T15 Iconi"
}

;========== FUNCIONES DE PROCESAMIENTO =========
AnalyzeURL(*) {
	VFtabs.UseTab(1)
	quickVF_GUI.Add("Text", "xs+10 ys+60 section", "") ;Punto de control para los estilos

	;Reiniciar controles de interfaz
	outputTitulo.Value := ""
	opcionDescarga.Value := ""
	videoResolucion.Value := ""
	videoFormato.Value := ""
	audioFormato.Value := ""
	inputUbicacion.Value := "Elija una ubicación para guardar el archivo"

	global URL := inputURL.Text
	if URL = "" {
		MsgBox "Es necesario ingresar un enlace (URL) para continuar", "Quick Video Fetcher", "Iconx"
		return
	}
	if FileExist(title_path)
		FileDelete title_path
	botonAnalizarURL.Visible := false
	botonAnalizandoURL.Visible := true

	;Obtener metadatos
	title_command := Format("yt-dlp --print filename --output {1}%(title)s{2} {1}{3}{2} --restrict-filenames > {1}{4}{2}", '"', '"', URL, title_path)
	RunWait A_ComSpec " /c " title_command, libraries_dir, "Hide"
	global url_title := FileRead(title_path)

	;Mostrar metadatos
	ControlSetText url_title, outputTitulo.hwnd
	botonAnalizarURL.Visible := true
	botonAnalizandoURL.Visible := false

	;Mostrar controles
	seccionDescarga.Visible := true
	opcionDescarga.Visible := true
}
ShowControls(*) {
	global download_option := opcionDescarga.Text
	if (download_option = "Video + Audio" || download_option  = "Sólo video") {
		seccionResolucion.Visible := true
		videoResolucion.Visible := true
		seccionFormatoV.Visible := true
		videoFormato.Visible := true
		seccionFormatoA.Visible := false
		audioFormato.Visible := false
	} else {
		seccionResolucion.Visible := false
		videoResolucion.Visible := false
		seccionFormatoV.Visible := false
		videoFormato.Visible := false
		seccionFormatoA.Visible := true
		audioFormato.Visible := true
	}
}
ChooseFormat(*) {
	;Comprobar que se ha seleccionado un formato y Asignarlo a la descarga
	switch download_option {
		case "Video + Audio":
			global download_format := videoFormato.Text
		case "Sólo video":
			global download_format := videoFormato.Text
		default:
			global download_format := audioFormato.Text
	}

	;Permitir y mostrar que se ha cambiado el formato, pero la ubicación de guardado es la misma
	if download_path != "" {
		quickVF_GUI.SetFont("s9 w400 c000000", "Open Sans")
		ControlSetText download_path "." download_format, inputUbicacion.hwnd
	}

	inputUbicacion.Visible := true
	botonUbicacion.Visible := true
}
ChoosePath(*) {
	;Seleccionar una ubicación de descarga
	global download_path := FileSelect("S10", SubStr(url_title, 1, 16), "Guardar como", Format("Multimedia (*.{1})", download_format))
	if download_path = "" {
		MsgBox "Es necesario seleccionar una carpeta donde se guardarán los archivos descargados", "Quick Video Fetcher", "Iconx"
		return
	}

	quickVF_GUI.SetFont("s9 w400 c000000", "Open Sans")
	ControlSetText download_path "." download_format, inputUbicacion.hwnd
	aclaracionDescarga.Visible := true
	botonDescargarURL.Visible := true
}
DownloadURL(*) {
	ControlsDisabled()

	;Concatenar formato y resolución (si aplica) en el comando de Descarga
	if (download_option = "Video + Audio" || download_option = "Sólo video") && (videoResolucion.Text = "") {
		MsgBox "Es necesario elegir una resolución para el video", "Quick Video Fetcher", "Iconx"
		ControlsEnabled()
		return
	}
	switch download_option {
		case "Video + Audio":
			download_resolution := RegExReplace(videoResolucion.Text, "[^\d]*(\d+).*", "$1")
			global download_arguments := Format("--format {1}bv*[height={2}]*[ext={3}]+ba/bv*[height={2}]+ba/bv*+ba/b[height<={2}]/b/w{1}", '"', download_resolution, download_format)
		case "Sólo video":
			download_resolution := RegExReplace(videoResolucion.Text, "[^\d]*(\d+).*", "$1")
			global download_arguments := Format("--format {1}bv*[height={2}]*[ext={3}]/bv*[height<={2}]/bv/wv/b/w{1}", '"', download_resolution, download_format)
		default:
			global download_arguments := Format("--format {1}ba*[ext={2}]/ba/wa/b/w{1}", '"', download_format)
	}

	cmd_command := Format("yt-dlp {2} --output {1}{3}.%(ext)s{1} {1}{4}{1}", '"', download_arguments, download_path, URL)
	HideTrayTip()
	TrayTip "Se inició con la descarga de archivos ^_^", "Quick Video Fetcher", "Iconi"
	RunWait A_ComSpec " /c " cmd_command, libraries_dir, "Hide"

	;Verificar que el tipo de descarga es correcto
	if FileExist(check_dl_option)
		FileDelete check_dl_option
	switch download_option {
		case "Sólo video":
			option_command := Format("ffprobe -i {1}{2}.{3}{1} -show_streams -select_streams a -loglevel error > {1}{4}{1}", '"', download_path, download_format, check_dl_option)
			RunWait A_ComSpec " /c " option_command, libraries_dir, "Hide"
		case "Sólo audio":
			option_command := Format("ffprobe -i {1}{2}.{3}{1} -show_streams -select_streams v -loglevel error > {1}{4}{1}", '"', download_path, download_format, check_dl_option)
			RunWait A_ComSpec " /c " option_command, libraries_dir, "Hide"
		default:
			FileAppend "", check_dl_option
	}

	;Encontrar archivo con configuración incorrecta
        global dl_folder := RegExReplace(download_path, "^(.*\\).*$", "$1")
        global dl_file := RegExReplace(download_path, ".*\\(.*)$", "$1")
        Loop Files, Format("{1}{2}.*", dl_folder, dl_file)
            global input_file_path := A_LoopFilePath

	;Redireccionar si el formato es incorrecto o no se encuentra el archivo
	if (FileRead(check_dl_option) = "") {
		if FileExist(download_path "." download_format) {
			ControlsEnabled()
			HideTrayTip()
			TrayTip "Tus archivos están listos :D", "Quick Video Fetcher", "Iconi"
			Run dl_folder
			return
		} else {
			Return ConvertURL()
		}
	} else {
		Return ConvertURL()
	}
}
ConvertURL(*) {
	;Preguntar para continuar con la Conversión
	executeConversion := MsgBox("No pudimos descargar tu archivo en el formato indicado (" download_format ") ¿Te gustaría que realicemos la conversión? Todo el proceso se hace de manera local, sin internet, por lo que el tiempo dependerá de la potencia de tu computadora.", "Quick Video Fetcher", 36)
    if executeConversion = "Yes" {
        HideTrayTip()
        TrayTip "Estamos convirtiendo tus archivos. Esto puede tomar entre unos pocos segundos hasta minutos según la potencia de tu computadora.", "Quick Video Fetcher", "Iconi"

        ;Agregar rectificación de Opciones de Descarga
        switch download_option {
            ;Configurar códecs de video
            case "Sólo video":
                switch download_format {
                    case "webm":
                        codec := "libvpx-vp9"
                    default:
                        codec := "libopenh264"
                }
                conversion_arguments := " -c:v " codec " -an "

            ;Configurar códecs de audio
            case "Sólo audio":
                switch download_format {
                    case "m4a":
                        codec := "aac"
                    case "aac":
                        codec := "aac"
                    case "mp3":
                        codec := "mp3"
                    case "ogg":
                        codec := "libvorbis"
                    case "opus":
                        codec := "libopus"
                    case "webm":
                        codec := "libvorbis"
                    default:
                        codec := "copy"
                }
                conversion_arguments := " -c:a " codec " -vn "

            ;Configurar códecs por defecto
            default:
                conversion_arguments := " "
        }

        ;Realizar conversión de formatos
        if download_option = "Sólo audio"
            file_suffix := "audio"
        else if download_option = "Sólo video"
            file_suffix := "video"
        else
            file_suffix := "mix"
        output_file_command := Format("ffmpeg -i {1}{2}{1}{3}{1}{4}_{5}.{6}{1}", '"', input_file_path, conversion_arguments, download_path, file_suffix, download_format)
        RunWait A_ComSpec " /c " output_file_command, libraries_dir, "Hide"
        HideTrayTip()
        ControlsEnabled()

        ;Mostrar mensajes finales
        if FileExist(download_path "_" file_suffix "." download_format) {
            FileDelete input_file_path
            HideTrayTip()
            TrayTip "Tus archivos están listos :D", "Quick Video Fetcher", "Iconi"
			Run dl_folder
        } else {
            HideTrayTip()
            TrayTip "Ocurrió un error con ffmpeg y no fue posible convertir tu archivo al formato solicitado :(", "Quick Video Fetcher", "Iconx"
        }
    } else {
		ControlsEnabled()
        HideTrayTip()
        TrayTip "Tus archivos están listos :D", "Quick Video Fetcher", "Iconi"
		Run dl_folder
    }
}