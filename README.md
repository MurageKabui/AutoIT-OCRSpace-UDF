
<p align="center">
  <img src="https://i.imgur.com/fpHBLJw.png"><br>
</p>
<p align="center">
	This UDF provides text capturing support for applications and controls using the OCRSpace API - a powerful Online OCR service that 
		converts images of text documents into editable files by using Optical Character Recognition (OCR) 
	<br>
</p>

<hr/>


## Setting up
1. Assuming the udf folder is present in the working directory,  include it in your script with the directive : 
```Autoit
#include "OCRSpaceUDF\_OCRSpace.au3"
```
2. Initialize your preferences beforehand with the function ```_OCRSpace_SetUpOCR```. <br> Here ,
	you're required to set up your API key at least. 
```AutoIT
$a_ocr = _OCRSpace_SetUpOCR("0123456789abcdefABCDEF", 1, false, true, "eng")
```
3. Parse the returned array "handle" from the function `_OCRSpace_SetUpOCR` to the first parameter of <br>
	 the function ```_OCRSpace_ImageGetText```, along with the rest of the optional or  required parameters.
```AutoIT
$sText_Detected = _OCRSpace_ImageGetText($a_ocr, @scriptdir & "\receipt.jpg", 0)
```

<details>

<summary>   [Expand full script] </summary>

	
```autoit
#include-once	
#include "OCRSpaceUDF\_OCRSpace.au3"

; Get your free key at http://eepurl.com/bOLOcf
$api_key = "0123456789abcdefABCDEF"

; Setup some preferences in retrospect.
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, Default)

; Scan a receipt (using a local image or remote url reference)
$sText_Detected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/eCuYtDe.png", 0)

; Display the result.
ConsoleWrite( _
	" Detected text   : " & $s_textdetected & @CRLF & _
	" Error Returned  : " & @error & @CRLF)
```

</details>

<hr/>

## Functions & Syntax

```autoit
_OCRSpace_SetUpOCR($s_APIKey, $i_OCREngineID = 1, $b_IsTable = False, $b_DetectOrientation = True, $s_LanguageISO = "eng", $b_IsOverlayRequired = False, $b_AutoScaleImage = False, $b_IsSearchablePdfHideTextLayer = False, $b_IsCreateSearchablePdf = False)
_OCRSpace_ImageGetText($aOCR_OptionsHandle, $sImage_UrlOrFQPN, $iReturnType = 0, $sURLVar = "__OCRSPACE_SEARCHABLE_PDFLINK")
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
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/eCuYtDe.png", 0)

; display the result.
ConsoleWrite( _
			" Detected text   : " & $s_textdetected & @CRLF & _
			" Error Returned  : " & @error & @CRLF)

```
	
</details> -->

<hr/>

## Scanning a PDF

