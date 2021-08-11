; #include <array.au3>
#include-once
#include <ScreenCapture.au3>
#include "Json.au3"
#include <WinAPIConv.au3>
#include <WinAPIDiag.au3>
#include <array.au3>

; =========================================================
; Title ...............: _OCRSpace_UDF.au3
; Author ..............: Kabue Murage
; AutoIt Version ......: 3.3.14.5
; UDF Version .........: v1.3
; OCRSpace API Version : V3.50
; Language ............: English
; Description .........: Convert image to text using the OCRSpace API version 3.50
; Forums ..............: Mr.Km
; Contact .............: dennisk at zainahtech dot com
; Remarks .............: To view all documentation go to https://ocr.space/OCRAPI
; Resources ...........: https://ocr.space/OCRAPI
; =========================================================


; #CURRENT# =====================================================================================================================
; _OCRSpace_SetUpOCR
; _OCRSpace_ImageGetText
; ===============================================================================================================================


; #FUNCTION# ================================================================================================================================
; Name...........:  _OCRSpace_SetUpOCR()
; Author ........:  Kabue Murage
; Description ...:  Validates and Sets up the OCR settings in retrospect.
;
; Syntax.........:  _OCRSpace_SetUpOCR($s_APIKey , $i_OCREngineID = 1 , $b_IsTable = False, $b_DetectOrientation = True, $s_LanguageISO = "eng", $b_IsOverlayRequired = False, $b_AutoScaleImage = False, $b_IsSearchablePdfHideTextLayer = False)
;
; Parameters ....:
; $s_APIKey              - [Required] The key provided by OCRSpace. (http://eepurl.com/bOLOcf)
; $i_OCREngineID         - [Optional] The OCR Engine to use. Can either be 1 or 2 (DEFAULT : 1)
;               Features of OCR Engine 1:
;                        - Supports more languages (including Asian languages like Chinese, Japanese and Korean)
;                        - Faster.
;                        - Supports larger images.
;                        - Multi-Page TIFF scan support.
;               Features of OCR Engine 2:
;                        - Western Latin Character languages only (English, German, French,...)
;                        - Language auto-detect. It does not matter what OCR language you select, as long as it uses Latin characters
;                          Usually better at single number OCR, single character OCR and alphanumeric OCR in general
;                          (e. g. SUDOKO, Dot Matrix OCR, MRZ OCR, Single digit OCR, Missing 1st letter after OCR, ... )
;                        - Usually better at special characters OCR like @+-...
;                        - Usually better with rotated text (Forum: Detect image spam)
;                        - Image size limit 5000px width and 5000px height
;
; $b_IsTable             - [Optional] True or False (DEFAULT : False)
;                          If set to true, the OCR logic makes sure that the parsed text result is always returned line by line. This switch
;                          is recommended for table OCR, receipt OCR, invoice processing and all other type of input documents that have a table
;                          like structure.
;
; $b_DetectOrientation   - [Optional] True or False (DEFAULT : True)
;                          If set to true, the image is correctly rotated the TextOrientation parameter is
;                          returned in the JSON response. If the image is not rotated, then TextOrientation=0
;                          otherwise it is the degree of the rotation, e. g. "270".
;
; $s_LanguageISO         - [Optional] (DEFAULT : eng)
;                          Language used for OCR. If no language is specified, English eng is taken as default.
;                          IMPORTANT: The API uses an ISO 639-2 Code, so it's explictly limited to 3 characters, never less!
;               Engine 1:
;                          Arabic=ara, Bulgarian=bul, Chinese(Simplified)=chs, Chinese(Traditional)=cht, Croatian = hrv, Czech = cze
;                          Danish = dan, Dutch = dut, English = eng, Finnish = fin, French = fre, German = ger, Greek = gre, Hungarian = hun
;                          Korean = kor, Italian = ita, Japanese = jpn, Polish = pol ,Portuguese = por, Russian = rus, Slovenian = slv
;                          Spanish = spa, Swedish = swe, Turkish = tur
;               Engine 2:
;                         Engine2 has automatic Western language detection, so this value will be ignored.
;
; $b_IsOverlayRequired  - [Optional] Default = False.  If true, returns the coordinates of the bounding boxes for each word.
;                         If false, the OCR'ed text is returned only as a
;                         text block (THIS MAKES THE JSON REPONSE SMALLER). Overlay data can be used, for example, to show text over the image.
;
; $b_AutoScaleImage     - [Optional] True or False (DEFAULT : False)
;                         If set to true, the image is upscaled. This can improve the OCR result significantly,
;                         especially for low-resolution PDF scans. The API uses scale=false by default.
;
; $b_IsSearchablePdfHideTextLayer
;                       - [Optional] True or False (DEFAULT : False)
;                         If true, the text layer is hidden (not visible)
;
;
; Return values .: Success : Returns an array to use in _OCRSpace_ImageGetText @error set to 0.
;                : Failure : @error flag set to non zero on failure.
; Modified.......:
; Remarks .......:
; Related .......: _OCRSpace_ImageGetText()
; Link ..........:
; Example .......: 0
; ============================================================================================================================================
Func _OCRSpace_SetUpOCR($s_APIKey, $i_OCREngineID = 1, $b_IsTable = False, $b_DetectOrientation = True, $s_LanguageISO = "eng", $b_IsOverlayRequired = False, $b_AutoScaleImage = False, $b_IsSearchablePdfHideTextLayer = False, $b_IsCreateSearchablePdf = False)

	If ($s_APIKey = "") Then Return SetError(1, 0, -1)

	Local $a_lSetUp[9][2]

	$a_lSetUp[0][0] = "apikey" ; ! Required!
	$a_lSetUp[0][1] = $s_APIKey
	$a_lSetUp[1][0] = "detectOrientation"
	$a_lSetUp[1][1] = (IsBool($b_DetectOrientation) ? $b_DetectOrientation : False)
	$a_lSetUp[2][0] = "OCREngine"
	$a_lSetUp[2][1] = ((Int($i_OCREngineID) = 2) ? 2 : 1)
	$a_lSetUp[3][0] = "isOverlayRequired"
	$a_lSetUp[3][1] = (IsBool($b_IsOverlayRequired) ? $b_IsOverlayRequired : False)
	$a_lSetUp[4][0] = "language" ; ISO (632-B Lang Prefix), length 3 ..
	$a_lSetUp[4][1] = (((StringIsAlpha($s_LanguageISO) = 1) And (StringLen($s_LanguageISO) = 3)) ? $s_LanguageISO : "eng")
	$a_lSetUp[5][0] = "isCreateSearchablePdf"
	$a_lSetUp[5][1] = (IsBool($b_IsCreateSearchablePdf) ? $b_IsCreateSearchablePdf : False)
	$a_lSetUp[6][0] = "isSearchablePdfHideTextLayer"
	$a_lSetUp[6][1] = (IsBool($b_IsSearchablePdfHideTextLayer) ? $b_IsSearchablePdfHideTextLayer : False)
	$a_lSetUp[7][0] = "scale"
	$a_lSetUp[7][1] = (IsBool($b_AutoScaleImage) ? $b_AutoScaleImage : False)
	$a_lSetUp[8][0] = "isTable"
	$a_lSetUp[8][1] = (IsBool($b_IsTable) ? $b_IsTable : False)

	Return SetError(((IsArray($a_lSetUp) = 1) ? 0 : 1), UBound($a_lSetUp), $a_lSetUp)
EndFunc   ;==>_OCRSpace_SetUpOCR

; #============================================================================================================
; Name...........: _OCRSpace_ImageHighlightWord
; Author ........: Kabue Murage
; Description ...: Draws a rectangle around a detected word. This is only Useful when you want to highlight a
;                  word on an image i.e After processing it with _OCRSpace_ImageGetText() with $iReturnType 1
; Syntax.........: _OCRSpace_ImageHighlightWord($aOverlayArrayInfo, $sImageFQPN_, $sWord_)
;
; 					$aOverlayArrayInfo - The array reference as returned by _OCRSpace_ImageGetText() with $iReturnType 1
; 					$sImageFQPN_       - Valid path reference to the image you want marked.
;                   $sWord_ 		   - The word you want to mark/highlight on the image .
;
; Return values .: Success - True
;                  Failure - -1 and sets the @error flag to non-zero
;                           @error - 1 When invalid $aOverlayArrayInfo info
;                                  - 2 $sImageFQPN_ file does not exist.
;								   - 3 Error initializing GDI+
;
; Remarks .......: Common offsets for Rectangle coordinates with scale 0.1 :
;				   	 1. Left   -  $aOverlayArrayInfo[$i][1] -20
;				   	 2. Top    -  $aOverlayArrayInfo[$i][2] -05
;				   	 3. Height -  $aOverlayArrayInfo[$i][3]
;				   	 4. Width  -  $aOverlayArrayInfo[$i][4]
; Related .......:
; Link ..........:
; Example .......: No
; =============================================================================================================
Func _OCRSpace_ImageHighlightWord($aOverlayArrayInfo, $sImageFQPN_, $sWord_, $bCaseSense = True)

	; Must be an array with 5 columns as returned by _OCRSpace_ImageGetText() with $iReturnType 1
	If Not (IsArray($aOverlayArrayInfo) And UBound($aOverlayArrayInfo, $UBOUND_COLUMNS) = 5) Then Return SetError(1, 0, -1)
	If Not (FileExists($sImageFQPN_) And StringInStr(FileGetAttrib($sImageFQPN_), "D") = 0) Then Return SetError(3, 0, -1)
	If (StringLen($sWord_) < 1) Then Return SetError(2, 0, -1)

	Local $i_lFound = 0

	; ! Open GDI plus here..
	For $i = 0 To UBound($aOverlayArrayInfo, $UBOUND_ROWS) - 1 Step +1
		If (($bCaseSense) ? $aOverlayArrayInfo[$i][0] = $sWord_ : StringInStr($aOverlayArrayInfo[$i][0], $sWord_, $STR_NOCASESENSEBASIC, 1) > 0) Then
			_OCRSpace_WordDrawRect($sImageFQPN_, $aOverlayArrayInfo[$i][1], $aOverlayArrayInfo[$i][2], $aOverlayArrayInfo[$i][3], $aOverlayArrayInfo[$i][4])
			If (@error = 1) Then Return SetError(3, 0, -1)
			$i_lFound += 1
			; TODO ! Fix to allow highlighting multiple instances of a word on an image!
			; Return SetError(($i_lFound = 0) ? 1 : 0, $i_lFound, ($i_lFound = 0) ? False : True)
		EndIf
	Next
	; ! Close and clean GDI+ here..
	Return SetError(($i_lFound = 0) ? 1 : 0, $i_lFound, ($i_lFound = 0) ? False : True)
EndFunc   ;==>_OCRSpace_ImageHighlightWord

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _OCRSpace_WordDrawRect
; Author ........: Kabue Murage
; Description ...: Draws a rectangle around a detected word.
; Syntax.........: _OCRSpace_WordDrawRect($sImageFile, $iLeftPos, $iTopPos, $iHeight, $iWidth, $Pencolor = 0xFF8080FF)
; Return values .: Success -
;                  Failure - a blank string.
;
; Remarks .......: Left    -  $aOverlayArrayInfo[$i][1]
;				   Top     -  $aOverlayArrayInfo[$i][2]
;				   Height  -  $aOverlayArrayInfo[$i][3]
;				   Width   -  $aOverlayArrayInfo[$i][4]
;
; 				   $iScale -  For 1.0 is Without any scaling.
;
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OCRSpace_WordDrawRect($sImageFile, $iLeftPos, $iTopPos, $iHeight, $iWidth, $Pencolor = 0xFF000000, $iScale = 1.0)

	If Not FileExists($sImageFile) Then Return SetError(1, 0, "")

	; Initialize GDI+ library
	If _GDIPlus_Startup() Then

		Local $s_OutputRet = StringRegExpReplace($sImageFile, "^.*\\", "")

		Local $h_FileImgBitmap, $h_FileImgBitmapEx, $h_Gfx, $hClone, $hBitmap_Scaled
		; Local $i_lXOffset = 20, $i_lYOffset = 8, $i_lWidthOffset = 10, $i_lHeightOffset = 5

		$h_FileImgBitmap = _GDIPlus_BitmapCreateFromFile($sImageFile)

		; Image width
		$bitmap_w = _GDIPlus_ImageGetWidth($h_FileImgBitmap)
		$bitmap_h = _GDIPlus_ImageGetHeight($h_FileImgBitmap)

		; the clone to work with..
		$hClone = _GDIPlus_BitmapCloneArea($h_FileImgBitmap, 0, 0, $bitmap_w, $bitmap_h, $GDIP_PXF24RGB)

		_GDIPlus_ImageDispose($h_FileImgBitmap)
		_WinAPI_DeleteObject($h_FileImgBitmap)

		; Scales an image by a given factor
		$hBitmap_Scaled = _GDIPlus_ImageScale($hClone, $iScale, $iScale, $GDIP_INTERPOLATIONMODE_NEARESTNEIGHBOR)

		$h_Gfx = _GDIPlus_ImageGetGraphicsContext($hBitmap_Scaled)
		; _GDIPlus_GraphicsClear($h_Gfx, 0xFFFFFFFF)
		; Prepare pen props used to draw a frame around the detected word..
		$hPen = _GDIPlus_PenCreate($Pencolor, 3)

		; $nX 		The X coordinate of the upper left corner of the rectangle
		; $nY 		The Y coordinate of the upper left corner of the rectangle
		; $nWidth   The width of the rectangle.
		; $nHeight  The height of the rectangle.

		_GDIPlus_GraphicsDrawRect($h_Gfx, $iLeftPos, $iTopPos, $iWidth, $iHeight, $hPen)

		; Save bitmap to file
		_GDIPlus_ImageSaveToFile($hClone, $sImageFile) ; @MyDocumentsDir & "\GDIPlus_Image.bmp")

		; Save resultant image
		_GDIPlus_ImageSaveToFile($hBitmap_Scaled, @ScriptDir & "\meme_traced.jpg")

		; Clean up used resources
		_GDIPlus_PenDispose($hPen)
		_GDIPlus_BitmapDispose($hClone)

		_GDIPlus_GraphicsDispose($h_Gfx)
		_GDIPlus_BitmapDispose($hBitmap_Scaled)

		; Shut down GDI+ library
		_GDIPlus_Shutdown()

	Else
		; error initializig GDI Plus
		Return SetError(1, @error, -1)
	EndIf

	Return SetError(0, 0, -1)
