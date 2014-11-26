#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

#include <WinAPIFiles.au3>

Global $oRet[2]
Global $sMissFiles = ""
Global $sSendFiles = ""
Global $oSenderError = ObjEvent("AutoIt.Error", "SenderError")


#cs
ОТПРАВКА ПИСЬМА
$sSmtpServer - Адрес SMTP Сервера
$sFromName - От кого, имя
$sFromAddress - От кого, адрес
$sToAddress - Кому, адрес
$sSubject - Заголовок пиьсма
$sBody - Тело письма
$aAttachFiles - Вложения, массив с полными ссылками на файлы
$sCopyAddress - Копия, адрес
$sHideAddress - Скрытая копия, адрес
$sImportance - Приоритет "High", "Normal", "Low"
$sUsername - Имя пользователя SMTP сервера
$sPassword - Пароль пользователя SMTP сервера
$iPort - Порт SMTP сервера
$iSsl - Шифрование 0, 1
#ce
Func _SendMail($sSmtpServer, $sFromName, $sFromAddress, $sToAddress, $sSubject = "", $sBody = "", $aAttachFiles = "", $sCopyAddress = "", $sHideAddress = "", $sImportance = "Normal", $sUsername = "", $sPassword = "", $iPort = 25, $iSsl = 0)
	Local $oEmail = ObjCreate("CDO.Message")

	; ФОРМИРУЕМ ОБЪЕКТ ПИСЬМА
	; От кого, имя
	$oEmail.From = '"' & $sFromName & '" <' & $sFromAddress & '>'
	; От кого, адрес
	$oEmail.To = $sToAddress

	; Добавляем к адресатам копии или скрытые копии, если есть
	If $sCopyAddress <> "" Then $oEmail.Cc = $sCopyAddress
	If $sHideAddress <> "" Then $oEmail.Bcc = $sHideAddress

	; Тема письма
	$oEmail.Subject = $sSubject

	; Тело письма, HTML или текст
	If StringInStr($sBody, "<") And StringInStr($sBody, ">") Then
		$oEmail.HTMLBody = $sBody
	Else
		$oEmail.TextBody = $sBody & @CRLF
	EndIf

	Local $iNumMissFiles = 0
	; Добавляем вложения
	If $aAttachFiles <> "" Then
		If IsArray($aAttachFiles) Then
			For $x = 0 To (UBound($aAttachFiles) - 1)
				;ConsoleWrite('@@ Debug(62) : $S_Files2Attach = ' & $aAttachFiles[$x] & @LF & '>Error code: ' & @error & @LF) ;### Debug Console
				If FileExists($aAttachFiles[$x]) Then
					If _WinAPI_FileInUse($aAttachFiles[$x]) = 0 Then
						$oEmail.AddAttachment($aAttachFiles[$x])
						$sSendFiles &= $aAttachFiles[$x] & "; "
					Else
						$sMissFiles &= $aAttachFiles[$x] & "; "
						$iNumMissFiles += 1
					EndIf
				Else
					;ConsoleWrite('!> File not found to attach: ' & $aAttachFiles[$x] & @LF)
					SetError(1)
					Return 0
				EndIf
			Next
		EndIf
	EndIf

	; Если порт не указан, ставим 25
	If Number($iPort) = 0 Then $iPort = 25

	; Конфигурируем поля
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $sSmtpServer
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $iPort
	; Авторизация SMTP
	If $sUsername <> "" Then
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $sUsername
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $sPassword
	EndIf

	; Шифрование
	If $iSsl Then
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf

	; Обновляем настройки
	$oEmail.Configuration.Fields.Update

	; Приоритет письма
	Switch $sImportance
		Case "High"
			$oEmail.Fields.Item("urn:schemas:mailheader:Importance") = "High"
		Case "Normal"
			$oEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Normal"
		Case "Low"
			$oEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Low"
	EndSwitch

	; Обновляем поля
	$oEmail.Fields.Update

	If $iNumMissFiles = 0 Then
		; Отправляем письмо
		$oEmail.Send
	Else
		SetError(1)
		Return "Нет доступа к " & $sMissFiles
	EndIf

	If @error Then
		SetError(2)
		Return $oRet[1]
	EndIf

	; Очищаем объкт письма
	$oEmail = ""
EndFunc

; Обработчик ошибок
Func SenderError()
	$HexNumber = Hex($oSenderError.number, 8)
	$oRet[0] = $HexNumber
	$oRet[1] = $oSenderError.description
	;ConsoleWrite("### COM Error ! Number: " & $HexNumber & " ScriptLine: " & $oSenderError.scriptline & " Description:" & $oRet[1] & @LF)
	SetError(1)
	Return
EndFunc