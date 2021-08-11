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
	
	; THE ONLY MANDATORY PARAMETER!
	$s_OCR_APIKEY = ""
	
	$i_OCR_Engine = Default         ; Default is Engine 1

	; Use a table logic for receipt OCR ?
	$b_Table_Logic = False          ; Default is False

	$b_Detect_Orientation = False   ; Default is False

	; Create a Searchable PDF ? If true, you'll need to evaluate it.
	; You can set a custom evaluation text at the last parameter of _OCRSpace_ImageGetText() [$sURLVar]
	; The default evaluation text/string is "__OCRSPACE_SEARCHABLE_PDFLINK"
	$b_Create_Searchable_PDF = False

	; Should be a valid ISO 639-2 Code, 3 characters. See supported languages @ _OCRSpace_SetUpOCR() function header.
	$s_Language = "eng"

	; if true, we can do an _ArrayDisplay() or play with the returned array..
	$b_Overlay_Info = False

	; auto scale the image?
	$b_ImageAutoScale = False

	; hide the text layer on the searchable PDf? (Default is False).
	; At this stage this option is irrelevant since we are not requesting a searchable PDF.
	$b_SearchablePdfHideTextLayer = Default

	$OCROptions = _OCRSpace_SetUpOCR($s_OCR_APIKEY, $i_OCR_Engine, $b_Table_Logic, $b_Detect_Orientation, $s_Language, $b_Overlay_Info, $b_ImageAutoScale, $b_SearchablePdfHideTextLayer, $b_Create_Searchable_PDF)

	; Make the request with return type set to 0 to get a text only.. (1 gets an array instead.)
	$Text_Detected = _OCRSpace_ImageGetText($OCROptions, "https://i.imgur.com/eCuYtDe.png", 0, "MyPDFURL")

	; Display the result.. Possible data types are a String and 2D array. All depends on integer set at _OCRSpace_ImageGetText() [$iReturnType]
	Switch VarGetType($Text_Detected)
		
		Case "array" ; i.e $iReturnType at _OCRSpace_ImageGetText() is set to 1

			; Setting $iReturnType to 1 AND $b_Overlay_Info to True returns a 2D array containing the coordinates
			; of the bounding boxes for each word detected, in the format : #WordDetected , #Left , #Top , #Height, #Width
			_ArrayDisplay($Text_Detected, "@Error : " & @error)

		Case Else    ; i.e $iReturnType at _OCRSpace_ImageGetText() is set to 0 [DEFAULT]

			; For this request, a searchable PDF was not requested in _OCRSpace_SetUpOCR() [$b_Create_Searchable_PDF = false]
			; so when evaluating the default evaluation string, the message will be "Searchable PDF not generated as it was not requested."
			ConsoleWrite( _
					" Detected text       : " & $Text_Detected & @CRLF & _
					" Error Returned      : " & @error & @CRLF & _
					" Searchable PDF link : " & Eval((IsDeclared("MyPDFURL") = $DECLARED_GLOBAL) ? "MyPDFURL" : "__OCRSPACE_SEARCHABLE_PDFLINK") & @CRLF)
	EndSwitch

	Return
EndFunc   ;==>Example1