Could be to extract text from scanned papers (e.g. Invoices, Receipts etc.). For this example, scan a PDF <br> file ; [Human_Genome_Project.pdf](https://www.lkouniv.ac.in/site/writereaddata/siteContent/202003271601129023vibha_Human_Genome_Project.pdf)

```Autoit
#include "OCRSpaceUDF\_OCRSpace.au3"

; get your free key at http://eepurl.com/bOLOcf
$api_key = "0123456789abcdefABCDEF"

; setup some preferences in retrospect.
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, Default)

; scan a PDF file (Using a PDF URL reference)
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://www.lkouniv.ac.in/site/writereaddata/siteContent/202003271601129023vibha_Human_Genome_Project.pdf", 0)

; display the result.
ConsoleWrite( _
	" Detected text   : " & $s_textdetected & @CRLF & _
	" Error Returned  : " & @error & @CRLF)	
```

<details>
	
<summary> Expand Output </summary>
	
```
	 Detected text       : Human Genome Proiect
Introduction
The Human Genome Project (HGP) is an internationally collaborative Rnture to identiöy and mark all
the locations of every- gene of the human species. The HGP in the United States was started in 1990
and was expected to be a fifteen year effort to map the human genome. There have been a number of
technological advances since 1990 that have accelerated the progress of the project to a completion
date sometime during the year 2003. The US. HGP is composed of the Depaftnent of Energy (DOE)
and the National Institute of Health (NIH) uålich hopes to discoRr 50,000 to 100,000 human genes
and make them available for biological study There are a number of other countries that are
involved in the project, including Australia: Brazil, Canada, France, Germany, Japan, and the United
Kingdom Besides numerous countries involved in the project there is also a number of commercial
companies that are invoked in sequencing. The collaborative 3 billion dollar price tag will be used to
sequence the possible 3 billion DNA base pairs of human DNA_
The possibilities from the information that will be obtained from the project are virtually endless. It
will most likely change many biological and medical research techniques and many of the practices

used by our medical professionals today. The knowledge that will be obtained will help lead to new
ways of diagnosing, treating, and possibly preventing diseases. Through the discovery of the human
genome, the possibilities are endless for agriculture, health semices, and new energy sources also. The
end result of the HGP will be information about the structure, and organization of DNA_ as
we know it today.
Since the beginning of time, people have yearned to explore the un_known, chaff where they har
been, and contemplate uhat they har found. The maps we make of these treks enable the next
explorers to push ever farther the boundaries of our knowledge - about the the sea, the sky, and
indeed, ourselves. On a new quest to chafi the innermost reaches of the human cell, scientists have
now set out on biology's most important mappmg expedition the Human Genome Project Its mission
...
Error Returned      : 0
```


</details>

<hr/>

## Request a searchable PDF

A searchable PDF can be requested and its URL retrieved by:
1. Set the last option of the `_OCRSpace_SetUpOCR` to `True` :
```Autoit
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, True)
```
2. Set the string you want the url assigned to, in this case `MyPDF_URL_`

```Autoit
; scan a receipt (using a image uri reference). The url to a searchable pdf requested will be assigned to 'MyPDF_URL_'
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/eCuYtDe.png", 0, "MyPDF_URL_")
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


> Example with a URL reference : [https://i.imgur.com/eCuYtDe.png](https://i.imgur.com/eCuYtDe.png)

> [lorem_ipsum.png](https://i.imgur.com/eCuYtDe.png) <br>
<p align="center">
  <img src="https://github.com/KabueMurage/AutoIT-OCRSpace-UDF/blob/main/Assets/lorem_ipsum.png?raw=true" title="This is a sample .png image hosted in imgur"><br>
</p>


> Result with ArrayDisplay() <br>
<p align="center">
  <img src="https://github.com/KabueMurage/AutoIT-OCRSpace-UDF/blob/main/Assets/array.gif?raw=true" title="An array generated by the OCRSpace UDF"><br>
</p>

	
```Autoit
  ; Parsing the array ..
  For $i = 0 To UBound($aText_Detected, 1) - 1
    ConsoleWrite( _
      "Word (" & $aText_Detected[$i][0] & ")  Left (" & $aText_Detected[$i][1] & ")" & " Top (" & $aText_Detected[$i][2] & ") Height (" & $aText_Detected[$i][3] & ") Width (" & $aText_Detected[$i][4] & ")" & @CRLF)
  Next

```
### Output :

```
Word (Lorem)  Left (14) Top (17) Height (10) Width (42)
Word (ipsum)  Left (66) Top (16) Height (12) Width (43)
Word (dolor)  Left (119) Top (15) Height (12) Width (42)
Word (sit)  Left (171) Top (15) Height (12) Width (25)
Word (amet,)  Left (206) Top (16) Height (12) Width (40)
Word (consectetur)  Left (259) Top (15) Height (12) Width (95)
```

•••

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
Use this however you want, all at your own risk. This code is in no way affiliated with, authorized, maintained, sponsored or endorsed by OCRSpace 
and/or AutoIt or any of its affiliates or subsidiaries. This is independent and unofficial.

<hr/>

