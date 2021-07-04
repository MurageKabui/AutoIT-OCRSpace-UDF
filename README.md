
<p align="center">
  <img src="https://i.imgur.com/fpHBLJw.png"><br>
</p>
<p align="center">
	<b> This UDF provides text capturing support for applications and controls using the OCRSpace API - a powerful Online OCR service that 
		converts images of text documents into editable files by using Optical Character Recognition (OCR) 
	<br>
</p>

<hr/>
<!-- 	My main goal for developing this UDF was to provide AutoIT users with a better Screen OCR solution that competes with other (explictly)
	commercial solutions like Microsoft Office Document Imaging (MODI) and Textract. The OCRSpace API is a Free OCR web 
	service that takes a JPG, PNG or PDF file and converts them to text or searchable PDF. Although their free plan has a rate limit of 500 
	requests within one day (per IP), for even faster response times and guaranteed 100% uptime, consider subscribing to a PRO plan! -->

<!-- <hr/> -->


## Setting up
1. Assuming the udf is present in the working directory,  include it in your script with the directive : 
```Autoit
#include "_OCRSpace.au3"
```
2. Initialize your preferences beforehand with the function ```_OCRSpace_SetUpOCR```. <br> Here ,
	you're required to set up your API key at least. 
```AutoIT
$a_ocr = _OCRSpace_SetUpOCR("0123456789abcdefABCDEF", 1, false, true, "eng")
```
3. Parse the returned array "*handle*" from the function `_OCRSpace_SetUpOCR` to the first parameter of <br>
	 the function ```_OCRSpace_ImageGetText```, along with the rest of the optional or  required parameters.
```AutoIT
$sText_Detected = _OCRSpace_ImageGetText($a_ocr, "receipt.jpg", 0)
```

<hr/>

## Basic Usage

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

<!-- <details>


<summary>  🔰 [Click to expand the full script] </summary>

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
	
</details> -->


<hr/>

## Request for a searchable PDF

A searchable PDF can be requested and its URI retrieved by:
1. Set the last option of the `_OCRSpace_SetUpOCR` to `True` :
```Autoit
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, True)
```
2. Set the string you want the url assigned to, in this case `MyPDF_URL_`

```Autoit
; scan a receipt (using a image uri reference). The url to a searchable pdf requested will be assigned to 'MyPDF_URL_'
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/KrS6rRT.jpeg", 0, "MyPDF_URL_")
```
3. Display the results , evaluate the string pointing to a searchable PDF URL .
```Autoit
ConsoleWrite( _
	" Detected text        : " & $s_textdetected & @CRLF & _
	" Error Returned       : " & @error & @CRLF & _
	" Searchable PDF  Link : " & Eval("MyPDF_URL_") & @CRLF)

```
<hr/>

## Advanced Usage

- By **Default**, the detected text is returned as a *plain string* **i.e.** when ``$iReturnType`` at  <br> function``_OCRSpace_ImageGetText``   is set to **0** .

- Setting ``$iReturnType`` to **1**   returns a 2D **array** containing  the coordinates of the bounding <br>
  boxes for each word detected, in the format : ``#WordDetected`` , ``#Left`` , ``#Top`` , ``#Height``,  ``#Width``


> Example with a URL reference : [lorem_ipsum.png](https://i.imgur.com/eCuYtDe.png)

> [lorem_ipsum.png](https://i.imgur.com/eCuYtDe.png) <br>
![lorem_ipsum.png](https://github.com/KabueMurage/AutoIT-OCRSpace-UDF/blob/main/Assets/lorem_ipsum.png?raw=true)


<details>

<summary>   [Click to Expand the script] </summary>

```Autoit
; Set your key here.
$v_OCRSpaceAPIKey = "0123456789abcdefABCDEF"

; SetUp some options.
$OCROptions = _OCRSpace_SetUpOCR($v_OCRSpaceAPIKey, 1, False, True, "eng", True, Default, Default, False)

; iReturnType : set to 1 to return an array
$aText_Detected = _OCRSpace_ImageGetText($OCROptions, "https://i.imgur.com/eCuYtDe.png", 1)

; Display the array
_ArrayDisplay($aText_Detected)
```
</details>


> Result with ArrayDisplay() <br>
![lorem_ipsum.png](https://github.com/KabueMurage/AutoIT-OCRSpace-UDF/blob/main/Assets/Results.jpg?raw=true)


<hr/>

## Other Stuff

 - Check the API performance and uptime at the API status page [here](https://status.ocr.space/)
 - Register here for your free OCR API key [here](http://eepurl.com/bOLOcf)
 - Subscribe to a PRO plan [here](https://ocr.space/OCRAPI#pro)
 - If you want to try all the available features of the OCR API, check out their full documentation [here](https://ocr.space/OCRAPI)!


  Plot : https://github.com/users/KabueMurage/projects/7

<hr/>

## Other credits
•••
+ Thanks to AspirinJunkie for the JSON UDF

<hr/>

## Legal
<!-- **License: GPL v3.0 ©** : Feel free to use this code and adapt it to your software; just mention this page if you share your software (free or paid). -->
Use this however tf you want, all at your own risk. This code is in no way affiliated with, authorized, maintained, sponsored or endorsed by OCRSpace 
and/or AutoIt or any of its affiliates or subsidiaries. This is independent and unofficial.

<hr/>
<!-- 
## About
Hate to ask you to star this cs if you found this creation useful, this will happen naturally, 
For support, just contact me! Enjoy 🎉 -->
