#include-once
#include "OCRSpaceUDF\_OCRSpace_UDF.au3"


; The only mandatory parameter!
Global Const $OCRSPACEAPIKEY = ""

$i_OCR_Engine = Default               ; Default = 1
$b_Table_Logic = False                ; Default = False
$b_Detect_Orientation = False         ; Default = False
$s_Language = "eng"                   ; Valid Lang ISO 639-2 Code. Default = "eng"
$b_Overlay_Info = False               ; Return array ? Default = False
$b_ImageAutoScale = False             ; Auto scale the image ? Default = False

$b_Create_Searchable_PDF = False      ; Default = False
$b_SearchablePdfHideTextLayer = Default      ; PDF Options only make sense if a Searchable PDF was requested at $b_Create_Searchable_PDF


$a_lOCROptions = _OCRSpace_SetUpOCR( _
		$OCRSPACEAPIKEY, _
		$i_OCR_Engine, _
		$b_Table_Logic, _
		$b_Detect_Orientation, _
		$s_Language, _
		$b_Overlay_Info, _
		$b_ImageAutoScale, _
		$b_SearchablePdfHideTextLayer, _
		$b_Create_Searchable_PDF)

; Scan an Image from Imgur: https://i.imgur.com/eCuYtDe.png
$s_lText_Detected = _OCRSpace_ImageGetText($a_lOCROptions, "https://i.imgur.com/eCuYtDe.png", 0, "MyPDFURL")

; A searchable PDF was not requested above [$b_Create_Searchable_PDF = false] so a PDF link
; will result : "Searchable PDF not generated as it was not requested."
ConsoleWrite( _
		" Detected text       : " & $s_lText_Detected & @CRLF & _
		" Error Returned      : " & @error & @CRLF & _
		" Searchable PDF link : " & Eval("MyPDFURL") & @CRLF)
Exit