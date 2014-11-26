#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	Выберает почтовые файлы по маске

#ce ----------------------------------------------------------------------------

#include-once
#include <File.au3>
#include <Array.au3>

Func FileToArray($fPath)
	; Проверяет файлы по маске и возвращает массив с именами найденных файлов,
	; либо 0, если файлы не найдены.

	Local $fDesc = FileFindFirstFile($fPath)
	Local $aReturnFiles[1]

	; Если файлов нет, выходим
	If $fDesc = -1 Then
		Return 0
	Else
		; Перебираем файлы
		While 1
			$sTmpFile = FileFindNextFile($fDesc)

			If $sTmpFile = "" Then
				ExitLoop
			Else
				If @error = 1 Then
					ContinueLoop
				EndIf
				; Добавляем в массив
				_ArrayAdd($aReturnFiles, $sTmpFile)
			EndIf
		WEnd
	EndIf
	; Удаляем первый(пустой) элемент массива
	_ArrayDelete($aReturnFiles, 0)
	Return $aReturnFiles
EndFunc


Func GetFullFileRoot($sDir, $aFiles)
	; Склеивает путь с массивом файлов

	Local $aReturnFiles[1]

	; Читаем полученный в функцию массив
	For $sFileName In $aFiles
		; Склеиваем путь и добавляем в локальный массив
		$sTmpRoot = $sDir & $sFileName
		_ArrayAdd($aReturnFiles, $sTmpRoot)
	Next

	; Удаляем первый(пустой) элемент массива
	_ArrayDelete($aReturnFiles, 0)
	Return $aReturnFiles
EndFunc