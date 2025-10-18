Class ZIRIS.DevHub.Utils.Tools Extends %SYSTEM.Help
{

ClassMethod SaveNewToolIntoList(class As %String = "") As %Status
{
	#dim status As %Status = $$$OK

	If class="" Quit status

	If ##class(ZIRIS.DevHub.DB.Utils).IsScreenExist(class) Quit status

	If ##class(%Dictionary.CompiledClass).%ExistsId(class) {
		Set applicationName  = $Parameter(class,"APPLICATION")
		Set:applicationName="" applicationName=class
		Set category  = $Parameter(class,"CATEGORY")
		set:category="" category="General"
		If $SYSTEM.CLS.IsMthd(class,"AppDescription") {
			Set description = $ClassMethod(class,"AppDescription")
		}
		Set json = {"Name":(applicationName),"description":(description),"cls":(class_".cls"),"category":(category)}
		Set status = ##class(ZIRIS.DevHub.DB.Utils).CreateNewToolIntoList(json)
	}
	Return status
}
}