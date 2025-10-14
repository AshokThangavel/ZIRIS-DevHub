Class ZIRIS.DevHub.DB.ToolDetails Extends %Persistent
{

Parameter DEFAULTGLOBAL As STRING = "^ZIRIS.DevTools";

Property ToolName As %String(MAXLEN = 100);

Property Description As %String(MAXLEN = 500);

Property Category As %String;

Property ToolPath As %String(MAXLEN = 500);
}