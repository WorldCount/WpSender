#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	�������� �������� ����� �� �����

#ce ----------------------------------------------------------------------------

#include-once
#include <File.au3>
#include <Array.au3>

Func FileToArray($fPath)
	; ��������� ����� �� ����� � ���������� ������ � ������� ��������� ������,
	; ���� 0, ���� ����� �� �������.

	Local $fDesc = FileFindFirstFile($fPath)
	Local $aReturnFiles[1]

	; ���� ������ ���, �������
	If $fDesc = -1 Then
		Return 0
	Else
		; ���������� �����
		While 1
			$sTmpFile = FileFindNextFile($fDesc)

			If $sTmpFile = "" Then
				ExitLoop
			Else
				If @error = 1 Then
					ContinueLoop
				EndIf
				; ��������� � ������
				_ArrayAdd($aReturnFiles, $sTmpFile)
			EndIf
		WEnd
	EndIf
	; ������� ������(������) ������� �������
	_ArrayDelete($aReturnFiles, 0)
	Return $aReturnFiles
EndFunc


Func GetFullFileRoot($sDir, $aFiles)
	; ��������� ���� � �������� ������

	Local $aReturnFiles[1]

	; ������ ���������� � ������� ������
	For $sFileName In $aFiles
		; ��������� ���� � ��������� � ��������� ������
		$sTmpRoot = $sDir & $sFileName
		_ArrayAdd($aReturnFiles, $sTmpRoot)
	Next

	; ������� ������(������) ������� �������
	_ArrayDelete($aReturnFiles, 0)
	Return $aReturnFiles
EndFunc