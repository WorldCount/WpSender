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
�������� ������
$sSmtpServer - ����� SMTP �������
$sFromName - �� ����, ���
$sFromAddress - �� ����, �����
$sToAddress - ����, �����
$sSubject - ��������� ������
$sBody - ���� ������
$aAttachFiles - ��������, ������ � ������� �������� �� �����
$sCopyAddress - �����, �����
$sHideAddress - ������� �����, �����
$sImportance - ��������� "High", "Normal", "Low"
$sUsername - ��� ������������ SMTP �������
$sPassword - ������ ������������ SMTP �������
$iPort - ���� SMTP �������
$iSsl - ���������� 0, 1
#ce
Func _SendMail($sSmtpServer, $sFromName, $sFromAddress, $sToAddress, $sSubject = "", $sBody = "", $aAttachFiles = "", $sCopyAddress = "", $sHideAddress = "", $sImportance = "Normal", $sUsername = "", $sPassword = "", $iPort = 25, $iSsl = 0)
	Local $oEmail = ObjCreate("CDO.Message")

	; ��������� ������ ������
	; �� ����, ���
	$oEmail.From = '"' & $sFromName & '" <' & $sFromAddress & '>'
	; �� ����, �����
	$oEmail.To = $sToAddress

	; ��������� � ��������� ����� ��� ������� �����, ���� ����
	If $sCopyAddress <> "" Then $oEmail.Cc = $sCopyAddress
	If $sHideAddress <> "" Then $oEmail.Bcc = $sHideAddress

	; ���� ������
	$oEmail.Subject = $sSubject

	; ���� ������, HTML ��� �����
	If StringInStr($sBody, "<") And StringInStr($sBody, ">") Then
		$oEmail.HTMLBody = $sBody
	Else
		$oEmail.TextBody = $sBody & @CRLF
	EndIf

	Local $iNumMissFiles = 0
	; ��������� ��������
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

	; ���� ���� �� ������, ������ 25
	If Number($iPort) = 0 Then $iPort = 25

	; ������������� ����
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $sSmtpServer
	$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $iPort
	; ����������� SMTP
	If $sUsername <> "" Then
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $sUsername
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $sPassword
	EndIf

	; ����������
	If $iSsl Then
		$oEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf

	; ��������� ���������
	$oEmail.Configuration.Fields.Update

	; ��������� ������
	Switch $sImportance
		Case "High"
			$oEmail.Fields.Item("urn:schemas:mailheader:Importance") = "High"
		Case "Normal"
			$oEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Normal"
		Case "Low"
			$oEmail.Fields.Item("urn:schemas:mailheader:Importance") = "Low"
	EndSwitch

	; ��������� ����
	$oEmail.Fields.Update

	If $iNumMissFiles = 0 Then
		; ���������� ������
		$oEmail.Send
	Else
		SetError(1)
		Return "��� ������� � " & $sMissFiles
	EndIf

	If @error Then
		SetError(2)
		Return $oRet[1]
	EndIf

	; ������� ����� ������
	$oEmail = ""
EndFunc

; ���������� ������
Func SenderError()
	$HexNumber = Hex($oSenderError.number, 8)
	$oRet[0] = $HexNumber
	$oRet[1] = $oSenderError.description
	;ConsoleWrite("### COM Error ! Number: " & $HexNumber & " ScriptLine: " & $oSenderError.scriptline & " Description:" & $oRet[1] & @LF)
	SetError(1)
	Return
EndFunc