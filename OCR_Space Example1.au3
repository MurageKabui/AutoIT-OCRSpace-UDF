#include-once

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include "OCRSpaceUDF\_OCRSpace_UDF.au3"


Example1()
; Example2()

Exit


; =========================================================
; Example 1 : Gets text from a receipt file.
;           : Searchable PDF is requested and will be assigned to SEARCHABLE_URL
;           : Process it using a table logic.
;
; Defaults  :
; _OCRSpace_SetUpOCR( $s_APIKey, _
;                     $i_OCREngineID = 1, _
;                     $b_IsTable = False, _
;                     $b_DetectOrientation = True, _
;                     $s_LanguageISO = "eng", _
;                     $b_IsOverlayRequired = False, _
;                     $b_AutoScaleImage = False, _
;                     $b_IsSearchablePdfHideTextLayer = False, _
;                     $b_IsCreateSearchablePdf = False)
; =========================================================
Func Example1()

	; Getting text through a local file ref.

	; Create a Searchable PDF ? If true, you'll need to evaluate it.
	$b_Create_Searchable_PDF = True

	; Use a table logic for receipt OCR ?
	$b_Table = True

	; Set your key here.
	$v_OCRSpaceAPIKey = "1cd71a8e7688957"

	$OCROptions = _OCRSpace_SetUpOCR($v_OCRSpaceAPIKey, 1, $b_Table, True, "eng", True, Default, Default, $b_Create_Searchable_PDF)

	$sText_Detected = _OCRSpace_ImageGetText($OCROptions, "receipt.jpg", 0, "SEARCHABLE_URL")

	ConsoleWrite( _
			" Detected text   : " & $sText_Detected & @CRLF & _
			" Error Returned  : " & @error & @CRLF & _
			" PDF URL         : " & Eval("SEARCHABLE_URL") & @CRLF)

	Return MsgBox(4, "OCRSpaceUDF Output", $sText_Detected)
EndFunc   ;==>Example1


; =========================================================
; Example 2 : Gets text from a image by a url reference
;           : Searchable PDF is not requested.
;           : Processes it using a basic logic by default.
; 
; Defaults :
; _OCRSpace_SetUpOCR( $s_APIKey, _
;                     $i_OCREngineID = 1, _
;                     $b_IsTable = False, _
;                     $b_DetectOrientation = True, _
;                     $s_LanguageISO = "eng", _
;                     $b_IsOverlayRequired = False, _
;                     $b_AutoScaleImage = False, _
;                     $b_IsSearchablePdfHideTextLayer = False, _
;                     $b_IsCreateSearchablePdf = False)
; =========================================================
Func Example2()

	ConsoleWrite("Getting text through a url ref." & @CRLF)

	; Set your key here.
	$v_OCRSpaceAPIKey = ""

	$OCROptions = _OCRSpace_SetUpOCR($v_OCRSpaceAPIKey, 1, False, True, "eng", True, Default, Default, False)
	$sText_Detected = _OCRSpace_ImageGetText($OCROptions, "https://i.imgur.com/vbYXwJm.png", 0)

	ConsoleWrite( _
			" Detected text   : " & $sText_Detected & @CRLF & _
			" Error Returned  : " & @error & @CRLF)
	Return
Endfunc