EndFunc   ;==>_OCRSpace_WordDrawRect




; ===============================================================================================================================
; Name...........: _OCRSpace_WinCaptureText
; Author ........: Kabue Murage
; Description ...: Captures a window's text to a text array, given a window title or handle
; Syntax.........: _OCRSpace_WinCaptureText($aOCR_OptionsHandle, $hWnd_, $iReturnType = 1)
; Return values .: Success :    - The detected text in the format requested via $iReturnType
;								- @error set to 0
;
;                  Failure :    - -1 and @error set to :
;							  1 - Invalid options : $aOCR_OptionsHandle
;							  2 - Invalid window handle.
; 							  3 - Error capturing window.
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _OCRSpace_WinCaptureText($aOCR_OptionsHandle, $hWnd_, $iReturnType = 1)
	; Ensure the array is as returned by _OCRSpace_SetUpOCR()
	If Not (IsArray($aOCR_OptionsHandle) And UBound($aOCR_OptionsHandle, $UBOUND_COLUMNS) = 5) Then Return SetError(1, 0, -1)
	If Not IsHWnd($hWnd_) Then Return SetError(2, 0, -1)

	Local $s_lCaptureFilename = _TempFile(@TempDir, "~", ".bmp")
	Local $i_lType = $iReturnType

	If Not _ScreenCapture_CaptureWnd($s_lCaptureFilename, $hWnd, 0, 0, -1, -1, False) Then Return SetError(3, 0, -1)

	Switch $i_lType
		Case 1, 0
			; okay..
		Case Else ; default, -1, "",  ..etc
			$i_lType = 0
	EndSwitch

	Local $v_lText = _OCRSpace_ImageGetText($aOCR_OptionsHandle, $s_lCaptureFilename, $i_lType)
	If Not @error Then Return SetError(0, @extended, $v_lText)

	Return SetError(@error, @extended, $v_lText)
