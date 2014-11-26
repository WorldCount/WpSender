#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.10.2
 Author:         B.Zharkov

 Script Function:
	����������� ������� ����

#ce ----------------------------------------------------------------------------

#include-once
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#Include <WinAPIEx.au3>
#Include <GUIConstantsEx.au3>

Func SplashMsg($iType = 3, $sMessage="������������ ������� ��������", $iSec=2000)
	; ��������� ����� ��������

	; ������� ����
    Local $hGUI = GUICreate('', 330, 60, -1, -1, BitOR($WS_POPUP, $WS_BORDER, $WS_EX_TOPMOST))

	; ������ ���� ������ ��� ��������� ����
	GUICtrlSetDefColor(0xFFFFFF)

	; �������� ����� ���� ���������:
	Select
		; ���� �� ������ ���������� �����
		Case $iType = 0
			GUICtrlSetDefBkColor(0x670001)
			$sSound = "ERROR"
		; ���� ������ ���������� �����
		Case $iType = 1
			GUICtrlSetDefBkColor(0x006600)
			$sSound = "OK"
		; ��-���������
		Case Else
			GUICtrlSetDefBkColor(0x00348a)
	EndSelect

	; ��������� ���������
	GUICtrlCreateLabel($sMessage, 1, 1, 328, 58, BitOR($SS_CENTERIMAGE, $SS_CENTER))
	GUICtrlSetFont(-1, 14, 700)
	; ����������
    GUISetState(@SW_SHOW, $hGUI)
	; ������������ �������
	 _WinAPI_PlaySound($sSound, $SND_RESOURCE, _WinAPI_GetModuleHandle(0))
	; ���� 2 ���, ������ �� ������
    Sleep($iSec)
	; ������� ����
    GUIDelete($hGUI)
EndFunc
