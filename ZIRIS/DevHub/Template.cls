/// Base class for all CSP classes in the ZIRIS.DevHub.* package.
/// All ZIRIS.DevHub.* CSP classes should extend this class.

Class ZIRIS.DevHub.Template Extends %CSP.Page
{


Parameter APPLICATION As STRING;

Parameter CATEGORY As STRING = "General";

ClassMethod OnPage() As %Status
{
	Do ##super()
	Quit 1
}

ClassMethod StoreScreen() [ CodeMode = objectgenerator, GenerateAfter = OnAfterClassCompile ]
{
	Set class = %class.Name
	If ##class(%Dictionary.CompiledClass).%ExistsId(class){
		If class = "ZIRIS.DevHub.Template"!(class="ZIRIS.DevHub.Home") Quit $$$OK
		Do ##class(ZIRIS.DevHub.Utils.Tools).SaveNewToolIntoList(class)
	}
	Quit $$$OK
}

/*
Method OnAfterClassCompile() As %Status
{
    Set class = %class.Name
	If class = "ZIRIS.DevHub.Template"!(class="ZIRIS.DevHub.Home") Quit $$$OK
	Do ##class(ZIRIS.DevHub.Utils.Tools).SaveNewToolIntoList(class)
	Quit $$$OK
}
*/
ClassMethod AppDescription()
{
	Q ""
}

}
