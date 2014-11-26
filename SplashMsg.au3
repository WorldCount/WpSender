#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	Всплывающее цветное окно

#ce ----------------------------------------------------------------------------

#include-once
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#Include <WinAPIEx.au3>
#Include <GUIConstantsEx.au3>

Func SplashMsg($iType = 3, $sMessage="Тестирование системы отправки", $iSec=2000)
	; Сообщение после отправки

	; Создаем окно
    Local $hGUI = GUICreate('', 330, 60, -1, -1, BitOR($WS_POPUP, $WS_BORDER, $WS_EX_TOPMOST))

	; Задаем цвет текста для элементов окна
	GUICtrlSetDefColor(0xFFFFFF)

	; Настрока цвета фона сообщения:
	Select
		; Если не удачно отправлена почта
		Case $iType = 0
			GUICtrlSetDefBkColor(0x670001)
			$sSound = "ERROR"
		; Если удачно отправлена почта
		Case $iType = 1
			GUICtrlSetDefBkColor(0x006600)
			$sSound = "OK"
		; По-умолчанию
		Case Else
			GUICtrlSetDefBkColor(0x00348a)
	EndSelect

	; Добавляем сообщение
	GUICtrlCreateLabel($sMessage, 1, 1, 328, 58, BitOR($SS_CENTERIMAGE, $SS_CENTER))
	GUICtrlSetFont(-1, 14, 700)
	; Отображаем
    GUISetState(@SW_SHOW, $hGUI)
	; Проиграываем мелодию
	 _WinAPI_PlaySound($sSound, $SND_RESOURCE, _WinAPI_GetModuleHandle(0))
	; Ждем 2 сек, защита от слепых
    Sleep($iSec)
	; Удаляем окно
    GUIDelete($hGUI)
EndFunc
