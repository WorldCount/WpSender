#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	Окно перед отправкой

#ce ----------------------------------------------------------------------------

#include-once
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

Func InfoMsg($sMessage="Тестирование системы отправки")
	; Сообщение после отправки

	; Создаем окно
    Local $hGUI = GUICreate('', 330, 60, -1, -1, BitOR($WS_POPUP, $WS_BORDER, $WS_EX_TOPMOST))

	; Задаем цвет текста для элементов окна
	GUICtrlSetDefColor(0xFFFFFF)
	GUICtrlSetDefBkColor(0x00348a)

	; Добавляем сообщение
	GUICtrlCreateLabel($sMessage, 1, 1, 328, 58, BitOR($SS_CENTERIMAGE, $SS_CENTER))
	GUICtrlSetFont(-1, 14, 700)
	; Отображаем
    GUISetState(@SW_SHOW, $hGUI)
	; Удаляем окно

	Return $hGUI
EndFunc
