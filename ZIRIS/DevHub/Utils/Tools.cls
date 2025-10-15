Class ZIRIS.DevHub.Utils.Tools Extends %SYSTEM.Help
{

/// this method is used to collect all the packages under
/// ZIRIS.DevHub.*(except DB,Utils package) and create tools entire in <class>ZIRIS.DevHub.DB.ToolDetails</class>
ClassMethod CollectToolsList()
{
	#define ZIRISDevHub "ZIRIS.DevHub"

	Try {
		Set tResult = ##class(%SQL.Statement).%ExecDirect(,"SELECT Name FROM %Dictionary.ClassDefinitionQuery_SubclassOf(?)","ZIRIS.DevHub.Template")
		While tResult.%Next() {
			Set description = ""
			Set class = tResult.Name
			Set applicationName  = $Parameter(class,"APPLICATION")
			Set category  = $Parameter(class,"CATEGORY")
			If $SYSTEM.CLS.IsMthd(class,"AppDescription") {
				Set description = $ClassMethod(class,"AppDescription")
			}
			Set json = {"Name":(applicationName),"description":(description),"cls":(class_".cls"),"category":(category)}
			Set sc = ##class(ZIRIS.DevHub.DB.Utils).CreateNewToolIntoList(json)
		}
	}
	Catch ex {
		Set err = ex.%BinDisplayString()
		Do LOG^%ETN(err)
		Set ^ZIRIS.DEveHub.Error($NOW())= err
	}
}

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