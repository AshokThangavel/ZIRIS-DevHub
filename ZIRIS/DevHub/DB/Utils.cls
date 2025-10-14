Class ZIRIS.DevHub.DB.Utils Extends %RegisteredObject
{


ClassMethod CreateNewToolIntoList(pToolInfo As %DynamicObject) As %Status
{
	Set obj = ##class(ZIRIS.DevHub.DB.ToolDetails).%New()
	Set obj.ToolName = pToolInfo.Name
	Set obj.Category = pToolInfo.category
	Set obj.Description = pToolInfo.description
	Set obj.ToolPath = pToolInfo.cls
	Return obj.%Save()
}

ClassMethod GetToolsList()
{
	Set tStatement = ##class(%SQL.Statement).%ExecDirect(, "SELECT * FROM ZIRIS_DevHub_DB.ToolDetails")
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