EndFunc   ;==>_OCRSpace_WinCaptureText


; #FUNCTION# =======================================================================================================================
; Title .........: _OCRSpace_ImageGetText
; Author ........: Kabue Murage
; Description ...: Retrieves text from an image using the OCRSpace API
; Syntax.........: _OCRSpace_ImageGetText($aOCR_OptionsHandle, $sImage_UrlOrFQPN, $iReturnType = 0, $sURLVar = "")
; Link ..........:
; Parameters ....:  $aOCR_OptionsHandle      - The reference array variable  as created by _OCRSpace_SetUpOCR()
;                :  $sImage_UrlOrFQPN        - A valid : Path to an image you want OCR'ed from your PC or URL to an image you want OCR'ed.
;					$iReturnType               0 return detected text only.
;                                              1 return an array
; Return values .: Success : Returns the detected text of type specified at $iReturnType
;                             -  If a searchable PDF was requested ,its url will be assigned to the string $sURLVar, so to get it evaluate it!
;                             -  @error flag set to 0 if no error occoured.
;                             -  @extended is set to the Processing Time In Milliseconds
;                  Failure : Returns "" and @error flag set to non-zero ;
;                           1 - If UNSET options or error initializing options.
;                           2 - If $sImage_UrlOrFQPN is not a valid Image or URL.
;                           3 - If an error occurs opening a local file specified.
;                           4 - If a searchable pdf was requested and a string to declare the result url is undefined.
;                           5 - An unsupported filetype parsed.
;                           6 - Failed to create http request object
;                           7 - Failed to parse json returned by OCRSpace
;                           8 - $sURLVar is not a valid alpha string.
; Remarks .......: - Setup your OCR options beforehand using _OCRSpace_SetUpOCR. Also note that the URL method is easy and fast to use, compared to uploading a local file.
;                  - StringLeft(@error, 2) shows if used OCR Engine completed successfully, partially or failed with error.
;                           1 - Parsed Successfully (Image / All pages parsed successfully)
;                           2 - Parsed Partially (Only few pages out of all the pages parsed successfully)
;                           3 - Image / All the PDF pages failed parsing (This happens mainly because the OCR engine fails to parse an image)
;                           4 - Error occurred when attempting to parse (This happens when a fatal error occurs during parsing )
;							* =========================================
;							* 		$__ErrorCode_
;							* ====================================
;							? 0  : File not found
;							? 1  : Success
;							? 10 : OCR Engine Parse Error
;							? 20 : Timeout
;							? 30 : Validation Error
;							? 99 : Unknown Error
;
; ===============================================================================================================================
Func _OCRSpace_ImageGetText($aOCR_OptionsHandle, $sImage_UrlOrFQPN, $iReturnType = 0, $sURLVar = "__OCRSPACE_SEARCHABLE_PDFLINK")

	Local $oError = ObjEvent("AutoIt.Error", "___OCRSpace__COMErrFunc")
	#forceref $oError

	If Not (IsArray($aOCR_OptionsHandle) And UBound($aOCR_OptionsHandle, $UBOUND_COLUMNS) <> 5) Then Return SetError(1, 0, "")
	If Not IsString($sURLVar) Then Return SetError(8, 0, "")

	If (IsConnected() = False) Then
		ConsoleWrite("No Internet Connection!" & @CRLF)
		Return SetError(800, 0, "")
	EndIf

	Local $s_lExt, $s_lParams__
	Local $i_lAPIRespStatusCode__
	Local $d_ImgBinDat__
	Local $h_lFileOpen__, $h_lRequestObj__ = Null


	; If a ssearchable pdf was requested and the URL string to be set to is undefined.
	If ($aOCR_OptionsHandle[5][1]) Then

		Local Const $S_LSEARCHABLEPDFLINK = "__OCRSPACE_SEARCHABLE_PDFLINK"

		Switch $sURLVar
			Case Default, -1, ""
				$sURLVar = $S_LSEARCHABLEPDFLINK ; "__OCRSPACE_SEARCHABLE_PDFLINK"
			Case Else
				$sURLVar = ((StringLen($sURLVar) > 1) And (StringIsAlpha($sURLVar) = 1)) ? $sURLVar : $S_LSEARCHABLEPDFLINK
		EndSwitch

	EndIf

	If (FileExists($sImage_UrlOrFQPN) And StringInStr(FileGetAttrib($sImage_UrlOrFQPN), "D") = 0) Then
		$s_lExt = StringLower(StringTrimLeft($sImage_UrlOrFQPN, StringInStr($sImage_UrlOrFQPN, ".", 0, -1)))
		Switch $s_lExt
			Case "pdf", "gif", "png", "jpg", "tif", "bmp", "pdf", "jpeg" ; "tiff"
				; do nothing ..
				; Supported image file formats are png, jpg (jpeg), gif, tif (tiff) and bmp.
				; For document ocr, the api supports the Adobe PDF format. Multi-page TIFF files are supported.
			Case Else
				Return SetError(5, 0, "")
		EndSwitch

		$h_lFileOpen__ = FileOpen($sImage_UrlOrFQPN, 16) ; $FO_BINARY
		If $h_lFileOpen__ = -1 Then Return SetError(3, 0, "")

		$d_ImgBinDat__ = FileRead($h_lFileOpen__)
		FileClose($h_lFileOpen__)
		$s_lb64Dat__ = _Base64Encode($d_ImgBinDat__)
		$s_lEncb64Dat__ = __URLEncode_($s_lb64Dat__)

		$h_lRequestObj__ = __POSTObjCreate()
		If $h_lRequestObj__ = -1 Then Return SetError(6, 0, "")

		$h_lRequestObj__.Open("POST", "https://api.ocr.space/parse/image", False) ; Let's Go!

		$s_lParams__ = "base64Image=data:" & ($s_lExt = "pdf" ? "application/" & $s_lExt : "image/" & $s_lExt) & ";base64," & $s_lEncb64Dat__ & "&"

		; Append all Prameters..
		For $i = 1 To UBound($aOCR_OptionsHandle) - 1
			$s_lParams__ &= StringLower($aOCR_OptionsHandle[$i][0] & "=" & $aOCR_OptionsHandle[$i][1] & "&")
		Next
		$s_lParams__ = StringTrimRight($s_lParams__, 1)

		$h_lRequestObj__.SetRequestHeader($aOCR_OptionsHandle[0][0], $aOCR_OptionsHandle[0][1])
		$h_lRequestObj__.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
		$h_lRequestObj__.Send($s_lParams__)

	ElseIf _PathIsURLA__($sImage_UrlOrFQPN) Then

		; The important limitation of the GET api endpoint is it only allows image and
		; PDF submissions via the URL method as only HTTP POST requests can supply additional
		; data to the server in the message body...

		$h_lRequestObj__ = _GETObjCreate()
		If $h_lRequestObj__ = -1 Then Return SetError(6, 0, "")

		; Every option for this api call is to be parsed inside the URL! So , all the parameters can
		; be appended to create a valid url. So by design, a GET api cannot support file uploads
		; (file parameter) or BASE64 strings (base64image) method..

		$s_lParams__ = "https://api.ocr.space/parse/ImageUrl?" & $aOCR_OptionsHandle[0][0] & "=" & $aOCR_OptionsHandle[0][1] & "&url=" & $sImage_UrlOrFQPN & "&"

		For $i = 1 To UBound($aOCR_OptionsHandle) - 1
			$s_lParams__&= $aOCR_OptionsHandle[$i][0] & "=" & $aOCR_OptionsHandle[$i][1] & "&"
		Next
		; Trim a trailing ampersand.
		$s_lParams__ = StringTrimRight($s_lParams__, 1)

		$h_lRequestObj__.Open("GET", $s_lParams__, False)
		$h_lRequestObj__.Send()
	Else
		Return SetError(2, 0, "")
	EndIf

	$h_lRequestObj__.WaitForResponse()
	$s_lAPIResponseText__ = $h_lRequestObj__.ResponseText
	$i_lAPIRespStatusCode__ = $h_lRequestObj__.Status
	; ConsoleWrite($s_lAPIResponseText__ & @CRLF)
	; Release the object.
	$h_lRequestObj__ = Null

	; extended utf-8 charset incase the json contains accents i.e characters like àèéìòù
	$s_lAPIResponseText__ = _WinAPI_WideCharToMultiByte($s_lAPIResponseText__, 65001)
	Switch Int($i_lAPIRespStatusCode__)
		Case 200
			; If ($aOCR_OptionsHandle[3][1]) And ($iReturnType = 1) Then
			; ConsoleWrite("Overlay info requested as an array :)" & @CRLF)
			; EndIf
			Local $o_lJson__ = _JSON_Parse($s_lAPIResponseText__)
			If Not @error Then
				Local $__ErrorCode_ = Null

				$s_lDetectedTxt__ = _JSON_Get($o_lJson__, "ParsedResults[0].ParsedText")            ; Returned
				$s_lProcessingTimeInMs = _JSON_Get($o_lJson__, "ProcessingTimeInMilliseconds")      ; Set to @extended.
				; The exit code shows if OCR completed successfully, partially or failed with error.
				$i_lOCREngineExitCode = _JSON_Get($o_lJson__, "OCRExitCode")                     ; Set to 1 if completed all successfully
				$__ErrorCode_ &= $i_lOCREngineExitCode
				; The exit code returned by the parsing engine. Set to extended..
				$i_lFileParseExitCode = _JSON_Get($o_lJson__, "ParsedResults[0].FileParseExitCode")

				$i_lFileParseExitCode = (StringLeft($i_lFileParseExitCode, 1) = "-") ? StringTrimLeft($i_lFileParseExitCode, 1) : $i_lFileParseExitCode

				$__ErrorCode_ &= $i_lFileParseExitCode
				$s__lSearchablePDFURL_ = _JSON_Get($o_lJson__, "SearchablePDFURL")

				Assign($sURLVar, $s__lSearchablePDFURL_, $ASSIGN_FORCEGLOBAL)

				$i_lErrorOnProcessing = (_JSON_Get($o_lJson__, "IsErroredOnProcessing") ? 0 : 1) ; bool -> int
				$__ErrorCode_ &= $i_lErrorOnProcessing

				Switch $iReturnType
					Case 0, Default, -1
						Return SetError($__ErrorCode_, $s_lProcessingTimeInMs, $s_lDetectedTxt__)
					Case 1 ; User wants an array explictly..
						If Not ($aOCR_OptionsHandle[3][1]) Then ; but the array info wasn't requested .. soo..
							ConsoleWrite("Overlay info was NOT requested at _OCRSpace_SetUpOCR()" & @CRLF)
							; return a stractured array nevertheless
							Local $aRet[1][2]

							$aRet[0][0] = StringLen($aRet)
							$aRet[0][1] = $s_lDetectedTxt__
							Return SetError(($__ErrorCode_ = 111 ? 0 : $__ErrorCode_), $s_lProcessingTimeInMs, $aRet)
						EndIf

						Local $a_lOverlayArray__[0][5]
						Local $i_lEnumAllJSONObj__ = 0, $i_lEnumLinesJSONObj__ = 0, $i_lEnum_row__ = 0
						Local $s_lWordText__, $i_lWordPosLeft__, $i_lWordPosTop__, $i_lWordHeight__, $i_lWordWidth__

						While True
							$s_lWordText__ = _JSON_Get($o_lJson__, "ParsedResults[0].TextOverlay.Lines[" & $i_lEnumLinesJSONObj__ & "].Words[" & $i_lEnumAllJSONObj__ & "].WordText")
							If ($s_lWordText__ = "") Then
								$i_lEnumLinesJSONObj__ += 1
								$i_lEnumAllJSONObj__ = 0
								$s_lWordText__ = _JSON_Get($o_lJson__, "ParsedResults[0].TextOverlay.Lines[" & $i_lEnumLinesJSONObj__ & "].Words[" & $i_lEnumAllJSONObj__ & "].WordText")
							EndIf

							$i_lWordPosLeft__ = _JSON_Get($o_lJson__, "ParsedResults[0].TextOverlay.Lines[" & $i_lEnumLinesJSONObj__ & "].Words[" & $i_lEnumAllJSONObj__ & "].Left")
							If @error Then ExitLoop 1 ; If reached at EOO, then exitloop without wasting time..

							$i_lWordPosTop__ = _JSON_Get($o_lJson__, "ParsedResults[0].TextOverlay.Lines[" & $i_lEnumLinesJSONObj__ & "].Words[" & $i_lEnumAllJSONObj__ & "].Top")
							$i_lWordHeight__ = _JSON_Get($o_lJson__, "ParsedResults[0].TextOverlay.Lines[" & $i_lEnumLinesJSONObj__ & "].Words[" & $i_lEnumAllJSONObj__ & "].Height")
							$i_lWordWidth__ = _JSON_Get($o_lJson__, "ParsedResults[0].TextOverlay.Lines[" & $i_lEnumLinesJSONObj__ & "].Words[" & $i_lEnumAllJSONObj__ & "].Width")

							ReDim $a_lOverlayArray__[UBound($a_lOverlayArray__, $UBOUND_ROWS) + 1][UBound($a_lOverlayArray__, $UBOUND_COLUMNS)]
							$a_lOverlayArray__[$i_lEnum_row__][0] = $s_lWordText__
							$a_lOverlayArray__[$i_lEnum_row__][1] = $i_lWordPosLeft__
							$a_lOverlayArray__[$i_lEnum_row__][2] = $i_lWordPosTop__
							$a_lOverlayArray__[$i_lEnum_row__][3] = $i_lWordHeight__
							$a_lOverlayArray__[$i_lEnum_row__][4] = $i_lWordWidth__

							$i_lEnumAllJSONObj__ += 1
							$i_lEnum_row__ += 1
						WEnd

						If ($__ErrorCode_ = 111) Then $__ErrorCode_ = 0

						Return SetError($__ErrorCode_, $s_lProcessingTimeInMs, $a_lOverlayArray__)
				EndSwitch
			EndIf
		Case Else
	EndSwitch
	Return SetError(1, $i_lAPIRespStatusCode__, $s_lAPIResponseText__)
