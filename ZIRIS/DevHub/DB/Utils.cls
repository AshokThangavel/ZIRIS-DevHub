Class ZIRIS.DevHub.DB.Utils Extends %SYSTEM.Help
{
ClassMethod IsScreenExist(pClass) [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.DB.DevTools).%ExistsId(pClass)
}
ClassMethod DeleteDevTool(pClass) [ CodeMode = expression ]
{
##class(ZIRIS.DevHub.DB.DevTools).%DeleteId(pClass)
}

ClassMethod CreateNewToolIntoList(pToolInfo As %DynamicObject) As %Status
{
	Set obj = ##class(ZIRIS.DevHub.DB.DevTools).%New()
	Set obj.ToolName = pToolInfo.Name
	Set obj.Category = pToolInfo.category
	Set obj.Description = pToolInfo.description
	Set obj.ToolPath = pToolInfo.cls
	Return obj.%Save()
}

ClassMethod GetToolsList()
{
	Set tStatement = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM ZIRIS_DevHub_DB.DevTools")
	Set response = []
	While tStatement.%Next() {
		Do response.%Push({
			"name":(tStatement.ToolName),
			"cls":(tStatement.ToolPath),
			"description":(tStatement.Description),
			"category":(tStatement.Category)
		})
	}
	Return response.%ToJSON()
}

}