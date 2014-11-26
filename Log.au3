#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	Логирование

#ce ----------------------------------------------------------------------------

#include-once
#include <File.au3>
#include <Date.au3>
#include <GlobalConfig.au3>

Func createLog()
	; Создает Лог-Файл
	createDir()
	If _FileCreate($sLogFile) = 1 Then
		Return 1
	Else
		FileWrite($sSenderError, 'Ошибка создания файла' & $sLogFile)
		Return 0
	EndIf
EndFunc


Func createDir()
	; Создает директорию для файлов
	If Not FileExists($sLogDir) Then
		If DirCreate($sLogDir) Then
			Return 1
		Else
			FileWrite($sSenderError, 'Ошибка создания директории' & $sLogDir)
			Return 0
		EndIf
	EndIf
	Return 1
EndFunc


Func reCreateLog()
	; Создает новый лог-файл, перемещает старый в архив и добавляет в название дату перемещения,
	; если в лог-файле больше $LogNumString строк
	Local $sNameMoveLog = "Log_" & logDateFormat() & ".txt"
	Local $sFullMoveRoot = $sLogDirArchiv & $sNameMoveLog
	If FileMove($sLogFile, $sFullMoveRoot, 8) Then
		createLog()
	Else
		FileWrite($sSenderError, 'Ошибка перемещения файла')
	EndIf
EndFunc


Func logDateFormat()
	; Возврящает текущую дату в формате YY-MM-DD HH-MM-SS
	Return @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & "-" & @MIN & "-" & @SEC
EndFunc


Func writeLog($sText, $sStatus)
	; Пишет в лог-файл

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