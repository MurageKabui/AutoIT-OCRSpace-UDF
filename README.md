<!-- ## A OCRSpace UDF for AU3 v3.3.14.5 -->


<p align="center">
  <img src="https://imgur.com/Kumm7jS"><br>
</p>
<p align="center">
<b> This lib uses an Online OCR service that converts scans images of text documents into editable files by using Optical Character Recognition (OCR)</b><br>
</p>

<p align="center">
  ⚙️ Telegram UDF is on the official AutoIt Script UDFs list! Check it <a href="https://www.autoitscript.com/wiki/User_Defined_Functions#Social_Media_and_other_Website_API">here!</a></b>

</p>

### Setting up
1. Assuming the udf is present in the working directory,  include it in your script with the directive : 
```Autoit
#include "_OCRSpace.au3"
```
2. Initialize your preferences beforehand with the function ```_OCRSpace_SetUpOCR```. You'll have to set up your API key at least. 

3. Parse the returned array "*handle*" from the function `_OCRSpace_SetUpOCR` to the first parameter of the function ```_OCRSpace_ImageGetText```, along with the rest of the optional or  required parameters.


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
3. Evaluate the string pointing to a url .
```Autoit
ConsoleWrite( _
			" Detected text        : " & $s_textdetected & @CRLF & _
			" Error Returned       : " & @error & @CRLF & _
			" Searchable PDF  Link : " & Eval("MyPDF_URL_") & @CRLF)
```
#### Example:
```autoit
While 1 ;Create a While that restart Polling
	$msgData = _Polling() ;_Polling function return an array with information about a message
	_SendMsg($msgData[2],$msgData[5]) ;Send a message to the same user with the same text
WEnd
```

For a simple text message, the array returned by _Polling() is:
```
$msgData[0] = Offset of the current update (used to 'switch' to the next update)
$msgData[1] = Message ID
$msgData[2] = Chat ID, use for interact with the user
$msgData[3] = Username of the user
$msgData[4] = First name of the user
$msgData[5] = Text of the message
```

If you want to try all the available features, use the Test file into /tests folder. Open it, insert your bot's token, your chat id **(make sure you have sent at least one message to the bot)** and then execute it.

## What you need to know
I'm writing a wiki, you can find it [here](https://github.com/xLinkOut/telegram-udf-autoit/wiki).

## Other credits
+ Thanks to d
+ 
## Legal
**License: GPL v3.0 ©** : Feel free to use this code and adapt it to your software; just mention this page if you share your software (free or paid).
This code is in no way affiliated with, authorized, maintained, sponsored or endorsed by Telegram and/or AutoIt or any of its affiliates or subsidiaries. This is independent and unofficial. Use at your own risk.

## About
If you want to donate for support my (future) works, use this: https://www.paypal.me/LCirillo. ❤️

For support, just contact me! Enjoy 🎉
