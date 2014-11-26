#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	�����������

#ce ----------------------------------------------------------------------------

#include-once
#include <File.au3>
#include <Date.au3>
#include <GlobalConfig.au3>

Func createLog()
	; ������� ���-����
	createDir()
	If _FileCreate($sLogFile) = 1 Then
		Return 1
	Else
		FileWrite($sSenderError, '������ �������� �����' & $sLogFile)
		Return 0
	EndIf
EndFunc


Func createDir()
	; ������� ���������� ��� ������
	If Not FileExists($sLogDir) Then
		If DirCreate($sLogDir) Then
			Return 1
		Else
			FileWrite($sSenderError, '������ �������� ����������' & $sLogDir)
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc


Func reCreateLog()
	; ������� ����� ���-����, ���������� ������ � ����� � ��������� � �������� ���� �����������,
	; ���� � ���-����� ������ $LogNumString �����
	Local $sNameMoveLog = "Log_" & logDateFormat() & ".txt"
	Local $sFullMoveRoot = $sLogDirArchiv & $sNameMoveLog
	If FileMove($sLogFile, $sFullMoveRoot, 8) Then
		createLog()
	Else
		FileWrite($sSenderError, '������ ����������� �����')
	EndIf
EndFunc


Func logDateFormat()
	; ���������� ������� ���� � ������� YY-MM-DD HH-MM-SS
	Return @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & "-" & @MIN & "-" & @SEC
EndFunc


Func writeLog($sText, $sStatus)
	; ����� � ���-����

	If Not FileExists($sLogFile) Then
		createLog()
	ElseIf _FileCountLines($sLogFile) >= $iLogNumString Then
		reCreateLog()
	EndIf

	Local $fOpenFile = FileOpen($sLogFile, 1)
	Local $iResult = ""

	If $fOpenFile > -1 Then
		Local $sMsgLog = $sText & " - " & $sStatus
		$iResult = _FileWriteLog($fOpenFile, $sMsgLog)
	EndIf

	FileClose($fOpenFile)
	Return $iResult
EndFunc