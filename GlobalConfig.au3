#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	���������� ���������

#ce ----------------------------------------------------------------------------

#include-once
#include <SelectFile.au3>

Global Const $sVersion = "WP Sender 0.1.0.4"

; ���������
; ���� � ini-�����
$sPath_ini = @ScriptDir & "\config.ini"

; ������� ��� �������� ������� � ����
Global Const $iPingTimeout = IniRead($sPath_ini, "Global", "ping", 1)
; ������� ��������������� ����
Global Const $iDelay = IniRead($sPath_ini, "Global", "delay", 3000)

; �����
$sWID = IniRead($sPath_ini, "Global", "wid", "19000001")

; ��������� ������������ ������ ���
Global Const $sFileLoad = IniRead($sPath_ini, "Global", "rpo_dir", "C:\rpo\")
; ����� � ������� �������
Global Const $sFileArchiv = IniRead($sPath_ini, "Global", "rpo_temp_dir", "C:\rpo_tmp_wp\")
; ����� ��� ������ �����
Global Const $sFileMask = "*.*F"
; ������ ���� � ������ � ������
Global Const $sFileFullRoot = $sFileLoad & $sFileMask
; ����� ��������� ������ ��� ��������
Global Const $aFilesNames = FileToArray($sFileFullRoot)

; �������� Log.au3
; ������ �������
Global Const $sSenderError = @ScriptDir & '/error.txt'
; ������������ ���-�����
Global Const $sLogDir = @ScriptDir & "/Logs/"
; ��� ���-�����
$sLogName = "Log.txt"
; ������ ���� � ���-�����
Global Const $sLogFile = $sLogDir & $sLogName
; ��� ����� � �������� ���-������
Global Const $sLogDirArchiv = @ScriptDir & "/Logs_Archive/"
; ���������� ����� � ���-����� ����� ��� ������������ � �����
$iLogNumString = 500

; ��������� Sender.au3
; ������
; ����� �������
$sSmtpServer = IniRead($sPath_ini, "Server", "smtp_server", "smtp.yandex.ru")
; ��� ������������ ��� ����������� �� �������
$sUsername = IniRead($sPath_ini, "Server", "username", "test-mmp3@yandex.ru")
; ������ ������������ ��� ����������� �� �������
$sPassword = IniRead($sPath_ini, "Server", "password", "20102011")
; ����� ����� ���� ����� ������
$iPort = IniRead($sPath_ini, "Server", "port", 25)
; ������������: 0 - ����, 1 - ���
$iSsl = IniRead($sPath_ini, "Server", "ssl", 0)

; EMAIL
; �� ����, ���
$sFromName = $sWID & "@moscowpost.ru"
; �� ����, �����
$sFromAddress = $sFromName
; ����, ��������
$sToAddress = IniRead($sPath_ini, "Email", "address_to", "")
; �����, �����
$sCopyAddress = IniRead($sPath_ini, "Email", "address_copy", "")
; ������� �����
$sHideAddress = ""
; ���� ������
$sSubject = $sWID & " winpost"
; ���� ������
$sBody = "��������� ���������� � " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MDAY & "." & @MON & "." & @YEAR & @CRLF
$sBody &= "����: " & $sWID & @CRLF
$sBody &= "_________________________________________________________________" & @CRLF
$sBody &= "IP �����: " & @IPAddress1 & "; " & @IPAddress2 & "; " & @IPAddress3 & "; " & @IPAddress4 & @CRLF
$sBody &= "�������������: " & @UserName & @CRLF
$sBody &= "��� ����������: " & @ComputerName & @CRLF
$sBody &= "����: " & $sVersion & @CRLF
; ��������� "High", "Normal", "Low"
$sImportance = IniRead($sPath_ini, "Email", "importance", "Normal")