EndFunc   ;==>_OCRSpace_ImageGetText

Func ___OCRSpace__COMErrFunc()
	If (IsConnected() = False) Then
		; SetError(800, 0)
		ConsoleWrite("No Internet Connection!" & @CRLF)
		; Exit
	EndIf
	; Do nothing special, just check @error after suspect functions.
EndFunc   ;==>___OCRSpace__COMErrFunc


Func IsConnected()

	Local Const $NETWORK_ALIVE_LAN = 0x1 ; net card connection
	Local Const $NETWORK_ALIVE_WAN = 0x2 ; RAS (internet) connection
	Local Const $NETWORK_ALIVE_AOL = 0x4 ; AOL

	Local $aRet, $sResult = Null

	$aRet = DllCall("sensapi.dll", "int", "IsNetworkAlive", "int*", 0)

	If BitAND($aRet[1], $NETWORK_ALIVE_LAN) Then $sResult &= "LAN connected" & @LF
	If BitAND($aRet[1], $NETWORK_ALIVE_WAN) Then $sResult &= "WAN connected" & @LF
	If BitAND($aRet[1], $NETWORK_ALIVE_AOL) Then $sResult &= "AOL connected" & @LF

	Return (($sResult = Null) ? False : $sResult)
EndFunc   ;==>IsConnected



; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _PathIsURLA__
; Description ...: Uses shlwapi.dll to determine a valid URL.
;                  prefer this to implimenting a long Regex for it
; Syntax.........:_PathIsURLA__()
; Return values .: Success - true : if $_sPath is a valid URL/URI
; Modified ......: Kabue Murage
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func _PathIsURLA__($_sPath)
	Local $_aCall = DllCall("shlwapi.dll", "BOOL", "PathIsURLA", "STR", $_sPath)
	If @error = 0 And IsArray($_aCall) Then
		Return $_aCall[0] = 1
	EndIf
	Return False
EndFunc   ;==>_PathIsURLA__


; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __URLEncode_
; Description ...: Returns an inline URL encoded string.
; Syntax.........:__URLEncode_()
; Return values .: Success - An inline URL encoded string.
; Modified ......: Kabue Murage
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __URLEncode_($urlText)
	$url = ""
	For $i = 1 To StringLen($urlText)
		$acode = Asc(StringMid($urlText, $i, 1))
		Select
			Case ($acode >= 48 And $acode <= 57) Or ($acode >= 65 And $acode <= 90) Or ($acode >= 97 And $acode <= 122)
				$url = $url & StringMid($urlText, $i, 1)
			Case $acode = 32
				$url = $url & "+"
			Case Else
				$url = $url & "%" & Hex($acode, 2)
		EndSelect
	Next
	Return $url
