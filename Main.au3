#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	�������� ������ ���

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
#AutoIt3Wrapper_Res_LegalCopyright=Copyright � 2014 B.Zharkov, bzharkov@moscowpost.ru. All rights reserved.
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
; ���������� � ��������� �����
; ��������� ���������� � ��������� ���������
; ��������� ����������. ����� ���������� ������ ���������� ��������� ���������������� � include ������� � �������������� ���������� � ��������������� �������� ��� (/om)
; �������� ���������������� ����� ����������
#EndRegion

#include <GlobalConfig.au3>
#include <Array.au3>
#include <File.au3>
#include <SelectFile.au3>
#include <SplashMsg.au3>
#include <InfoMsg.au3>
#include <Log.au3>
#include <Sender.au3>

; ��������� �� ������� �� ��� ������
If WinExists($sVersion) Then Exit
AutoItWinSetTitle($sVersion)

; �������������� ����
$hInfo = InfoMsg("���������, �����...")

; ���� ������ �� ��������, �� ����������� ������
If Not Ping($sSmtpServer, $iPingTimeout) Then
	GUIDelete($hInfo)
	SplashMsg(0, "��� ����� � ��������!", 3000)
	writeLog("������", "��� ����� � ��������")
	Exit
EndIf

; ���� ����� �� �������� �� �����,
If $aFilesNames = 0 Then
	GUIDelete($hInfo)
	; �������� �������� �� 3 �������, ���������� � ��� � ��������� ���������.
	SplashMsg(0, "��� ������ ��� ��������!", 3000)
	writeLog("������", "����� �� �������� �� �������")
	Exit
Else
	; �����, �������� ������ ���� �� ������
	$aFullRootFiles = GetFullFileRoot($sFileLoad, $aFilesNames)
	; ��� �����
	$sFiles = _ArrayToString($aFilesNames, ", ")
EndIf

; ���������� ������
$sMailStatus = _SendMail($sSmtpServer, $sFromName, $sFromAddress, $sToAddress, $sSubject, $sBody, $aFullRootFiles, $sCopyAddress, $sHideAddress, $sImportance, $sUsername, $sPassword, $iPort, $iSsl)

; ������� ��������� � ������������ � ����� � ���
If @error Then
	SplashMsg(0, "������ �������� � ���!", 3000)
	writeLog($sFiles, "�� ����������")
	writeLog("������", $sMailStatus)
	Exit
Else
	SplashMsg(1, "�������� ���������!")
	writeLog($sFiles, "����������")
	RemoteFile()
EndIf


Func RemoteFile()
	; ��������� ����� � �����

	If Not FileExists($sFileArchiv) Then
		If Not DirCreate($sFileArchiv) Then
			writeLog("������", "�� ���� ������� ����� ��� ������.")
		EndIf
	EndIf

	;$aFiles = FileToArray($sFileFullRoot)

	If $aFullRootFiles = 0 Then
		writeLog("������", "���� ������ ��� ����������� � �����.")

	Else
		For $sFileName In $aFilesNames
			FileMove($sFileLoad & $sFileName, $sFileArchiv & $sFileName, 1)
		Next
	EndIf
EndFunc

