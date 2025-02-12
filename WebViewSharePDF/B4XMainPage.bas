B4A=true
Group=Default Group
ModulesStructureVersion=1
Type=Class
Version=9.85
@EndOfDesignText@
#Region Shared Files
'#CustomBuildAction: folders ready, %WINDIR%\System32\Robocopy.exe,"..\..\Shared Files" "..\Files"
'Ctrl + click to sync files: ide://run?file=%WINDIR%\System32\Robocopy.exe&args=..\..\Shared+Files&args=..\Files&FilesSync=True
#End Region

'GitHub Desktop ide://run?file=%WINDIR%\System32\cmd.exe&Args=/c&Args=github&Args=..\..\
'Export as zip: ide://run?File=%B4X%\Zipper.jar&Args=%PROJECT_NAME%.zip

Sub Class_Globals
	Private Root As B4XView
	Private xui As XUI
	Private printer As Printer
	Private WebView1 As WebView
	Public provider As FileProvider
End Sub

Public Sub Initialize
'	B4XPages.GetManager.LogEvents = True
End Sub

Private Sub B4XPage_Created (Root1 As B4XView)
	Root = Root1
	Root.LoadLayout("MainPage")
	printer.Initialize("")
	provider.Initialize
	
	Dim html As String=$"
	
	<html dir='rtl' charset='UTF-8'>
	<head>
	<meta name='viewport' content='width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no'/>

	</head>
	<body>  <p class=MsoNormal dir=RTL style='margin-top:6.0pt;margin-right:14.2pt;
margin-bottom:3.0pt;margin-left:0cm;line-height:normal;
page-break-after:avoid'><a name="_Toc97034699"><span lang=AR-SA >
Simple, powerful and modern
development tools.
With B4X, anyone who wants to, can develop real-world solutions.
</span ></a></p>
<p class=MsoNormal dir=RTL><span dir=LTR>&nbsp;</span ></p>
</div>
	
	</body></html>

	"$
	WebView1.LoadHtml(html)
End Sub

Private Sub Button1_Click
	Dim x As B4XView = WebView1
	Dim bmp As B4XBitmap = x.Snapshot
	bmp = bmp.Resize(600, 600, True)
	File.Delete(File.DirInternal, "example.pdf")
	CreatePDF(bmp)
End Sub

Sub CreatePDF (bmp As Bitmap)
	Dim pdf As PdfDocument
	pdf.Initialize
	pdf.StartPage(595, 842) 'A4 size
	'pdf.Canvas.DrawLine(2, 2, 593 , 840, Colors.Blue, 4)
	'pdf.Canvas.DrawText("Hello", 100, 100, Typeface.DEFAULT_BOLD, 30 / GetDeviceLayoutValues.Scale , Colors.Yellow, "CENTER")
	Dim Rect As Rect
	Rect.Initialize(10, 10, 585, 832)
	pdf.Canvas.DrawBitmap(bmp, Null, Rect)
	pdf.FinishPage
	Dim out As OutputStream = File.OpenOutput(File.DirInternal, "example.pdf", False)
	pdf.WriteToStream(out)
	out.Close
	pdf.Close
	Log("PDF created successfully!")
	'OpenPDF
	SharePDF
End Sub

Public Sub OpenPDF
	File.Copy(File.DirInternal, "example.pdf", provider.SharedFolder, "example.pdf")
	'Dim filesize As Long = File.Size(provider.SharedFolder, "example.pdf")
	'Log(NumberFormat2(filesize/1024, 1, 2, 0, False) & "KB")
	Dim in As Intent
	in.Initialize(in.ACTION_VIEW, "")
	provider.SetFileUriAsIntentData(in, "example.pdf")
	in.SetType("application/pdf")
	StartActivity(in)
End Sub

Public Sub SharePDF
	File.Copy(File.DirInternal, "example.pdf", provider.SharedFolder, "example.pdf")
	'Dim filesize As Long = File.Size(provider.SharedFolder, "example.pdf")
	'Log(NumberFormat2(filesize/1024, 1, 2, 0, False) & "KB")
	Dim in As Intent
	in.Initialize(in.ACTION_SEND, "")
	provider.SetFileUriAsIntentData(in, File.Combine(provider.SharedFolder, "example.pdf"))
	in.SetPackage("com.whatsapp")
	in.PutExtra("android.intent.extra.STREAM", provider.GetFileUri("example.pdf"))
	in.SetType("application/pdf")
	StartActivity(in)
End Sub