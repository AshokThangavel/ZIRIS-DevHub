Class ZIRIS.DevHub.Portal.OnGeneration Extends %Projection.AbstractProjection
{

ClassMethod CreateProjection(classname As %String, ByRef parameters As %String) As %Status
{
	If ##class(%Dictionary.CompiledClass).%ExistsId(classname){
		If classname = "ZIRIS.DevHub.Portal.Template"!(classname="ZIRIS.DevHub.Home") Return $$$OK
		Do ##class(ZIRIS.DevHub.Utils.Tools).SaveNewToolIntoList(classname)
	}
	Return $$$OK
}

ClassMethod RemoveProjection(classname As %String, ByRef parameters As %String) As %Status
{
	If ##class(ZIRIS.DevHub.DB.Utils).IsScreenExist(classname) {
		Do ##class(ZIRIS.DevHub.DB.Utils).DeleteDevTool(classname)
	}
	Return $$$OK
}

}
