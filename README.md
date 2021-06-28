
## UDFs for AutoIt


<p align="center">
  <img src="https://i.imgur.com/fpHBLJw.png"><br>
</p>
<p align="center">
	<b>The OCR.space Online OCR service converts scans or (smartphone) images of text documents <br>
		into editable files by using Optical Character Recognition (OCR)
		<br>
</p>

<hr/>
	
### Setting up
1. Assuming the udf is present in the working directory,  include it in your script with the directive : 
```Autoit
#include "_OCRSpace.au3"
```
2. Initialize your preferences beforehand with the function ```_OCRSpace_SetUpOCR```. You'll have to set up your API key at least. 
```AutoIT
$a_ocr = _OCRSpace_SetUpOCR(0123456789abcdefABCDEF, 1, false, true, "eng")
```
3. Parse the returned array "*handle*" from the function `_OCRSpace_SetUpOCR` to the first parameter of the function 
	```_OCRSpace_ImageGetText```, along with the rest of the optional or  required parameters.

<hr/>

### Usage
```autoit
; get your free key at http://eepurl.com/bOLOcf
$api_key = "0123456789abcdefABCDEF"

; setup some preferences in retrospect.
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, Default)

; scan a receipt (using a image url reference)
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/KrS6rRT.jpeg", 0)

; display the result.
ConsoleWrite( _
	" Detected text   : " & $s_textdetected & @CRLF & _
	" Error Returned  : " & @error & @CRLF)

```

<details>

<summary>  [Click to expand the full script] </summary>



  ```AutoIT
  #include "OCRSpace_UDF.au3"

; get your free key at http://eepurl.com/bOLOcf
$api_key = "0123456789abcdefABCDEF"

; setup some preferences in retrospect.
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, Default)

; scan a receipt (using a image url reference)
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/KrS6rRT.jpeg", 0)

; display the result.
ConsoleWrite( _
			" Detected text   : " & $s_textdetected & @CRLF & _
			" Error Returned  : " & @error & @CRLF)
			
```

 

</details>

<br>

<hr/>

### How to request for a searchable PDF

A searchable PDF can be requested and its URI retrieved by:
1. Set the last option of the `_OCRSpace_SetUpOCR` to `True` :
```Autoit
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, True)
```
2. Set the string you want the uri assigned to, in this case `MyPDF_URL_`

```Autoit
; scan a receipt (using a image uri reference). The url to a searchable pdf requested will be assigned to 'MyPDF_URL_'
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/KrS6rRT.jpeg", 0, "MyPDF_URL_")
```
3. Display the results , evaluate the string pointing to a searchable PDF URI .
```Autoit
ConsoleWrite( _
	" Detected text        : " & $s_textdetected & @CRLF & _
	" Error Returned       : " & @error & @CRLF & _
	" Searchable PDF  Link : " & Eval("MyPDF_URL_") & @CRLF)

```
<hr/>

#### Example:
```autoit
While 1 ;Create a While that restart Polling
	$msgData = _Polling() ;_Polling function return an array with information about a message
	_SendMsg($msgData[2],$msgData[5]) ;Send a message to the same user with the same text
WEnd
```


If you want to try all the available features of the OCR API, check out their full documentation [here](https://ocr.space/OCRAPI)!

<hr/>

## Other credits
+ Thanks to AspirinJunkie for the JSON UDF

<hr/>

## Legal
**License: GPL v3.0 ©** : Feel free to use this code and adapt it to your software; just mention this page if you share your software (free or paid).
This code is in no way affiliated with, authorized, maintained, sponsored or endorsed by OCRSpace and/or AutoIt or any of its affiliates or subsidiaries.
This is independent and unofficial. Use at your own risk.

<hr/>

## About
Can't ask you to star this: if you enjoyed what I did, this will happen naturally.
For support, just contact me! Enjoy 🎉
