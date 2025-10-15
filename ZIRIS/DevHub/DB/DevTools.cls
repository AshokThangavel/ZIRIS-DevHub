Class ZIRIS.DevHub.DB.DevTools Extends %Persistent
{
Parameter DEFAULTGLOBAL As STRING = "^ZIRIS.DevHub.DevTools";

Property ToolName As %String(MAXLEN = 100);

Property Description As %String(MAXLEN = 500);

Property Category As %String;

Property ToolPath As %String(MAXLEN = 500);

Property Enabled As %String [ InitialExpression = 1 ];

Index ToolNameIdx On ToolName [ IdKey, Unique ];
}