#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	Отправка файлов РПО

#ce ----------------------------------------------------------------------------

#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=winpost.ico
#AutoIt3Wrapper_Outfile=WPSender.exe
#AutoIt3Wrapper_Res_File_Add=Sound\error.wav, WAVE, ERROR
#AutoIt3Wrapper_Res_File_Add=Sound\ok.wav, WAVE, OK
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Comment=by B.Zharkov
#AutoIt3Wrapper_Res_Description=WP Sender
#AutoIt3Wrapper_Res_Fileversion=0.1.0.4
#AutoIt3Wrapper_Res_ProductVersion=0.1.0.4
#AutoIt3Wrapper_Res_LegalCopyright=Copyright © 2014 B.Zharkov, bzharkov@moscowpost.ru. All rights reserved.
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Language=1049
#AutoIt3Wrapper_Res_Field=Version|0.1
#AutoIt3Wrapper_Res_Field=Build|2014.10.22
#AutoIt3Wrapper_Res_Field=OriginalFilename|WPSender.exe
#AutoIt3Wrapper_Res_Field=ProductName|WpSender
#AutoIt3Wrapper_Res_Field=Coded by|B.Zharkov
#AutoIt3Wrapper_Res_Field=CompanyName|MMP3
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region
; информация в свойствах файла
; Разрешаем обфускацию и указываем параметры
; Параметры обфускации. Самый компактный скрипт получается удалением неиспользованных в include функций и переименование переменных в сгенерированное короткое имя (/om)
; удаление сгенерированного файла обфускации
#EndRegion

#include <GlobalConfig.au3>
#include <Array.au3>
#include <File.au3>
#include <SelectFile.au3>
#include <SplashMsg.au3>
#include <InfoMsg.au3>
#include <Log.au3>
#include <Sender.au3>

; Проверяем не запущен ли уже сендер
If WinExists($sVersion) Then Exit
AutoItWinSetTitle($sVersion)

; Информационное окно
$hInfo = InfoMsg("Отправляю, ждите...")

; Если сервер не доступен, то заканчиваем работу
If Not Ping($sSmtpServer, $iPingTimeout) Then
	GUIDelete($hInfo)
	SplashMsg(0, "Нет связи с сервером!", 3000)
	writeLog("Ошибка", "нет связи с сервером")
	Exit
EndIf

; Если файлы на отправку не нашли,
If $aFilesNames = 0 Then
	GUIDelete($hInfo)
	; вызываем заставку на 3 секунды, записываем в лог и завершаем программу.
	SplashMsg(0, "Нет файлов для отправки!", 3000)
	writeLog("Ошибка", "файлы на отправку не найдены")
	Exit
Else
	; Иначе, получаем полный путь до файлов
	$aFullRootFiles = GetFullFileRoot($sFileLoad, $aFilesNames)
	; Для логов
	$sFiles = _ArrayToString($aFilesNames, ", ")
EndIf

; Отправляем письмо
$sMailStatus = _SendMail($sSmtpServer, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $aFullRootFiles, $sCopyAddress, $sHideAddress, $sImportance, $sUsername, $sPassword, $iPort, $iSsl)

; Выводим сообщение с результатами и пишем в лог
If @error Then
	SplashMsg(0, "Ошибка отправки в ММП!", 3000)
	writeLog($sFiles, "не отправлены")
	writeLog("Ошибка", $sMailStatus)
	Exit
Else
	SplashMsg(1, "Отправка завершена!")
	writeLog($sFiles, "отправлены")
	RemoteFile()
EndIf


Func RemoteFile()
	; Переносит файлы в архив

	If Not FileExists($sFileArchiv) Then
		If Not DirCreate($sFileArchiv) Then
			writeLog("Ошибка", "Не могу создать папку для архива.")
		EndIf
	EndIf

	;$aFiles = FileToArray($sFileFullRoot)

	If $aFullRootFiles = 0 Then
		writeLog("Ошибка", "Нету файлов для перемещения в архив.")

	Else
		For $sFileName In $aFilesNames
			FileMove($sFileLoad & $sFileName, $sFileArchiv & $sFileName, 1)
		Next
	EndIf
EndFunc

