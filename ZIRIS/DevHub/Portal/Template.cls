Class ZIRIS.DevHub.Portal.Template Extends %CSP.Page
{

Parameter APPLICATION As STRING;

Parameter CATEGORY As STRING = "General";

Projection OnGeneration As ZIRIS.DevHub.Portal.OnGeneration;

ClassMethod OnPage() As %Status
{
	Do ##super()
	Quit 1
}

ClassMethod AppDescription()
{
	Q ""
}

}