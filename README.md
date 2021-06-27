
## UDFs for AutoIt


<p align="center">
  <img src="http://karthikputtoju-wtutorials.weebly.com/uploads/4/1/9/3/41933719/2353045_orig.png?115"><br>
</p>
<p align="center">
<b>The OCR.space Online OCR service converts scans or (smartphone) images of text documents into editable files by using Optical Character Recognition (OCR)</b><br>
</p>

<p align="center">
  <img src="https://github.com/xLinkOut/telegram-udf-autoit/blob/master/assets/star_icon.png" width="20">
   official AutoIt Script UDFs list! Check it <a href="https://www.autoitscript.com/wiki/User_Defined_Functions#Social_Media_and_other_Website_API">here!</a></b> <img src="https://github.com/xLinkOut/telegram-udf-autoit/blob/master/assets/star_icon.png" width="20">
  
</p>

### Setting up
1. Assuming the udf is present in the working directory,  include it in your script with the directive : 
```Autoit
#include "_OCRSpace.au3"
```
2. Initialize your preferences beforehand with the function ```_OCRSpace_SetUpOCR```. Here you'll set up your API key at least. 

3. Parse the returned array "*handle*" from the to the function `_OCRSpace_SetUpOCR` to the first parameter of the function ```_OCRSpace_ImageGetText```, along with the rest of the optional or  required parameters.


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

  
<p align="center">
 <img src="https://github.com/KabueMurage/CL-QuickTranslate/blob/master/src/img/syn.png?raw=true" alt="Commandline Syntax Preview"/>
</p>


</details>

<br>

### How to request for a searchable PDF

A searchable PDF can be requested and retrieved by:
1. Set the last option of the `_OCRSpace_SetUpOCR` to `True` :
```Autoit
$a_ocr = _OCRSpace_SetUpOCR($api_key, 1, false, true, "eng", true, Default, Default, True)
```
2. Set the string you want the uri assigned to, in this case `MyPDF_URL_`

```Autoit
; scan a receipt (using a image url reference). The url to a searchable pdf requested will be assigned to 'MyPDF_URL_'
$s_textdetected = _OCRSpace_ImageGetText($a_ocr , "https://i.imgur.com/KrS6rRT.jpeg", 0, "MyPDF_URL_")
```
3. Evaluate the string pointing to a url .
```Autoit

Consolewrite ( _
" Detected text        : " & $s_textdetected & @CRLF & _
" Error Returned       : " & @error & @CRLF & _
" Searchable PDF  Link : " & Eval("MyPDF_URL_") & @CRLF)

```
#### Example:


## Legal
**License: GPL v3.0 ©** : Feel free to use this code and adapt it to your software; just mention this page if you share your software (free or paid).
This code is neither affiliated with, authorized, maintained, sponsored or endorsed by ocr.space nor AutoIt or any of its affiliates or subsidiaries. This is independent and unofficial. Use at your own risk.


## Other credits
+ Thanks to AspirinJunkie for a JSON Lib!

For support, just contact me! Enjoy 🎉
