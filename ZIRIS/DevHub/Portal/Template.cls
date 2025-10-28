Class ZIRIS.DevHub.Portal.Template Extends %CSP.Page
{
Parameter Title As STRING;

Parameter APPLICATION As STRING;

Parameter CATEGORY As STRING = "General";

Projection OnGeneration As ZIRIS.DevHub.Portal.OnGeneration;

ClassMethod OnPage() As %Status
{
	Do ..OnPageCSPROOT()
	Quit 1
}

ClassMethod AppDescription()
{
	Q ""
}

ClassMethod OnPageCSPROOT() As %Boolean
{
	Do ..OnPageHTML()
}

ClassMethod OnPageHTML() As %Boolean
{
	Write "<html>"
	Write !
	Do ..OnPageHEAD()
	Do ..OnPageBODY()
	Write !,"</html>"
	Return $$$OK
}

ClassMethod OnPageHEAD() As %Boolean
{
	Write "<head>",!
	Write !,"<title>"_..#Title_"</title>",!
	Write "<style>",!
	Do ..LoadCSS()
	Write "</style>",!
	Write "</head>",!
	Write ..HyperEventHead(0,0)
	Return $$$OK
}

ClassMethod OnPageBODY() As %Boolean
{
	Do ..RenderScreen()
	Return $$$OK
}

/// Override this method to render your screens in UI
ClassMethod RenderScreen()
{
	Do ..OnRenderScreen()
	Do ..Scripts()
}
ClassMethod OnRenderScreen()
{
}
ClassMethod LoadCSS()
{
	Set obj = ##class(%Dictionary.CompiledXData).%OpenId($Classname()_"||Style")
	Return:(obj = "") $$$OK
	Set xdata = obj.Data
	Set status = ##class(%XML.TextReader).ParseStream(xdata, .textreader)
	While textreader.Read() { If (textreader.NodeType="chars") { Write textreader.Value } }
	Return $$$OK
}

/// Write your javascripts here within &HTML< ... >
ClassMethod Scripts()
{
}
/// Write your styles here
XData Style
{
<data>
	<![CDATA[
	]]>>
</data>
}


}