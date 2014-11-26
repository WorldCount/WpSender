#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	Глобальные настройки

#ce ----------------------------------------------------------------------------

#include-once
#include <SelectFile.au3>

Global Const $sVersion = "WP Sender 0.1.0.4"

; НАСТРОЙКИ
; Путь к ini-файлу
$sPath_ini = @ScriptDir & "\config.ini"

; Таймаут для проверки сервера в сети
Global Const $iPingTimeout = IniRead($sPath_ini, "Global", "ping", 1)
; Задерка информационного окна
Global Const $iDelay = IniRead($sPath_ini, "Global", "delay", 3000)

; Общее
$sWID = IniRead($sPath_ini, "Global", "wid", "19000001")

; НАСТРОЙКИ расположения файлов РПО
Global Const $sFileLoad = IniRead($sPath_ini, "Global", "rpo_dir", "C:\rpo\")
; Архив с файлами выборки
Global Const $sFileArchiv = IniRead($sPath_ini, "Global", "rpo_temp_dir", "C:\rpo_tmp_wp\")
; Маска для выбора файла
Global Const $sFileMask = "*.*F"
; Полный путь с маской к файлам
Global Const $sFileFullRoot = $sFileLoad & $sFileMask
; Имена найденных файлов для отправки
Global Const $aFilesNames = FileToArray($sFileFullRoot)

; НАСТРОКИ Log.au3
; Ошибки сендера
Global Const $sSenderError = @ScriptDir & '/error.txt'
; Расположение лог-файла
Global Const $sLogDir = @ScriptDir & "/Logs/"
; Имя лог-файла
$sLogName = "Log.txt"
; Полный путь к лог-файлу
Global Const $sLogFile = $sLogDir & $sLogName
; Имя папки с архивами лог-файлов
Global Const $sLogDirArchiv = @ScriptDir & "/Logs_Archive/"
; Количество строк в лог-файле перед его перемещением в архив
$iLogNumString = 500

; НАСТРОЙКИ Sender.au3
; СЕРВЕР
; Адрес сервера
$sSmtpServer = IniRead($sPath_ini, "Server", "smtp_server", "smtp.yandex.ru")
; Имя пользователя для авторизации на сервере
$sUsername = IniRead($sPath_ini, "Server", "username", "test-mmp3@yandex.ru")
; Пароль пользователя для авторизации на сервере
$sPassword = IniRead($sPath_ini, "Server", "password", "20102011")
; Через какой порт слать письмо
$iPort = IniRead($sPath_ini, "Server", "port", 25)
; Безопасность: 0 - выкл, 1 - вкл
$iSsl = IniRead($sPath_ini, "Server", "ssl", 0)

; EMAIL
; От кого, имя
$sFromName = $sWID & "@moscowpost.ru"
; От кого, адрес
$sFromAddress = $sFromName
; Кому, оригинал
$sToAddress = IniRead($sPath_ini, "Email", "address_to", "")
; Копия, адрес
$sCopyAddress = IniRead($sPath_ini, "Email", "address_copy", "")
; Скрытая копия
$sHideAddress = ""
; Тема письма
$sSubject = $sWID & " winpost"
; Тело письма
$sBody = "Сообщение отправлено в " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MDAY & "." & @MON & "." & @YEAR & @CRLF
$sBody &= "Окно: " & $sWID & @CRLF
$sBody &= "_________________________________________________________________" & @CRLF
$sBody &= "IP адрес: " & @IPAddress1 & "; " & @IPAddress2 & "; " & @IPAddress3 & "; " & @IPAddress4 & @CRLF
$sBody &= "Пользователем: " & @UserName & @CRLF
$sBody &= "Имя компьютера: " & @ComputerName & @CRLF
$sBody &= "Софт: " & $sVersion & @CRLF
; Приоритет "High", "Normal", "Low"
$sImportance = IniRead($sPath_ini, "Email", "importance", "Normal")
