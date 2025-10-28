Class ZIRIS.DevHub.Tools.FocusBoard.Data.Task Extends (%Persistent, %JSON.Adaptor)
{

Parameter DEFAULTGLOBAL As STRING = "^ZIRIS.DevHub.FocusBoard.Tasks";

Property Title As %String(%JSONFIELDNAME = "title", MAXLEN = 200);

Property Description As %String(%JSONFIELDNAME = "description", MAXLEN = 2000);

Property Status As %Integer(%JSONFIELDNAME = "status", DISPLAYLIST = ",new,completed,planned,active,overdue", VALUELIST = ",0,1,2,3,-1") [ InitialExpression = 0 ];

Property Priority As %Integer(%JSONFIELDNAME = "priority", DISPLAYLIST = ",normal,high,critical", VALUELIST = ",0,1,2") [ InitialExpression = 0 ];

Property CreatedAt As %TimeStamp [ InitialExpression = {$ZDATETIME($NOW(),3,1)} ];

Property IsArchived As %Boolean [ InitialExpression = 0 ];

Property ArchivedDate As %TimeStamp;

Index StatusIdx On Status [ Type = bitmap ];

Index PriorityIdx On Priority [ Type = bitmap ];

ClassMethod SaveData(pTaskDetails As %DynamicObject)
{
	If pTaskDetails.%IsDefined("id")  {
		If ..%ExistsId(pTaskDetails.id) {
			Set obj = ..%OpenId(pTaskDetails.id)
		}
		Else {
			Set obj = ..%New()
		}
	}
	Else {
		Set obj = ..%New()
	}
	Do ..UpdateJSONValues(pTaskDetails)
	Do obj.%JSONImport(pTaskDetails)
	Set st = obj.%Save()
	Return st
}

ClassMethod UpdateJSONValues(pJSON As %DynamicObject)
{
	If pJSON.%IsDefined("status") {
		Set pJSON.status = ..GetStatusInt(pJSON.status)
	}
		If pJSON.%IsDefined("priority") {
		Set pJSON.priority = ..GetPriorityInt(pJSON.priority)
	}
}

ClassMethod GetStatusInt(pStr) As %Integer [ CodeMode = expression ]
{
$Case($Zcvt(pStr,"L"),
	   "new": 0,
	   "completed":1,
	   "planned":2,
	   "active":3,
	   :-1
	   )
}

ClassMethod GetPriorityInt(pStr) As %Integer [ CodeMode = expression ]
{
$Case($Zcvt(pStr,"L"),
	   "high": 1,
	   "critical":2,
	   :0
	   )
}

ClassMethod UpdateTaskStatus(taskId As %Integer, newStatus As %String) As %Status
{
    #dim status As %Status = $$$OK
	If ..%ExistsId(taskId) {
		Set obj = ..%OpenId(taskId)
		Set obj.Status = obj.GetStatusInt(newStatus)
		Set status = obj.%Save()
	}
    Return status
}

ClassMethod ArchiveTask(pTaskId As %Integer) As %Status
{
    #dim status As %Status = $$$OK
    
	If ..%ExistsId(pTaskId) {
		Set obj = ..%OpenId(pTaskId)
		Set obj.IsArchived=1
		Set obj.ArchivedDate = $ZDATETIME($NOW(),3,1)
		Set status = obj.%Save()
	}
	Return status
}

ClassMethod RestoreTask(pTaskId) As %Status
{
    #dim status As %Status = $$$OK
	If ..%ExistsId(pTaskId) {
		Set obj = ..%OpenId(pTaskId)
		Set obj.IsArchived=0
		Set st = obj.%Save()
	}
	Return status
}

ClassMethod DeleteArchivedTask(pTaskId) As %Status [ CodeMode = expression ]
{
..%DeleteId(pTaskId)
}

ClassMethod GetTaskList() As %String
{
	#SQLCompile Select=Display
	&SQL(
	SELECT
		JSON_ARRAYAGG(
		  JSON_OBJECT(
		   'id':id,
		   'title':Title,
		   'description':Description,
		   'createdat':CreatedAt,
		   'status':Status,
		   'priority':Priority
		  )
		)
	INTO :taskData
	FROM ZIRIS_DevHub_Tools_FocusBoard_Data.Task
	WHERE IsArchived=0
	)
	Return taskData
}

ClassMethod GetArchivedTasks()
{
	#SQLCompile Select=Display
	&SQL(
	SELECT
		JSON_ARRAYAGG(
		  JSON_OBJECT(
		   'id':id,
		   'title':Title,
		   'description':Description,
		   'createdat':CreatedAt,
		   'status':Status,
		   'priority':Priority,
		   'archivedDate':ArchivedDate
		  )
		)
	INTO :taskData
	FROM ZIRIS_DevHub_Tools_FocusBoard_Data.Task
	WHERE IsArchived=1
	)
	Return taskData
}
}