EndFunc   ;==>__URLEncode_

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _Base64Encode
; Description ...: Returns a Base64 code for the data parsed.
; Syntax.........:_Base64Encode()
; Return values .: Success - A Base64 code for the data parsed.
; Modified ......: Kabue Murage
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _Base64Encode($Data, $LineBreak = 76)
	Local $Opcode = _
			'0x5589E5FF7514535657E8410000004142434445464748494A4B4C4D4E4F505152535455565758595A61626364656' & _
			'66768696A6B6C6D6E6F707172737475767778797A303132333435363738392B2F005A8B5D088B7D108B4D0CE98F0000000FB6' & _
			'33C1EE0201D68A06880731C083F901760C0FB6430125F0000000C1E8040FB63383E603C1E60409C601D68A0688470183F9017' & _
			'6210FB6430225C0000000C1E8060FB6730183E60FC1E60209C601D68A06884702EB04C647023D83F90276100FB6730283E63F' & _
			'01D68A06884703EB04C647033D8D5B038D7F0483E903836DFC04750C8B45148945FC66B80D0A66AB85C90F8F69FFFFFFC6070' & _
			'05F5E5BC9C21000'
	Local $CodeBuffer = DllStructCreate('byte[' & BinaryLen($Opcode) & ']')
	DllStructSetData($CodeBuffer, 1, $Opcode)
	$Data = Binary($Data)
	Local $Input = DllStructCreate('byte[' & BinaryLen($Data) & ']')
	DllStructSetData($Input, 1, $Data)
	$LineBreak = Floor($LineBreak / 4) * 4
	Local $OputputSize = Ceiling(BinaryLen($Data) * 4 / 3)
	$OputputSize = $OputputSize + Ceiling($OputputSize / $LineBreak) * 2 + 4

	Local $Ouput = DllStructCreate('char[' & $OputputSize & ']')
	DllCall('user32.dll', 'none', 'CallWindowProc', 'ptr', DllStructGetPtr($CodeBuffer), _
			'ptr', DllStructGetPtr($Input), _
			'int', BinaryLen($Data), _
			'ptr', DllStructGetPtr($Ouput), _
			'uint', $LineBreak)
	Return DllStructGetData($Ouput, 1)
EndFunc   ;==>_Base64Encode



; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __POSTObjCreate
; Description ...: Returns a POST object handle.
; Syntax.........:__POSTObjCreate()
; Return values .: Success -A valid Winhttprequest v5.1 object handle to use for POST requests.
; Modified ......: Kabue Murage
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func __POSTObjCreate()
	Local $o_lHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	Return SetError(@error, 0, ((IsObj($o_lHTTP) = 1) ? $o_lHTTP : -1))
EndFunc   ;==>__POSTObjCreate


; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: _GETObjCreate
; Description ...: Returns a GET object handle.
; Syntax.........:_GETObjCreate()
; Return values .: Success -A valid Winhttprequest v5.1 object handle to use for GET requests.
; Modified ......: Kabue Murage
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _GETObjCreate()
	Local $o_lHTTP
	$o_lHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	Return SetError(@error, 0, ((IsObj($o_lHTTP) = 1) ? $o_lHTTP : -1))
EndFunc   ;==>_GETObjCreate
