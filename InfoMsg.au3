#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	���� ����� ���������

#ce ----------------------------------------------------------------------------

#include-once
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

Func InfoMsg($sMessage="������������ ������� ��������")
	; ��������� ����� ��������

	; ������� ����
    Local $hGUI = GUICreate('', 330, 60, -1, -1, BitOR($WS_POPUP, $WS_BORDER, $WS_EX_TOPMOST))

	; ������ ���� ������ ��� ��������� ����
	GUICtrlSetDefColor(0xFFFFFF)
	GUICtrlSetDefBkColor(0x00348a)

	; ��������� ���������
	GUICtrlCreateLabel($sMessage, 1, 1, 328, 58, BitOR($SS_CENTERIMAGE, $SS_CENTER))
	GUICtrlSetFont(-1, 14, 700)
	; ����������
    GUISetState(@SW_SHOW, $hGUI)
	; ������� ����

	Return $hGUI
EndFunc
